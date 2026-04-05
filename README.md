# DizzyFlow

## Revision History

| Date       | Contributor                    | Summary                                                                                                      |
| ---------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| 2026-04-01 | Sanghyouk Jin                  | Expanded README/AGENT with Apple-focused standards, testing, App Store readiness, and agent guidance         |
| 2026-04-04 | Sanghyouk Jin / OpenAI ChatGPT | Updated UX/UI documentation paths, Settings structure, current vs v2 scope, and WorkflowPhase direction      |
| 2026-04-05 | Sanghyouk Jin / OpenAI ChatGPT | Updated README to reflect footer-first workflow structure, current docs/ux paths, Inspector exception rules, and processing lock behavior |

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
* Footer-first interaction structure
* BottomControlStack-based workflow controls
* Settings UX direction defined
* Processing and Terminal States UX defined

### Standard Workflow Phases

The project defines a 6-phase workflow model:

    Idle
    Ready
    Processing
    Completed
    Failed
    Cancelled

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

    Sidebar → Entry point / navigation
    Workspace → Main workflow area
    Inspector → Read-only contextual guidance panel

Core components:

* WorkflowStore (entry point of state transitions)
* SubtitleDocument (normalized data model)
* SwiftUI + Observation (`@Observable`)
* BottomControlStack (footer-based workflow controls)

---

## 📁 Project Structure

    App
    Domain
    Features
    Infrastructure
    Shared
    docs/ux

---

## 📚 UX / UI Design Notes

The following documents define the current UX/UI standards for the DizzyFlow prototype:

    docs/ux/dizzyflow_ux_master_guide.md
    docs/ux/dizzyflow_ui_standard.md
    docs/ux/dizzyflow_scope_current_vs_v2.md

### Purpose of these documents

* Define the overall workflow structure from Idle to Terminal states
* Clarify Sidebar / Workspace / Inspector responsibilities
* Establish footer-first layout and BottomControlStack rules
* Separate current prototype scope from future (v2) scope
* Standardize the 6-phase workflow model

---

## 🧭 Workspace Interaction Model

DizzyFlow uses a footer-first interaction model for primary workflow actions.

Earlier prototypes explored placing settings and status affordances near the upper workspace title area. In practice, macOS 14 and macOS 15 produced noticeably different spacing, density, and titlebar/toolbar behavior, which made the upper workspace region feel inconsistent across OS versions.

To improve visual and interaction consistency, primary workflow controls were moved into the bottom workspace support structure.

### Bottom Workspace Structure

The lower workspace area is composed of two logical layers:

* Support Region  
  Displays workflow-related options during Idle / Ready, and status-oriented messaging during Processing / Terminal states.

* Action Row  
  Displays task-driving actions such as upload, start, retry, or cancel.

This preserves a stable visual rhythm across states while keeping workflow progression controls in one predictable place.

### Footer-First Rule

Footer-first does not mean every control must live at the bottom of the window.

Instead, it means:

* Primary workflow actions should be placed in the bottom action area
* Contextual support content may appear in the support region above that action area
* Optional auxiliary view controls may remain in the toolbar when appropriate

---

## 🧭 Workflow Summary

### Home / Idle

* Default entry point when launching the app
* Bottom support area allows pre-configuration
* Sidebar displays existing documents
* No active processing yet

### Ready

* A file has been selected
* Pre-processing review stage
* Workflow options can still be adjusted before execution
* Processing starts only after explicit user action

### Processing

* Safe Lock is applied
* Only cancel action is allowed
* The support region switches from option controls to status messaging
* Heavy external processing intentionally disables other interactions

### Terminal States

* Completed
* Failed
* Cancelled

Completed focuses on result usage.  
Failed focuses on error visibility.  
Cancelled allows restart (rerun).

---

## 🧩 Inspector Behavior

The Inspector toggle remains in the toolbar intentionally.

Unlike task-driving actions, the Inspector is an optional contextual panel that users may or may not need during a workflow. For that reason, it is treated as a lightweight view control rather than a primary workflow action.

In DizzyFlow:

* Primary workflow actions belong to the footer-first action area
* Optional contextual view controls may remain in the toolbar
* The Inspector is one of these allowed exceptions

This distinction keeps the footer focused on workflow progression while allowing optional auxiliary panels to follow familiar macOS conventions.

---

## ⚙️ Settings Overview

Settings is not a simple preferences panel.  
It is a program-level configuration workspace for managing runtime environment and engine-related behavior.

It supports both:

* pre-configuring defaults before starting work
* adjusting detailed behavior during use when needed

At the current prototype stage, the high-level category structure is defined, but many detailed fields are still being finalized.

### Layout

    Sidebar | Settings Main | Inspector

### Structure

    Category List | Detailed Configuration Panel

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

## 🔒 Processing Lock Policy

During processing, DizzyFlow intentionally restricts user interaction.

Because processing is driven by an external, heavy-running program, the application enters a protected interaction mode where:

* primary editing and configuration interactions are disabled
* workflow navigation is effectively locked for safety
* cancel remains the only active control

This behavior is intentional and is part of the workflow safety model rather than a temporary implementation limitation.

---

## 🧾 Support Region Behavior by State

The support region above the bottom action row changes its role depending on workflow state.

* Idle / Ready  
  Displays adjustable workflow options such as FPS, language, and related parameters.

* Processing / Completed / Failed / Cancelled  
  Displays state-oriented messaging, progress context, and result guidance.

This region should be understood as a support surface for the primary action row, not as a separate standalone feature area.

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
* Documentation should always reflect actual file names and current prototype terminology

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

    xcodebuild test -scheme DizzyFlow -destination 'platform=macOS'

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

  `docs/ux/dizzyflow_ux_master_guide.md`  
  `docs/ux/dizzyflow_ui_standard.md`  
  `docs/ux/dizzyflow_scope_current_vs_v2.md`

---

## 👤 Author

Sanghyouk Jin
