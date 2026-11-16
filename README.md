# צוות 2: Core CRUD & Data Service ("שומר הסף") 🛡️

ברוכים הבאים ל-Repository הרשמי של **צוות 2 – באקנד נתונים וקריאות** בפרויקט **פלטפורמה לסיוע בטיפול רגשי בילדים באמצעות דמות אנימציה אינטראקטיבית**.

### 👥 חברי הצוות
* **יוסי גלר** (`@yossi-turing`) – מנהל צוות
* **איתמר אהרונוב** (`@eitamr717`)
* **אוהד סבג** (`@ohadjobs2`)
* **אליה גבאי** (`@EliaGabay`)
* **משה אנידג'ר**

---

## 📚 1. מסמכי החובה שיש לקרוא לפני שמתחילים
לפני כתיבת שורת קוד אחת, כל חבר צוות (והסוכן שלו!) חייב לעבור על הקבצים הבאים ברפו:
1. **[`docs/TEAM2_SPEC.md`](docs/TEAM2_SPEC.md)** (או קובץ ה-Word ב-[`docs/Team2_Detailed_Spec_Yossi_Geller.docx`](docs/Team2_Detailed_Spec_Yossi_Geller.docx)) – מסמך האפיון המורחב של צוות 2, כולל סכמת ה-DB וחוזי ה-API מול צוותים 1, 3 ו-5.
2. **[`AGENTS.md`](AGENTS.md)** – קובץ ההנחיות לסוכני ה-AI (Antigravity / Claude Code / Cursor). הקובץ מגדיר לסוכן בדיוק באיזה פורמט לכתוב את הקוד, ה-DTOs, ההצפנה וה-Endpoints.
3. **[`docs/ISSUES_TASKS.md`](docs/ISSUES_TASKS.md)** – פירוט כל ה-Issues (משימות הפיתוח) של הצוות, מה בדיוק כל Issue דורש, ואילו קבצים צריך ליצור בו.

---

## 🤖 2. הגדרת סוכן ה-AI והורדת סקילים מומלצים
הרפו שלנו כבר מכיל תיקיית **`.agents/skills/`** וצמד קובצי **`AGENTS.md` / `GEMINI.md`** שנטענים אוטומטית ברגע שאתם פותחים את התיקייה ב-**Google Antigravity** (או כל סוכן תומך).

### מה מומלץ להתקין אצלכם בסוכן (Marketplace / Skills):
1. **Superpowers (`obra/superpowers`)** – סקילים לכתיבת תוכניות עבודה (`writing-plans`), פיתוח מונחה בדיקות (`TDD`) ודיבאגינג שיטתי.
2. **Postman** – סקיל לתכנון ובדיקת חוזי ה-REST API שלנו.
3. **Context7** – שליפת תיעוד עדכני בזמן אמת ל-Spring Boot 3, Hibernate 6 ו-Spring Security 6.
4. **Anthropic Official Skills (`anthropics/skills`)** – לקריאה ועבודה עם מסמכי האפיון (`docx`, `doc-coauthoring`).

### איך לעבוד עם הסוכן על משימה (Prompt מומלץ):
אחרי שבחרתם Issue ופתחתם ענף (Branch), שלחו לסוכן שלכם את ההודעה הבאה:
> *"תעבור על הרפו, תקרא את `AGENTS.md`, את `docs/TEAM2_SPEC.md` ואת `docs/ISSUES_TASKS.md`. אני עובד עכשיו על **Issue #X**. תכנן וממש עבורי את כל המחלקות והבדיקות שנדרשות עבור ה-Issue הזה בדיוק לפי הפורמטים והסטנדרטים שהוגדרו ברפו."*

---

## 🌿 3. נוהל עבודה ב-Git וניהול משימות (Issues Workflow)

אנחנו עובדים במתכונת מסודרת של **GitHub Issues + Feature Branches** כדי שאף אחד לא ידרוס קוד של מפתח אחר:

1. **שיבוץ ל-Issue:**
   * היכנסו ללשונית **Issues** ב-GitHub.
   * בחרו את ה-Issue שלכם ושבצו את עצמכם תחת **Assignees** (או הגיבו ב-Issue שאתם לוקחים אותו).
2. **פתיחת ענף (Branch) ייעודי ל-Issue:**
   * **אסור לדחוף קוד ישירות ל-`main`!**
   * משכו את הגרסה האחרונה של `main` ופתחו ענף חדש לפי הפורמט `feat/issue-<number>-<short-topic>`:
     ```bash
     git checkout main
     git pull origin main
     git checkout -b feat/issue-1-jpa-entities
     ```
3. **פיתוח ובדיקה מקומית:**
   * הריצו את מסד הנתונים המקומי ב-Docker:
     ```bash
     docker compose up -d
     ```
   * הריצו את הפרויקט ואת הטסטים:
     ```bash
     ./mvnw clean test
     ./mvnw spring-boot:run
     ```
   * בדקו ב-Swagger UI שה-Endpoints שלכם עובדים תקין: `http://localhost:8080/swagger-ui.html`
4. **פתיחת Pull Request (PR):**
   * דחפו את הענף ל-GitHub:
     ```bash
     git add .
     git commit -m "feat(issue-1): implement JPA entities and repositories"
     git push -u origin feat/issue-1-jpa-entities
     ```
   * פתחו **Pull Request** אל ענף `main`, רשמו בתיאור `Closes #1` (מספר ה-Issue שלכם), ובקשו Review מראש הצוות (**יוסי גלר**).

---

## 🛠️ 4. דרישות קדם (Prerequisites) להרצה מקומית
* **Java 21 JDK**
* **Maven 3.9+** (או שימוש ב-Maven Wrapper המובנה)
* **Docker Desktop** (להרצת PostgreSQL מקומי דרך `docker-compose.yml`)
