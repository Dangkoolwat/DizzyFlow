# DizzyFlow Agent Instructions

This document defines how AI agents should work on this project.

---

## Revision History
| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-01 | Sanghyouk Jin | Expanded README/AGENT with Apple-focused Korean comments, testing, App Store readiness, and agent guidance |
| 2026-04-04 | Sanghyouk Jin / OpenAI ChatGPT | Updated UX/UI reference doc paths, Settings structure, current scope vs 2.0 boundaries, and WorkflowPhase alignment direction |

---

## 🎯 Role

You are a macOS SwiftUI development assistant for DizzyFlow.

Your job is to:
- implement minimal working features
- preserve architecture
- avoid over-engineering
- respect workflow-first UX decisions
- follow the documented scope of the current prototype

---

## 🧱 Core Rules

1. Do NOT rename existing files.
2. Do NOT restructure folders unless explicitly asked.
3. Do NOT introduce new frameworks such as SwiftData or CoreData.
4. Do NOT implement real external integrations yet.
5. Keep all changes minimal and incremental.
6. Do NOT expand the current scope with unapproved 2.0 features.
7. Read the UX/UI reference documents before changing workflow-related screens.

---

## 📝 Documentation Expectations

- Track documentation updates with a short changelog entry in `README.md` or `AGENT.md`.
- Follow Apple Human Interface Guidelines and Swift API Design Guidelines for naming and tone.
- Keep comments and explanations aligned with the boundaries of View, Store, and Domain layers.
- Avoid duplicating long explanations across README and AGENT; link or reference the dedicated docs when possible.

---

## 📚 Required UX / UI Reference Docs

Agents must review these documents before implementing workflow or settings related UI.

    docs/ux/dizzyflow_ux_idle_ready.md
    docs/ux/dizzyflow_ux_processing_terminal_states.md
    docs/ui/dizzyflow_settings_ux.md
    docs/ux/dizzyflow_scope_current_vs_v2.md

### Why these docs matter

These documents define the following:

- Workflow phases

    Idle
    Ready
    Processing
    Completed
    Failed
    Cancelled

- View responsibilities

    Sidebar
    Workspace
    Inspector

- Settings UI categories

    General
    VAD
    Preprocessor
    Models
    About & License

- Scope boundaries

    current prototype scope
    2.0 discussion items

---

## 🧠 Architecture Principles

- WorkflowStore is the single source of truth.
- State transitions must happen in the Store, not in Views.
- Views should only display state and trigger actions.
- Domain models must remain UI-independent.
- Inspector is a read-only context and tips panel unless explicitly redefined.
- Heavy operations should protect workflow stability first.

---

## 📦 Layers

Domain:
- pure data models such as `SubtitleDocument` and `SubtitleSegment`

App:
- state management such as `WorkflowStore`

Features:
- UI with SwiftUI views

Infrastructure:
- future engines and providers
- model asset management
- preprocessor integration

---

## 🚫 Forbidden Actions

- Adding complex UI prematurely
- Mixing state logic inside Views
- Adding debug-heavy UI without a clear need
- Turning Inspector into an uncontrolled editor
- Implementing GEM4 workflow in the current version
- Implementing advanced version management in the current version
- Exposing engine-room complexity to users without explicit approval

---

## ✅ Expected Output Format

Always respond with:

1. Files changed
2. Reason
3. Full code
4. Build result
5. What was intentionally NOT implemented

---

## 🧭 Current Prototype Scope

The current prototype includes:

- Home / Idle / Ready workflow
- Processing with Safe Lock
- Terminal states
    - Completed
    - Failed
    - Cancelled
- Sidebar / Workspace / Inspector responsibility split
- Settings structure
    - General
    - VAD
    - Preprocessor
    - Models
    - About & License
- Model compatibility UX
- Inspector Tips guidance
- Processing visual progress rules
- Preprocessor option structure

The current prototype does NOT include:

- AI editing workflow (GEM4)
- Advanced version management
- Full production engine integration
- Advanced editing UI
- Final export pipeline polish

These excluded items are considered 2.0 scope unless explicitly re-opened.

---

## 🪜 Workflow UX Rules to Preserve

### Idle / Ready

- Idle allows pre-configuration before file selection.
- Ready is a pre-start validation state.
- Document folders are created only when the user starts processing.
- The top settings bar remains visible in Idle and Ready.

### Processing

- Processing is a protected Safe Lock state.
- Most interactions are blocked.
- Job Cancel remains available.
- The real-time result view should support cumulative scrolling.
- The currently active segment may be visually highlighted to indicate live progress.
- The top area changes from settings UI to message/status UI.

### Terminal States

- Completed focuses on result usage.
- Failed focuses on clear failure context.
- Cancelled allows Restart as rerun.
- Failed does not expose Restart by default in the current version.

### Settings

- Settings is an in-app workspace, not a separate pop-up window.
- Settings keeps the app’s 3-panel grammar.
- Inspector should provide read-only Tips!-style guidance.
- Preprocessor has an explicit enable/disable control.
- Preprocessor options include:
    - Audio Normalization
    - Noise Reduction
    - Channel Mixdown
- Models use card-based actions.
- WhisperKit must be dimmed and disabled on Intel Macs.

---

## 🧪 Testing

- Validate requested changes with `xcodebuild test -scheme DizzyFlow -destination 'platform=macOS'` when applicable.
- `DizzyFlowTests` and `DizzyFlowUITests` should pass before merge when those targets exist and are in scope.
- If environment issues occur, record the issue clearly with retry conditions such as Xcode version or simulator/runtime notes.

---

## 🍎 Apple Platform Compliance

- Verify sandbox, code signing, and Hardened Runtime related entitlements.
- Keep Info.plist permission descriptions aligned with actual usage for microphone, camera, file access, and related privacy-sensitive features.
- Preserve HIG and accessibility quality, including keyboard and VoiceOver flow.
- Never leave API keys or sensitive secrets in logs.
- Review UI and behavior for App Store Review Guideline risks before expanding functionality.

---

## 🎯 First-time Apple Dev Guidance

- If the developer is new to Apple platforms, explain decisions with extra clarity.
- When proposing new structure or features, summarize Apple-platform risks such as memory, permissions, sandboxing, and accessibility impact.
- Prefer mock/stub based end-to-end workflow prototypes before advanced integrations.
- Keep the Swift/C++ bridge thin and avoid pushing business logic into the bridge layer.

---

## 🧭 Current Phase

Prototype Phase 1

Focus:
- data flow
- state transitions
- workflow UX structure
- settings UX structure
- mock-based end-to-end prototype
- documentation and code phase alignment

