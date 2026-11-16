param(
    [string]$RepoName = "team2-core-data-service",
    [string]$Visibility = "public"
)

$ErrorActionPreference = "Continue"
Set-Location "C:\Users\WIN11\.gemini\antigravity\scratch\team2-core-data-service"

Write-Host "1. Creating GitHub repository '$RepoName' and pushing 'main' branch..." -ForegroundColor Cyan
gh repo create $RepoName --$Visibility --source=. --remote=origin --push

$RepoFullName = (gh repo view --json nameWithOwner -q ".nameWithOwner").Trim()
Write-Host "Repository created: https://github.com/$RepoFullName" -ForegroundColor Green

# 2. Invite Team 2 Collaborators
$Collaborators = @("ohadjobs2", "eitamr717", "EliaGabay")
foreach ($user in $Collaborators) {
    Write-Host "Inviting collaborator @$user..." -ForegroundColor Cyan
    gh api --method PUT "repos/$RepoFullName/collaborators/$user" -f permission=push | Out-Null
    Write-Host "  -> Invited @$user" -ForegroundColor Green
}

# 3. Create the 9 Structured Issues for Team 2
$Issues = @(
    @{
        Title = 'Issue #1: Field-Level DB Encryption (AES-256-GCM) & Audit Log'
        Body  = @'
See full specification in `docs/ISSUES_TASKS.md` (Issue #1) and `docs/TEAM2_SPEC.md` (Section 4).

- **Branch:** `feat/issue-1-crypto-and-audit`
- **Recommended Assignee:** @eitamr717

### Tasks:
- [ ] Implement `CryptoService` (`AES/GCM/NoPadding` with 12-byte IV)
- [ ] Implement `CryptoAttributeConverter` (`AttributeConverter<String, String>`)
- [ ] Implement `AuditLog` entity, `AuditLogRepository`, and `AuditLogService`
- [ ] Add unit tests (`CryptoAttributeConverterTest`)
'@
    },
    @{
        Title = 'Issue #2: Spring Security, Therapist JWT Auth & Internal Service Key Filter'
        Body  = @'
See full specification in `docs/ISSUES_TASKS.md` (Issue #2) and `docs/TEAM2_SPEC.md` (Section 2.1 & 5.1).

- **Branch:** `feat/issue-2-security-jwt`
- **Recommended Assignee:** @eitamr717

### Tasks:
- [ ] Implement `JwtService` & `JwtAuthenticationFilter` for `/api/v1/**`
- [ ] Implement `InternalApiKeyFilter` (`X-Internal-Service-Key`) for `/internal/api/v1/**`
- [ ] Implement `SecurityConfig` & `AuthController` (`POST /api/v1/auth/login`, `GET/PUT /api/v1/therapists/me`)
'@
    },
    @{
        Title = 'Issue #3: Hibernate Entities & Repositories for Therapist and Patient'
        Body  = @'
See full specification in `docs/ISSUES_TASKS.md` (Issue #3) and `docs/TEAM2_SPEC.md` (Section 3.1 & 3.2).

- **Branch:** `feat/issue-3-patient-entities`
- **Recommended Assignee:** משה אנידג'ר

### Tasks:
- [ ] Implement `Therapist` entity & `TherapistRepository`
- [ ] Implement `Patient` entity (with `@Convert(converter = CryptoAttributeConverter.class)` on all sensitive fields) & `PatientRepository`
'@
    },
    @{
        Title = 'Issue #4: Hibernate Entities, Repositories & Data Seeder for Character & Animation Catalog'
        Body  = @'
See full specification in `docs/ISSUES_TASKS.md` (Issue #4) and `docs/TEAM2_SPEC.md` (Section 3.3).

- **Branch:** `feat/issue-4-character-catalog-entities`
- **Recommended Assignee:** @ohadjobs2

### Tasks:
- [ ] Implement `CharacterEntity` and `AnimationTrigger` entities
- [ ] Implement `CharacterRepository` and `AnimationTriggerRepository`
- [ ] Implement `CharacterDataSeeder` to seed initial 3D characters and animation trigger IDs (`WAVE_HELLO`, `IDLE_LISTEN`, `THINKING`, `CLAP_HAPPY`, etc.)
'@
    },
    @{
        Title = 'Issue #5: Hibernate Entities & Repositories for TherapySession and TranscriptEntry'
        Body  = @'
See full specification in `docs/ISSUES_TASKS.md` (Issue #5) and `docs/TEAM2_SPEC.md` (Section 3.4).

- **Branch:** `feat/issue-5-session-transcript-entities`
- **Recommended Assignee:** @ohadjobs2 / משה אנידג'ר

### Tasks:
- [ ] Implement `SessionStatus` and `SpeakerType` enums
- [ ] Implement `TherapySession` and `TranscriptEntry` entities with AES-256 `@Convert` on sensitive fields
- [ ] Implement `TherapySessionRepository`
'@
    },
    @{
        Title = 'Issue #6: Patient CRUD REST API (Contract 1 - with Team 1)'
        Body  = @'
See full specification in `docs/ISSUES_TASKS.md` (Issue #6) and `docs/TEAM2_SPEC.md` (Section 5 - Contract 1.2).

- **Branch:** `feat/issue-6-patient-crud-api`
- **Recommended Assignee:** @EliaGabay

### Tasks:
- [ ] Implement Patient DTOs (`PatientCreateUpdateDto`, `PatientResponseDto`, `PatientSummaryDto`)
- [ ] Implement `PatientService` enforcing therapist ownership from JWT
- [ ] Implement `PatientController` (`GET/POST /api/v1/patients`, `GET/PUT /api/v1/patients/{patientId}`)
'@
    },
    @{
        Title = 'Issue #7: Character & Animation Catalog REST API (Contract 1 - with Team 1)'
        Body  = @'
See full specification in `docs/ISSUES_TASKS.md` (Issue #7) and `docs/TEAM2_SPEC.md` (Section 5 - Contract 1.3).

- **Branch:** `feat/issue-7-character-catalog-api`
- **Recommended Assignee:** @EliaGabay

### Tasks:
- [ ] Implement `CharacterDto` and `AnimationTriggerDto`
- [ ] Implement `CharacterService` and `CharacterController` (`GET /api/v1/characters`)
'@
    },
    @{
        Title = 'Issue #8: Therapist Session Management & History REST API (Contract 1 - with Team 1)'
        Body  = @'
See full specification in `docs/ISSUES_TASKS.md` (Issue #8) and `docs/TEAM2_SPEC.md` (Section 5 - Contract 1.4).

- **Branch:** `feat/issue-8-therapist-sessions-api`
- **Recommended Assignee:** @yossi-turing

### Tasks:
- [ ] Implement Session DTOs & `SessionService`
- [ ] Implement `SessionController` (`POST /api/v1/sessions`, `GET /api/v1/patients/{patientId}/sessions`, `GET /api/v1/sessions/{sessionId}`, `PATCH /api/v1/sessions/{sessionId}/notes`)
'@
    },
    @{
        Title = 'Issue #9: Internal AI Context & Session Completion API (Contract 5 - with Teams 3 & 5)'
        Body  = @'
See full specification in `docs/ISSUES_TASKS.md` (Issue #9) and `docs/TEAM2_SPEC.md` (Section 5 - Contract 5).

- **Branch:** `feat/issue-9-internal-ai-orchestrator-api`
- **Recommended Assignee:** @yossi-turing

### Tasks:
- [ ] Implement `GET /internal/api/v1/sessions/{sessionId}/context` with strict PII stripping (never expose `personalDetails` or `therapistNotes` to AI)
- [ ] Implement `POST /internal/api/v1/sessions/{sessionId}/complete` to persist full word-for-word transcript and session duration
'@
    }
)

Write-Host "3. Creating GitHub Issues..." -ForegroundColor Cyan
foreach ($issue in $Issues) {
    gh issue create --title $issue.Title --body $issue.Body
}

Write-Host "All done! Team 2 repository, collaborators, and Issues are live at: https://github.com/$RepoFullName" -ForegroundColor Green
