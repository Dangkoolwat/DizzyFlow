# DizzyFlow

## Revision History

| Date       | Contributor                    | Summary                                                                                                 |
| ---------- | ------------------------------ | ------------------------------------------------------------------------------------------------------- |
| 2026-04-01 | Sanghyouk Jin                  | Expanded README/AGENT with Apple-focused standards, testing, App Store readiness, and agent guidance    |
| 2026-04-04 | Sanghyouk Jin / OpenAI ChatGPT | Updated UX/UI documentation paths, Settings structure, current vs v2 scope, and WorkflowPhase direction |

---

## 🚀 Overview

DizzyFlow is a workflow-first subtitle platform designed for creators using tools like Final Cut Pro.

This is not just a transcription tool.
It is a system designed to preserve and accelerate the user’s workflow.

---

## 🧭 Current Status

Early prototype (v0.1)

* NavigationSplitView-based layout
* WorkflowStore with explicit state transitions
* SubtitleDocument core model
* Mock workflow implementation
* Read-only Inspector panel
* Settings UX structure defined
* Model management UX defined
* Processing and Terminal States UX defined

### Standard Workflow Phases

The project defines a 6-phase workflow model:

```
Idle
Ready
Processing
Completed
Failed
Cancelled
```

The goal is to align the code-level `WorkflowPhase` with this standardized structure.

---

## 🧠 Philosophy

* Technology stays in the engine room
* Users choose intent, not models
* Workflow stability over feature expansion
* All data flows through `SubtitleDocument`
* Review is optional
* Cancellation and typed errors are designed from the beginning

---

## 🏗 Architecture Overview

```
Sidebar → Entry point / navigation  
Workspace → Main workflow area  
Inspector → Read-only contextual guidance panel  
```

Core components:

* WorkflowStore (entry point of state transitions)
* SubtitleDocument (normalized data model)
* SwiftUI + Observation (@Observable)

---

## 📁 Project Structure

```
App
Domain
Features
Infrastructure
Shared
docs/ux
```

---

## 📚 UX / UI Design Notes

The following documents define the current UX/UI standards for the DizzyFlow prototype:

```
docs/ux/dizzyflow_ux_idle_ready.md
docs/ux/dizzyflow_ux_processing_terminal_states.md
docs/ux/dizzyflow_settings_ux.md
docs/ux/dizzyflow_scope_current_vs_v2.md
```

### Purpose of these documents

* Define Idle / Ready / Processing / Terminal workflows
* Clarify Sidebar / Workspace / Inspector responsibilities
* Establish Settings structure and Safe Lock behavior
* Separate current prototype scope from future (v2) scope
* Standardize the 6-phase workflow model

---

## 🧭 Workflow Summary

### Home / Idle

* Default entry point when launching the app
* Top settings bar allows pre-configuration
* Sidebar displays existing documents
* No active processing yet

### Ready

* A file has been selected
* Pre-processing review stage
* Processing starts only after explicit user action

### Processing

* Safe Lock is applied
* Only cancel action is allowed
* Results are streamed in a cumulative scrolling format
* Active segment may be visually highlighted
* Top area switches from controls to status messaging

### Terminal States

* Completed
* Failed
* Cancelled

Completed focuses on result usage
Failed focuses on error visibility
Cancelled allows restart (rerun)

---

## ⚙️ Settings Overview

Settings is not a simple preferences panel.
It is an operational workspace for managing runtime environment and engine assets.

### Layout

```
Sidebar | Settings Main | Inspector
```

### Structure

```
Category List | Detailed Configuration Panel
```

### Categories

* General
* VAD
* Preprocessor
* Models
* About & License

### Core Rules

* Inspector is a read-only "Tips" panel
* General / VAD / Preprocessor use explicit save actions
* Models use card-based direct actions
* WhisperKit is fully disabled on Intel Macs
* Safe Lock may be applied during heavy operations

---

## 📝 Code Style & Documentation

* All source code comments are written in Korean
* Naming and structure follow:

  * Apple Human Interface Guidelines (HIG)
  * Swift API Design Guidelines
* Changes (docs, refactoring, API updates) should be recorded in:

  * Revision History (README)
  * changelog section in AGENT.md
* Comment style should remain consistent across View / Store / Domain layers

---

## ⚠️ What is NOT included (yet)

* Real STT engine integration
* File import/export pipeline
* Full editing UI
* AI-assisted editing workflow (GEM4)
* Advanced version management
* Production-level model asset pipeline

---

## 🛣 Roadmap (Short)

* Home workflow entry
* SubtitleSegment model
* Result rendering
* File input pipeline
* Engine abstraction
* Settings implementation
* Model management implementation
* Synchronization of WorkflowPhase (6 phases)

---

## 🧪 Testing

Run tests using:

```
xcodebuild test -scheme DizzyFlow -destination 'platform=macOS'
```

* Both `DizzyFlowTests` and `DizzyFlowUITests` must pass before merging
* If tests fail, include logs and environment details (macOS version, Xcode version)

---

## 🍎 macOS Platform Readiness

* Ensure sandboxing, code signing, and entitlements are correctly configured
* Follow Apple Human Interface Guidelines and accessibility standards
* Maintain keyboard navigation and VoiceOver compatibility
* Clearly document file access permissions when required
* Explicitly disclose usage of sensitive resources (microphone, camera, network)
* Never expose production API keys in logs

---

## 🤝 Working with Agents

* If unfamiliar with Apple development, request summaries of:

  * HIG
  * Swift API Design Guidelines
  * App Store Review Guidelines
* Before proposing new structures or libraries:

  * Validate platform compatibility (memory, sandbox, entitlements)
* Before implementing UI/UX changes, review:

  docs/ux/dizzyflow_ux_idle_ready.md
  docs/ux/dizzyflow_ux_processing_terminal_states.md
  docs/ux/dizzyflow_settings_ux.md
  docs/ux/dizzyflow_scope_current_vs_v2.md

---

## 👤 Author

Sanghyouk Jin

