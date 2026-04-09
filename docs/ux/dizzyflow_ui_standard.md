# DizzyFlow UX Master Workflow Guide

This document defines the comprehensive workflow-level UX standards for DizzyFlow, from initial entry to terminal states. All agents and developers must follow this guide to preserve a consistent workflow-first experience.

---

## Revision History

| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-05 | Sanghyouk Jin / AI | v1.1 Update: Established workflow-level guidance for Idle, Ready, Processing, and Terminal states |
| 2026-04-05 | Sanghyouk Jin / AI | v1.2 Update: Aligned workflow terminology with README, AGENT, and UI Standard documents |

---

## 1. Core Philosophy

DizzyFlow is not just a transcription tool.  
It is a workflow-first subtitle platform designed to protect and accelerate the user's creative flow.

The UX must consistently reflect these principles:

- hide technical complexity behind stable workflow surfaces
- present intent and task progression clearly
- keep primary workflow actions predictable
- preserve document-centered state flow
- support the workflow without forcing unnecessary review

Technology should remain in the engine room.  
The user should experience a clear sequence of purpose, action, and result.

---

## 2. Global Workflow Structure

The prototype uses the following three-part layout:

    Sidebar | Workspace | Inspector

### Sidebar

Role:

- navigation entry point
- access to Home
- access to existing documents
- access to Settings

### Workspace

Role:

- primary workflow area
- content display
- bottom workflow support structure
- phase-dependent action and messaging surface

### Inspector

Role:

- read-only contextual guidance
- optional supporting information
- non-blocking auxiliary panel

The Inspector must remain optional and must not become the primary place for required workflow decisions.

---

## 3. Footer-First Workflow Model

DizzyFlow follows a footer-first interaction model for primary workflow actions.

This does not mean every control belongs at the bottom.  
It means:

- primary workflow actions belong in the bottom Action Row
- contextual options or status messaging belong in the Support Region above it
- optional auxiliary controls may remain outside the footer when appropriate

This model exists to preserve workflow predictability and to reduce macOS 14/15 visual inconsistency in title-adjacent control layouts.

### Bottom Workflow Support Structure

Every primary workspace view should preserve this two-layer structure:

#### Layer 1: Support Region

Role:

- adjustable workflow options during pre-execution states
- status and progress messaging during execution or terminal states
- local context for the next available action

Examples:

- FPS
- Language
- Model
- FCP Template
- processing status
- completion summary
- failure guidance

#### Layer 2: Action Row

Role:

- task-driving workflow transitions
- primary user decisions

Examples:

- select file
- start processing
- cancel
- export
- restart
- start new job

---

## 4. Phase 1: Entry (Idle & Ready)

The entry phase focuses on preparation, clarity, and explicit workflow initiation.

### Idle

Idle is the default state before a file has been prepared for execution.

Primary UX goals:

- make it obvious that no task is currently running
- let the user begin a new workflow without confusion
- allow pre-configuration before execution
- keep the screen calm and readable

Expected behavior:

- the user can access file selection or file drop
- the Support Region may expose workflow-related options such as FPS, Language, Template, and Model
- no processing lock is active
- no terminal result is being shown

### Ready

Ready is the state after a file has been selected but before execution starts.

Primary UX goals:

- confirm that a file is ready
- allow the user to validate or adjust workflow options
- require explicit action before processing begins

Expected behavior:

- the center workspace should identify the selected file clearly
- the Support Region should keep relevant options visible
- the Action Row should present the next decisive action, typically starting processing
- processing must never begin implicitly

---

## 5. Phase 2: Execution (Processing)

Processing is the protected execution state.

The goal of this phase is not flexibility.  
It is safe, understandable execution.

### UX Intent

During processing:

- users should clearly understand that heavy work is in progress
- the app should reduce competing interactions
- the Support Region should switch from configuration to status-oriented messaging
- cancel remains the only active workflow action

### Protected Interaction Rule

Processing may involve heavy external execution.  
For that reason, DizzyFlow intentionally enters a protected interaction state.

This means:

- editing interactions should not remain active
- configuration changes should not remain active
- workflow progression should not branch into unrelated actions
- optional surfaces must not interfere with execution safety
- cancel remains the only active workflow action

### Center Workspace

The center workspace may display:

- cumulative progress logs
- subtitle/result accumulation
- currently relevant execution feedback
- active progress emphasis when appropriate

The center content should help the user understand ongoing work without inviting unrelated interaction.

---

## 6. Phase 3: Result (Terminal States)

Terminal states shift the workflow from execution toward interpretation, export, recovery, or restart.

### Completed

UX goal:

- help the user understand that work finished successfully
- make result usage clear and efficient

Expected behavior:

- center workspace may show full result preview
- Support Region should summarize outcome
- Action Row should present next-step utility actions

Typical actions:

- export
- save
- start new job

### Failed

UX goal:

- make failure visible without overwhelming the user
- provide a clear recovery path

Expected behavior:

- center workspace should explain the failure clearly
- Support Region should provide concise status and guidance
- Action Row should keep recovery choices simple

Typical actions:

- start new job
- retry when appropriate

### Cancelled

UX goal:

- acknowledge intentional interruption clearly
- provide a straightforward next action

Expected behavior:

- Support Region should indicate the task was cancelled by the user
- Action Row should provide a clear recovery or restart path

Typical actions:

- restart
- start new job

---

## 7. Settings Relationship

Settings is separate from workflow-local execution flow.

It is a program-level configuration workspace that supports:

- configuring defaults before work begins
- adjusting detailed behavior during use when needed

The workflow distinction should remain clear:

- Settings  
  program-level configuration workspace

- Support Region in workflow views  
  workflow-local options and state messaging

Settings should not replace the bottom workflow support structure.

---

## 8. Scope Boundaries

This document describes the current prototype workflow experience.

### Current Prototype Focus

- workflow data flow
- state transitions
- structural UI composition
- bottom workflow support structure
- safe and predictable interaction behavior

### Not the Current Focus

- advanced editing workflow
- AI-assisted result refinement
- full production integration
- decorative UI polish
- feature expansion beyond the validated prototype flow

If a proposed UX change crosses these boundaries, it should be treated as a scope discussion rather than an immediate implementation task.

---

## 9. Relationship to Other Documents

This document should be read together with:

- `README.md`
- `AGENTS.md`
- `docs/ux/dizzyflow_ui_standard.md`
- `docs/ux/dizzyflow_scope_current_vs_v2.md`

Document roles:

- `README.md`  
  project overview and documentation entry point

- `AGENTS.md`  
  implementation and collaboration rules

- `dizzyflow_ui_standard.md`  
  visual hierarchy, component, and layout standards

- `dizzyflow_scope_current_vs_v2.md`  
  prototype boundary and future scope separation

This document defines workflow behavior across phases.

---

## 10. Final UX Rule

When in doubt, prefer:

- clearer workflow progression
- fewer competing actions
- more stable task sequencing
- stronger execution safety
- more predictable macOS behavior

over:

- extra controls
- speculative UI expansion
- top-heavy interaction density
- visually clever but unstable layouts
- workflow branching that weakens task clarity
