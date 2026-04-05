# DizzyFlow UX Master Workflow Guide (v1.1)

This document defines the comprehensive user experience standards for DizzyFlow, from initial entry to final terminal states. All agents and developers must adhere to this guide to ensure a consistent, "Workflow-first" experience.

---

## 1. Core Philosophy: Technology in the Engine Room, Purpose to the User
DizzyFlow is not just a transcription tool; it is a platform that protects and accelerates the user's creative workflow.
* Hide Complexity: Technical details are tucked away in the Inspector or bottom pickers.
* Goal-Oriented UX: Users choose their "Work Purpose" rather than just selecting models.
* Footer-First Layout: All primary interactive controls are centralized in the `BottomControlStack` to keep the user focused on the content.

---

## 2. Global UI Standard: Bottom Control Stack
Every workspace view MUST implement the two-layer footer structure for consistent navigation and control.

### Layer 1: Status & Contextual Settings (The "Info" Layer)
* Role: Provides real-time feedback, progress messages, or contextual settings.
* Components: `UpwardMenuPicker` (for FPS, Language, Models), progress labels, and step descriptions.

### Layer 2: Action Bar (The "Decision" Layer)
* Role: Contains the definitive action buttons to transition through the workflow.
* Components: `CapsuleActionButton` (Primary: Blue/Accent, Secondary: Bordered, Destructive: Red).

---

## 3. Phase 1: Entry (Idle & Ready)
The entry phase focuses on preparation and validation before launching heavy tasks.

### Idle (Initial State)
* Goal: Allow users to pre-configure global settings before uploading files.
* Bottom Stack:
    - Layer 1: Active `UpwardMenuPicker` set (FPS, Language, FCP Template, Model).
    - Layer 2: Prompt to "Drop or Select File" (Primary button is disabled).

### Ready (Validation State)
* Goal: Review selected files and final settings before processing.
* Center Workspace: Displays simple file identification (Name, Icon, or Thumbnail).
* Bottom Stack:
    - Layer 1: Settings remain editable via pickers.
    - Layer 2: "Start Processing" button (Primary Action).

---

## 4. Phase 2: Execution (Processing)
Once processing begins, the app enters Safe Lock mode to protect the workflow.

* Safe Lock: The Sidebar and Inspector are disabled/dimmed to prevent accidental state changes.
* Center Workspace: Real-time results are displayed via Cumulative Scrolling. The active segment is visually highlighted.
* Bottom Stack:
    - Layer 1: Current processing step (e.g., "Analyzing Audio...") and total progress percentage.
    - Layer 2: "Cancel Job" button (Destructive Action).

---

## 5. Phase 3: Result (Terminal States)
The final states focus on the utility and review of the generated results.

### Completed (Success)
* Center Workspace: Full scrollable SRT preview with timecode formatting.
* Bottom Stack:
    - Layer 1: "Task Completed" message with summary (e.g., segment count).
    - Layer 2: [FCPXML (Primary)] [SRT] [Start New Job].

### Failed (Error)
* Center Workspace: Clear indication of the failure point and actionable error messages.
* Bottom Stack:
    - Layer 1: "Task Failed" status.
    - Layer 2: [Start New Job (Primary)].

### Cancelled (Aborted)
* Bottom Stack:
    - Layer 1: "Task Cancelled by User" notice.
    - Layer 2: [Restart (Primary - Rerun logic)] [Start New Job].

---

## 6. Scope Boundaries (Current vs. v2.0)
Agents must not implement features beyond the current prototype scope without explicit approval.

* In-Scope (v1.0): Core workflow, Bottom Control Stack UI, 6-phase state machine, Model management.
* Out-of-Scope (v2.0): AI-based editing (GEM4), advanced versioning, result diffing, and edit history.

---

## 7. Collaboration & Approval Protocol
To ensure alignment with the DizzyFlow vision, all agents must follow this 3-step process:
1. Proposal: Analyze the problem and provide 2-3 distinct alternatives.
2. User Selection: Wait for the user to choose and approve an implementation path.
3. Final Review: Present results and obtain "Approval for Commit" before finalization.
