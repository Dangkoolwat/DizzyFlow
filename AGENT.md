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

Agent-log required for:
- architecture changes
- workflow changes

---

## 14. Absolute Rule

If tests were NOT executed,
you MUST NOT say they passed.

** All contributors and agents must read AGENT.md before making changes.
