---
name: team2-spring-conventions
description: >-
  Use this skill whenever implementing any Issue, Entity, Repository, Service, Controller,
  DTO, Security filter, or AES-256 encryption class in the Team 2 (Core CRUD & Data Service)
  SpringBoot repository. Enforces exact package structure, JSON field names for Contract 1
  and Contract 5, PII stripping for AI Context, and tenant isolation per therapist.
---

# Team 2 – SpringBoot & API Contract Conventions

When implementing a feature or GitHub Issue in this repository, follow these steps strictly:

## 1. Before Writing Code
1. Read [`AGENTS.md`](../../../AGENTS.md) for package structure and security guardrails.
2. Read [`docs/TEAM2_SPEC.md`](../../../docs/TEAM2_SPEC.md) for the exact JSON schemas of **Contract 1** (with Team 1) and **Contract 5** (with Teams 3 & 5).
3. Read [`docs/ISSUES_TASKS.md`](../../../docs/ISSUES_TASKS.md) to verify the exact files owned by your Issue so you do not create merge conflicts with other team members.

## 2. Coding Standards
* **Java Records for DTOs:** Prefer Java 21 `record` types (with Jakarta Validation annotations `@NotBlank`, `@NotNull`, `@Min`, `@Max`) for all Request and Response DTOs under `com.therapy.coredataservice.dto.*`.
* **Field-Level Encryption (`@Convert`):** Every sensitive clinical or personal `String` field in `Patient`, `TherapySession`, and `TranscriptEntry` MUST have `@Convert(converter = CryptoAttributeConverter.class)`.
* **PII Stripping on Contract 5:** When mapping a `Patient` entity to `SessionAiContextResponseDto.PatientContextDto` for `GET /internal/api/v1/sessions/{sessionId}/context`, NEVER include `personalDetails` or `therapistNotes`.
* **Tenant Isolation on Contract 1:** Every service method serving `/api/v1/**` must take `UUID authenticatedTherapistId` and verify ownership (`repository.findByIdAndTherapistId(...)`).
* **Swagger Annotations:** Annotate every `@RestController` method with `@Operation(summary = "...")` from `io.swagger.v3.oas.annotations.Operation`.

## 3. Verification Step
Always run `./mvnw test` (or `mvn test`) after implementing your Issue and verify all unit/integration tests pass before committing.
