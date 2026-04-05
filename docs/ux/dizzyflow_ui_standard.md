# DizzyFlow UI/UX Standard Guide (v1.2)

This document defines the visual language, layout hierarchy, and component standards for the DizzyFlow project. All UI implementations must adhere to these rules to ensure a seamless experience across different macOS versions and window states.

---

## Revision History
| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-05 | Sanghyouk Jin / AI | v1.2 Update: Established Footer-First layout standards and component-specific usage rules. |

---

## 1. Core Philosophy: Footer-First Design
DizzyFlow minimizes cognitive load by concentrating all interactive controls at the bottom of the workspace. This allows the user's gaze to move naturally from the content (center) to the action (bottom).

### Visual Hierarchy
* Top Area: Brand identification and system-level navigation (e.g., Inspector toggle). No control logic or settings allowed here.
* Center Area: Primary content display (e.g., SRT previews, cumulative progress logs).
* Bottom Area: Context-aware controls and status messaging via the `BottomControlStack`.

---

## 2. Layout Structure: Bottom Control Stack
Every workspace view must implement a two-layer footer structure to maintain navigation consistency.

### Layer 1: Status & Contextual Settings (The "Info" Layer)
* Purpose: Displays real-time feedback or allows non-destructive configuration.
* Standard Components: 
    - Progress indicators and status labels (e.g., "Analyzing Audio...").
    - `UpwardMenuPicker` for phase-specific settings (Language, Model, FPS).
* Behavior: Must be aligned to provide immediate context for the actions available in Layer 2.

### Layer 2: Action Bar (The "Decision" Layer)
* Purpose: Workflow transitions and primary decision-making actions.
* Standard Components: 
    - `CapsuleActionButton` sets.
* Behavior: Aligned horizontally with appropriate spacing (default: 12pt).

---

## 3. Standard Components
To prevent UI fragmentation, use these specialized components exclusively:

### CapsuleActionButton
* Primary: Used for the most likely next step (e.g., "Start Processing", "FCPXML Export"). Styled with the system accent color.
* Secondary: Used for optional or secondary actions (e.g., "Preview", "Save SRT"). Styled with a bordered/subtle look.
* Destructive: Specifically for "Cancel" or "Delete" actions. Styled with a red tint to warn of irreversible or abortive actions.

### UpwardMenuPicker
* Rationale: Native macOS menus often "snap" to the center of the screen, which can obscure the footer area.
* Requirement: Use this AppKit-bridged component to force menus to open upward, ensuring action buttons remain visible during selection.

---

## 4. macOS Compatibility Rules

### macOS 15 (Sequoia) - Tiling & Resizing
* Rule: The `BottomControlStack` must use adaptive padding and `.ultraThinMaterial` background.
* Stability: Ensure the layout does not break when the window is
