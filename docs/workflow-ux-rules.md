# DizzyFlow Workflow & UX Rules

## Revision History
| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-03 | ChatGPT + Sanghyouk Jin | Initial draft of workflow, state, retry, preview, delete, sidebar, and inspector UX rules |

This document defines the currently agreed workflow, state rules, and UX policies for DizzyFlow.  
Its goal is to preserve state consistency through `WorkflowStore` and protect the user’s workflow.

---

## 1. Core Philosophy

- Workflow-first
- Hide technical complexity inside the Inspector (the engine room)
- Let users focus only on their task intent
- Keep all data flowing through `SubtitleDocument`
- Allow state transitions only through `WorkflowStore`
- Prefer preservation over data loss

---

## 2. Document & Version Model

### 2.1 Document Creation Rules

- Always create a new Document when a new task starts.
- Never overwrite an existing task, even if the same file is selected again.
- Each start is treated as an independent work unit.
- In the Sidebar, this work unit is represented as a group.

### 2.2 Primary Result and Version Rules

- The initial transcription result is not treated as a Version.
- The initial completed result is the Primary Result of that task.
- Versions begin only when the user applies a follow-up AI edit such as GEM4.
- Do not create a Version merely because an action button was pressed; create it only when the user explicitly confirms and applies the result.

### 2.3 Group Concept

- The Sidebar displays items at the Document Group level.
- Clicking a group opens its most recent result.
- A group may contain one Primary Result and multiple derived Versions.

---

## 3. Workflow States

### 3.1 State Definitions

- DraftInput
- Queued
- Processing
- Completed
- Failed
- Cancelled

### 3.2 State Meanings

- Completed: finished successfully
- Failed: an execution error occurred after the input phase
- Cancelled: interrupted by the user

### 3.3 State Decision Rules

- Blocked before input completes → cannot start
- Error during execution after input is accepted → Failed
- Interrupted by the user during execution → Cancelled
- Finished normally → Completed

---

## 4. Retry Policy

### 4.1 Retry Conditions

A task is considered retryable when all of the following are true:

- the source file still exists
- the initial input settings are still available
- the `InputSnapshot` is preserved

### 4.2 Retry Targets

- Cancelled → retryable
- Failed → retryable

### 4.3 Retry Principles

- The user should not have to reselect the file, FPS, or language.
- Reuse the existing input snapshot from the previous task.
- Retryability is determined not only by state, but also by whether the source file still exists.

---

## 5. InputSnapshot

Each Document must preserve the following input information:

- source file URL or bookmark
- detected FPS
- user-selected FPS override
- selected language
- processing configuration
- createdAt

`InputSnapshot` is shared across Retry, Preview, Export, and Inspector flows.

---

## 6. Home UI Policy

### 6.1 Basic Direction

- The start screen should remain as simple as possible.
- Users should focus on file input and starting the workflow.
- Detailed settings should be hidden inside an Advanced section.

### 6.2 Advanced Items

At the initial stage, the Advanced section includes:

- manual FPS override
- language selection

### 6.3 Settings Priority

- Automatic detection is the default.
- If the user explicitly reveals and sets a manual value, that should be treated as intentional and should take priority.
- If the detected value and applied value differ, show both clearly in the Inspector.

Example:
- Detected FPS: 23.976
- Applied FPS: 24.0 (Manual Override)

---

## 7. Processing UX

### 7.1 Segment Card

- During Processing, subtitles are shown in real time as Segment Cards.
- These are draft results.
- They must not be treated as final confirmed results.

### 7.2 Workspace Structure

- Top area: current engine stage
- Main area: Segment Card list
- Inspector: progress, model information, and internal state

### 7.3 Cancel Policy

- Cancelling immediately returns the user to Home.
- The cancelled task remains in the Sidebar.
- A cancelled task can be retried.
- Cancelled tasks do not show the completion-only Action Bar.

---

## 8. Preview Policy

### 8.1 Purpose

Preview is not a video editor. It is a subtitle review surface.

Its purpose is to:
- let the user see how the current subtitles look
- check line breaks and readability
- replay around the currently selected segment

### 8.2 Behavior Rules

- It always reflects the currently active result.
- It can seek to the selected segment.
- It supports subtitle overlay rendering.
- It should provide only the minimum playback features needed for subtitle review.

### 8.3 Exception Cases

- There may be cases where SRT has not yet been generated.
- In that case, the Inspector should show the current status.
- Preview may still operate without subtitle overlay.

---

## 9. External Player Integration

- Open the external player based on the completed result.
- By default, use the managed SRT together with the source media.
- Some functionality may be limited depending on SRT or source media availability.
- Show those limitations transparently in the Inspector.

---

## 10. Sidebar Rules

### 10.1 Sorting

- Sort groups by most recent activity, descending.

### 10.2 Visible Information

- group name
- state badge
    - Completed
    - Failed
    - Cancelled

### 10.3 Click Behavior

- Clicking a group opens the latest result in that group.

---

## 11. Delete Policy

### 11.1 Deletion Unit

- Deletion happens at the group level.
- Deleting individual Versions is out of scope for the initial stage.

### 11.2 Access to Delete

- Do not keep a trash icon always visible.
- Provide deletion only through the context menu or a `...` menu.

Example:
- Open
- (future actions)
- ---
- Delete Group…

### 11.3 Delete UX

Deletion must always require explicit confirmation.

Example:
“Do you want to delete this task group?”

- All versions, subtitles, and cached data will be permanently deleted.
- This action cannot be undone.

[Cancel] [Delete]

### 11.4 Delete Restrictions

- Do not allow direct deletion while a task is still Processing.
- Guide the user to cancel first.

---

## 12. Auto Deletion (Future)

Automatic deletion policies may be added later in Settings.

Possible options:
- delete after 7 days
- delete after 30 days
- delete Completed only
- optionally include Failed / Cancelled

To support this, preserve the following metadata:

- createdAt
- updatedAt
- lastOpenedAt
- status

---

## 13. Inspector Policy

### 13.1 Role

The Inspector is a read-only engine room.  
The main workflow should stay simple, while technical details are exposed in the Inspector.

### 13.2 Visible Information

- current stage
- overall progress
- partial progress
- model information
- detected FPS / applied FPS
- output status
- internal logs or table-based technical details

### 13.3 Information Design Principles

- Present default information in a human-readable way.
- Allow deeper technical details to be expanded.
- Provide as much useful detail as possible without disrupting the main workflow.

---

## 14. AI Editing (GEM4)

### 14.1 Concept

- The initial transcription result is the first result.
- GEM4-based editing after that is a preference- or purpose-driven derived workflow.

### 14.2 Version Creation Timing

- Treat GEM4 execution as temporary until the user confirms it.
- Create a new Version only when the user presses Apply.

### 14.3 Design Principles

- Do not preserve unconfirmed results as official Versions.
- Prevent unnecessary version spam and keep version history intentional.

---

## 15. Design Principles Summary

- Every new start becomes a separate task.
- The initial result is the Primary Result, and Versions begin with GEM4.
- Failed and Cancelled tasks are retryable when the source file still exists.
- Preview is for review and must not become a replacement for a full editor.
- Delete is destructive and should only be exposed through a hidden menu path.
- The Inspector acts as the control tower that exposes technical state clearly.
- Workflow stability takes priority over feature expansion.
