# AGENTS.md – הנחיות מחייבות לסוכני AI (צוות 2: Core CRUD & Data Service)

קובץ זה מגדיר את הארכיטקטורה, הפורמטים, חוזי ה-API וכללי הברזל עבור כל סוכן AI (Antigravity, Claude Code, Cursor, Copilot) הפועל במאגר הקוד של **צוות 2**.

## 1. הקשר המערכת ותפקיד השירות
אנו בונים את שירות הליבה וניהול הנתונים (**Core CRUD & Data Service**) עבור פלטפורמה לסיוע בטיפול רגשי בילדים באמצעות דמות אנימציה אינטראקטיבית.
* **תפקיד השירות:** "שומר הסף" של כל המידע הקבוע (Persistent Data), ניהול משתמשים והרשאות (RBAC + JWT), הצפנת מידע רגיש של קטינים במנוחה (AES-256-GCM), קטלוג דמויות ובנק אנימציות, ותיעוד סשנים ופרוטוקולי שיחה.
* **מסמך האפיון המלא:** קרא תמיד את [`docs/TEAM2_SPEC.md`](docs/TEAM2_SPEC.md) לפני מימוש כל פיצ'ר.
* **רשימת ה-Issues והמשימות:** קרא את [`docs/ISSUES_TASKS.md`](docs/ISSUES_TASKS.md).
* **חוזה סנכרון חתימות מחייב בין כל הסוכנים בצוות (חובה לקרוא לפני קידוד!):** קרא את **[`docs/AGENT_SYNC_CONTRACT.md`](docs/AGENT_SYNC_CONTRACT.md)** – קובץ זה מגדיר את שמות המחלקות, השדות וחתימות המתודות המדויקות בין כל 9 ה-Issues כדי למנוע התנגשויות ושגיאות קומפילציה בין חברי הצוות.

---

## 2. סטאק טכנולוגי ומבנה חבילות (Package Structure)
* **שפה ופריימוורק:** Java 21, Spring Boot 3.3.x
* **שכבת נתונים:** Spring Data JPA (Hibernate 6), PostgreSQL
* **אבטחה:** Spring Security 6, JWT (JJWT), AES-256-GCM Attribute Encryption
* **תיעוד API:** SpringDoc OpenAPI 3 (`swagger-ui`)
* **בדיקות:** JUnit 5, Mockito, Spring Boot Test (עם H2/Testcontainers לבדיקות)

### מבנה התיקיות המחייב תחת `src/main/java/com/therapy/coredataservice/`:
```text
com.therapy.coredataservice
├── config/          # הגדרות OpenAPI/Swagger, CORS, DataSeeder
├── crypto/          # CryptoService ו-CryptoAttributeConverter (AES-256-GCM)
├── security/        # JwtService, JwtAuthenticationFilter, InternalApiKeyFilter, SecurityConfig
├── entity/          # ישויות JPA בלבד (Therapist, Patient, CharacterEntity, AnimationTrigger, TherapySession, TranscriptEntry, AuditLog)
├── repository/      # ממשקי JpaRepository
├── dto/
│   ├── auth/        # LoginRequest, AuthResponse, TherapistProfileDto
│   ├── patient/     # PatientCreateUpdateDto, PatientResponseDto, PatientSummaryDto
│   ├── character/   # CharacterDto, AnimationTriggerDto
│   ├── session/     # SessionCreateRequestDto, SessionResponseDto, SessionNotesPatchDto, TranscriptEntryDto
│   ├── internal/    # SessionAiContextResponseDto, SessionCompleteRequestDto, SessionCompleteResponseDto
│   └── common/      # ApiErrorResponse
├── service/         # לוגיקה עסקית, וידוא בעלות מטפל (Tenant Isolation), וסינון PII מול ה-AI
├── controller/      # REST Controllers עבור חוזה 1 (/api/v1/...) וחוזה 5 (/internal/api/v1/...)
└── exception/       # GlobalExceptionHandler, ResourceNotFoundException, ForbiddenAccessException
```

---

## 3. כללי ברזל ואבטחת מידע (אסור לחרוג!)

1. **הפרדת Entity מ-DTO:**
   * לעולם אל תחזיר ואל תקבל מחלקת `@Entity` ישירות בתוך `@RestController`. תמיד השתמש במחלקות ה-DTO המתאימות מתוך חבילת `dto/`.
2. **הצפנה במנוחה (Encryption at Rest - AES-256-GCM):**
   * כל שדה רגיש ב-`Patient` (`displayAlias`, `personalDetails`, `emotionalBackground`, `interestsAndSafeTopics`, `longTermGoals`, `therapistNotes`) וב-`TherapySession` / `TranscriptEntry` (`sessionGoals`, `focusTopics`, `sensitiveBoundaries`, `therapistSessionNotes`, `aiSummary`, `content`) **חייב** להיות מסומן ב-`@Convert(converter = CryptoAttributeConverter.class)`.
3. **איסור מוחלט על חשיפת פרטים מזהים (PII) למודל ה-AI (חוזה 5):**
   * ב-Endpoint הפנימי `GET /internal/api/v1/sessions/{sessionId}/context` (הנקרא על ידי צוות 3 - AI), **אסור בשום אופן** לכלול את השדה `personalDetails` (שם משפחה, ת"ז, כתובת, פרטי הורים) או את `therapistNotes` (הערות פרטיות של המטפל).
   * ה-DTO `SessionAiContextResponseDto` יכלול אך ורק: `displayAlias` (שם פרטי/כינוי), `age`, `emotionalBackground`, `interestsAndSafeTopics`, `longTermGoals`.
4. **בידוד נתונים בין מטפלים (Tenant Isolation):**
   * בכל פעולה של מטפל על מטופל או סשן (`/api/v1/patients/**`, `/api/v1/sessions/**`), המזהה `therapistId` נלקח **אך ורק מתוך ה-`SecurityContext` (ה-JWT המאומת)** – לעולם לא מתוך פרמטר שהמשתמש שלח ב-Body.
   * אם מטפל מנסה לגשת ל-`patientId` או `sessionId` שאינם שייכים לו, יש להחזיר `403 Forbidden` או `404 Not Found`.
5. **הפרדת אימות בין חוזה 1 לחוזה 5:**
   * נתיבי `/api/v1/**` (חוזה 1 מול צוות 1 - פרונט מטפל) מוגנים באמצעות `Authorization: Bearer <JWT>` עם תפקיד `ROLE_THERAPIST`.
   * נתיבי `/internal/api/v1/**` (חוזה 5 מול צוות 3 וצוות 5) מוגנים באמצעות Header פנימי `X-Internal-Service-Key` הנבדק מול משתנה הסביבה `INTERNAL_SERVICE_API_KEY`.

---

## 4. פורמט JSON אחיד לשגיאות (Error Format)
כל שגיאה שמוחזרת מהשרת (דרך `GlobalExceptionHandler`) חייבת לחזור במבנה האחיד הבא:
```json
{
  "timestamp": "2026-11-16T18:30:00Z",
  "status": 400,
  "error": "Bad Request",
  "message": "תיאור ברור של השגיאה",
  "path": "/api/v1/patients"
}
```

---

## 5. נוהל עבודה לסוכן בעת ביצוע Issue
1. קרא את תיאור ה-Issue ב-[`docs/ISSUES_TASKS.md`](docs/ISSUES_TASKS.md).
2. ודא שאתה נמצא בענף (Branch) המתאים (`feat/issue-<number>-<slug>`) ולא בענף `main`.
3. ממש את הקוד תוך שמירה מדויקת על שמות השדות ב-JSON כפי שהוגדרו ב-[`docs/TEAM2_SPEC.md`](docs/TEAM2_SPEC.md).
4. כתוב בדיקות יחידה/אינטגרציה (`src/test/java/...`) המוודאות שהקוד מתקמפל ועובר `./mvnw test` בהצלחה.
