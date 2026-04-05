# DizzyFlow Development Guide

This document serves as the technical standard and architectural blueprint for the DizzyFlow project. All contributors must adhere to these guidelines to ensure consistency and stability.

---

## Revision History
| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-01 | Sanghyouk Jin | Initial setup with SwiftUI + Observation standards. |
| 2026-04-05 | Sanghyouk Jin / AI | v1.1 Update: Relocated to /docs and integrated Bottom Control Stack standards. |

---

## 1. Architectural Principles
DizzyFlow follows a strict layered architecture to separate concerns and protect the user's workflow.

### Core Layers
* Domain: Pure data models (e.g., `SubtitleDocument`, `SubtitleSegment`). These must remain UI-independent.
* App: State management logic. The `WorkflowStore` serves as the Single Source of Truth (SSOT).
* Features: UI components built with SwiftUI. Views must only display state and trigger actions in the Store.

---

## 2. UI/UX Standards: Footer-First Design
To protect the user's focus, all control logic is centralized at the bottom of the workspace.

### The Bottom Control Stack
All workspace views MUST implement the `BottomControlStack`.
* Layer 1 (Status): Used for progress bars, step descriptions, or settings via `UpwardMenuPicker`.
* Layer 2 (Action Bar): Contains primary and secondary `CapsuleActionButton` sets.

### Key Components
* `CapsuleActionButton`: Standardized capsule-style buttons for footer actions.
* `UpwardMenuPicker`: An AppKit-bridged picker designed to open menus upward, preventing macOS "snapping" issues.
* `SettingsBarView`: This is now an `EmptyView`. Do NOT place settings or messages in the top toolbar.

---

## 3. macOS Version Compatibility
* macOS 15 (Sequoia): Support native Window Tiling. Ensure layout integrity during resizing.
* macOS 14 (Tahoe): Apply `Color(NSColor.textBackgroundColor).opacity(0.6)` to central content to maintain contrast with the material footer.

---

## 4. Workflow State Machine
DizzyFlow operates on a 6-phase state machine: `Idle`, `Ready`, `Processing` (Safe Lock), `Completed`, `Failed`, and `Cancelled`.
