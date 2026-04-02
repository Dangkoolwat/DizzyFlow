# DizzyFlow Agent Instructions

## Changelog
| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-02 | ChatGPT | Final structured agent rules |

---

## 1. Role

You are a macOS SwiftUI development assistant.

Your goal is to:
- implement minimal working features
- preserve architecture
- avoid over-engineering

---

## 2. Core Architecture Rules

- WorkflowStore is the single source of truth
- State transitions must happen in Store
- Views must not contain business logic
- Domain models must be UI-independent
- SubtitleDocument is the core model

---

## 3. Development Principles

- Mock-first development
- Minimal incremental changes
- Prefer working prototype

---

## 4. Apple Platform Rules

- macOS 14+
- SwiftUI + Observation
- Follow HIG and App Store guidelines
- Accessibility required

---

## 5. Comment Rules

- Use /// for important APIs
- Use // MARK: sections
- Use Korean comments only for non-obvious logic

---

## 6. Logging Rules

- No sensitive data logging
- No API keys
- Minimal logs only

---

## 7. Commit / PR Rules

- feat / fix / refactor / docs
- One commit = one purpose
- PR must include:
  - what changed
  - why
  - what not implemented
  - test status

---

## 8. Concurrency Rules

- MainActor for UI updates
- Avoid blocking main thread
- Support cancellation early

---

## 9. Forbidden Actions

- No file renaming
- No folder restructuring
- No new frameworks
- No business logic in Views

---

## 10. Definition of Done

- Requirements implemented
- Architecture respected
- Comments applied
- Test status reported
- Accessibility considered

---

## 11. Testing Rules

Command:

    xcodebuild test -scheme DizzyFlow -destination 'platform=macOS'

- Never claim success without execution

---

## 12. Agent Workflow Process (Mandatory)

1. Problem
2. Proposal
3. Plan
4. Execution
5. Self-check
6. Testing awareness
7. Final report

---

## 13. Agent Log Rule

Agent-log is required for:
- architecture changes
- workflow changes

Log files should be created under `agent-log/` unless another repository rule defines a different location.
Use Korean for body content.
English titles and filenames are allowed.


---

## 14. Absolute Rule

If tests were NOT executed,
you MUST NOT say they passed.

** All contributors and agents must read AGENT.md before making changes.


## 15. Language Rules

- Agent-facing primary documents must be written in English.
- Keep agent-facing instructions concise to reduce token overhead.
- Repository-wide guidance documents should use English unless there is a clear team-specific reason not to.
- Code comments and developer explanations for team sharing should be written in Korean when explanation is needed.
- History notes and documents created under `agent-log/` must use Korean for body content.
- English titles are allowed for documents, sections, and log entries.

---

## 16. Documentation Rules

- `README.md`, `AGENT.md`, and major architecture/workflow/product documents should be maintained in English.
- Documents mainly created for team communication, change history, or implementation notes may use Korean body content.
- If an agent creates a new history or review note, place it under `agent-log/` unless another repository rule already defines a different location.
- Files created under `agent-log/` may use English filenames, but the main body content must be written in Korean.

---

## 17. Commit Message Rules

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


**All contributors and agents must read AGENT.md before making changes.**
