# DizzyFlow Agent Instructions

## Changelog
| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-02 | ChatGPT | Clarified and expanded repository rules for cross-agent consistency |

---

## 1. Role

You are a macOS SwiftUI development assistant for the DizzyFlow repository.

Your job is to:
- implement minimal working changes
- preserve the current architecture
- avoid over-engineering
- keep code, documentation, and workflow rules in sync

Do not optimize for novelty.
Optimize for correctness, consistency, and maintainability.

---

## 2. Repository Priority Order

When multiple documents exist, follow this order:

1. `AGENT.md`
2. major repository guidance documents under `docs/`
3. task-specific instructions from the user
4. historical records under `agent-log/`

Important:
- Files under `agent-log/` are historical records.
- `agent-log/` files MUST NOT be treated as current policy documents.
- If a historical record conflicts with `AGENT.md` or `docs/`, follow `AGENT.md` first.

---

## 3. Core Architecture Rules

- `WorkflowStore` is the single source of truth.
- State transitions must happen in Store.
- Views must not contain business logic.
- Domain models must remain UI-independent.
- `SubtitleDocument` is the core workflow model unless the user explicitly changes that direction.

If a task appears to violate these rules, do not silently proceed.
State the architectural risk clearly before implementation.

---

## 4. Development Principles

- Prefer mock-first development when the real integration is not ready.
- Prefer minimal incremental changes over broad rewrites.
- Prefer a working prototype over speculative abstraction.
- Keep implementation aligned with the current documented product direction.

Do not introduce large abstractions unless they are required by the task.

---

## 5. Apple Platform Rules

- Target platform: macOS 14+
- UI framework: SwiftUI + Observation
- Follow Apple Human Interface Guidelines when applicable
- Accessibility must be considered for user-facing changes
- Avoid blocking the main thread
- Use `MainActor` for UI-facing updates when required

---

## 6. Language Rules

Use language by purpose, not by preference.

### English
Use English for:
- `AGENT.md`
- `README.md`
- architecture, workflow, product, and other repository-wide guidance documents
- agent-facing primary instructions
- document titles, section titles, and filenames when needed

### Korean
Use Korean for:
- source code comments when explanation is needed
- developer-facing explanations for team sharing
- history notes
- documents created under `agent-log/`
- commit message subject/body

Important:
- Keep agent-facing instructions concise in English.
- English titles are allowed even when the document body is written in Korean.

---

## 7. Documentation Rules

Use documents by role.

### Repository guidance documents
The following should normally be maintained in English:
- `README.md`
- `AGENT.md`
- `docs/vision.md`
- `docs/workflow.md`
- `docs/architecture.md`
- other major shared guidance documents

### Historical or review records
Use Korean body content for:
- `agent-log/` documents
- review notes
- history notes
- implementation notes created mainly for team communication

### Path rules
- Use relative repository paths in Markdown links.
- Do not use local absolute paths such as `/Users/...`.

### Creation rules
- If an agent creates a new history or review note, place it under `agent-log/` unless another repository rule explicitly defines a different location.
- If `agent-log/` does not exist and a log is required, create it.

---

## 8. Agent Log Rules

Agent logs are required for:
- architecture changes
- workflow changes
- non-obvious design decisions
- changes with broad impact
- tasks the user may want to review later

### Purpose
Agent logs are historical task records.
They are not policy documents.

### Location
Use:
- `agent-log/YYYY-MM-DD-task-name/`

### Language
- Body content must be written in Korean.
- English filenames and English titles are allowed.

### Recommended files
Create only the files that are useful for the task:

- `problem-analysis.md`
- `proposal.md`
- `implementation-plan.md`
- `self-check.md`
- `final-report.md`

Do not create unnecessary log files for trivial work.

---

## 9. Comment Rules

- Use `///` for important APIs.
- Use `// MARK:` sections where helpful.
- Use Korean comments only for non-obvious logic, reasoning, or warnings.
- Do not add obvious comments that repeat the code.
- Prefer fewer, more meaningful comments.

---

## 10. Logging Rules

- Do not log sensitive data.
- Do not log secrets, tokens, or keys.
- Keep logs minimal and purposeful.
- Prefer logs that help workflow/debugging without polluting output.

---

## 11. Commit and PR Rules

### Commit message rules
- Commit type prefixes must remain in English.
- Commit message subject should be written in Korean.
- Commit message body, when needed, should also be written in Korean.
- Do not write commit messages fully in English except for the type prefix.

Preferred prefixes:
- `feat`
- `fix`
- `refactor`
- `docs`
- `test`
- `chore`

Examples:
- `feat: 문서 구조 정리 및 README 링크 수정`
- `fix: 선택 상태 변경 시 워크플로우 단계 갱신 오류 수정`
- `docs: architecture 문서를 현재 구현 상태에 맞게 동기화`

### Commit execution rules
- Do not run `git add`, `git commit`, or `git push` automatically.
- First complete the work and report the result.
- Only commit when the user explicitly asks for it.

### PR rules
A PR summary should include:
- what changed
- why it changed
- what is still not implemented
- test status

---

## 12. Testing Rules

Default command:

    xcodebuild test -scheme DizzyFlow -destination 'platform=macOS'

Rules:
- Never claim tests passed if tests were not executed.
- Never imply build success without execution or explicit user confirmation.
- If tests were not run, state that clearly.
- If testing is blocked, explain what blocked it.

---

## 13. Workflow Process

Use this process for non-trivial tasks:

1. Problem
2. Proposal
3. Plan
4. Execution
5. Self-check
6. Testing awareness
7. Final report

For trivial tasks, a shorter flow is acceptable.

Do not ask vague open-ended questions when the task is clear.
When the task is ambiguous and important, propose a clear default direction before asking for confirmation.

---

## 14. Critical Change Rule

Treat the following as critical changes:
- persistence model changes
- file access or sandbox permission changes
- external engine integration
- app-wide architecture refactors
- shared workflow state model changes
- shared storage key changes
- shared model field changes

For critical changes:
- explain the proposed direction first
- mention key risks
- mention expected impact areas
- do not silently make broad changes

---

## 15. Consistency Sweep Rule

If a task changes any shared name, enum, model field, storage key, config key, protocol, or common interface, the agent must:

1. search the repository for all related usages
2. identify affected files
3. update all relevant usages, not only the immediately visible file
4. verify that no outdated usage remains
5. mention the sweep in the final report or self-check

Partial migration is not acceptable for shared patterns.

---

## 16. Knowledge Reuse Rule

Before creating a new reusable knowledge document:
- search existing documents first
- prefer updating an existing document when the topic already exists
- create a new document only when the issue is genuinely new, non-obvious, or likely to recur

If a future `docs/knowledge/` folder is introduced, use it for reusable lessons and recurring technical findings.

---

## 17. Forbidden Actions

- No silent file renaming
- No silent folder restructuring
- No new frameworks without clear need
- No business logic in Views
- No undocumented broad architectural rewrites
- No claiming test success without execution

---

## 18. Definition of Done

Work is done only when all relevant items below are satisfied:

- requirements implemented
- architecture respected
- comments updated where needed
- documentation updated if the change affects shared understanding
- test status reported honestly
- accessibility considered for UI changes
- broad-impact changes reviewed for consistency

---

## 19. Absolute Rule

If tests were NOT executed, you MUST NOT say they passed.

All contributors and agents must read `AGENT.md` before making changes.
