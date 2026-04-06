# DizzyFlow Development Guide

This document serves as the technical standard and architectural blueprint for the DizzyFlow project. All contributors must follow these guidelines to preserve workflow stability, architectural clarity, and platform-correct macOS behavior.

---

## Revision History

| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-01 | Sanghyouk Jin | Initial setup with SwiftUI + Observation standards |
| 2026-04-05 | Sanghyouk Jin / AI | v1.1 Update: Relocated to /docs and integrated Bottom Control Stack standards |
| 2026-04-05 | Sanghyouk Jin / AI | v1.2 Update: Aligned development guidance with footer-first workflow model, protected processing state, and current documentation structure |
| 2026-04-06 | Sanghyouk Jin / AI | v1.3 Update: Added localization implementation rules and Xcode String Catalog guidance |

---

## 1. Architectural Principles

DizzyFlow follows a strict layered architecture to separate concerns and protect the user's workflow.

### Core Rules

- `WorkflowStore` is the Single Source of Truth (SSOT)
- state transitions must happen in the Store, not in Views
- Views should display state and trigger actions only
- heavy logic belongs in coordinators, providers, adapters, or services
- domain models must remain UI-independent
- workflow data should normalize through `SubtitleDocument`
- avoid duplicated state across View, Store, and model layers
- prefer explicit state transitions over implicit UI-driven behavior

---

## 2. Layer Responsibilities

### App

Owns app-level state flow and Store entry points.

Examples:

- `WorkflowStore`
- app lifecycle coordination
- workflow transition entry logic

### Domain

Contains pure models and domain-level data structures.

Examples:

- `SubtitleDocument`
- `SubtitleSegment`
- future subtitle-related entities

Rules:

- must remain UI-independent
- must not depend directly on SwiftUI views

### Features

Contains SwiftUI screens, panels, and workflow-specific presentation logic.

Examples:

- workspace views
- inspector views
- footer support structures
- settings screens

Rules:

- may observe Store state
- must not own core workflow truth
- should remain presentation-focused

### Infrastructure

Contains external boundaries and heavy operational logic.

Examples:

- providers
- engines
- coordinators
- adapters
- future file or model integration boundaries

Rules:

- keep integrations isolated from Views
- keep bridges thin and explicit

### Shared

Contains reusable cross-feature utilities and UI support components.

Examples:

- common modifiers
- shared components
- helper utilities
- reusable view building blocks

---

## 3. UI / UX Development Standard

DizzyFlow follows a footer-first workflow model.

Primary workflow actions must remain at the bottom of the workspace to preserve clear task progression and reduce cognitive load.

### Footer-First Rule

Footer-first does **not** mean every control belongs at the bottom.

It means:

- primary workflow actions belong in the bottom Action Row
- contextual options or messaging belong in the Support Region above it
- optional auxiliary controls may remain outside the footer when appropriate

Do not place task-driving workflow controls in the top toolbar or title-adjacent workspace area unless there is a clearly documented, explicitly approved exception.

---

## 4. BottomControlStack Standard

All primary workspace views should preserve the `BottomControlStack` structure.

### Layer 1: Support Region

Used for:

- progress and status messaging
- step descriptions
- workflow-local options via `UpwardMenuPicker`
- terminal-state summaries or guidance

Typical examples:

- FPS
- Language
- Model
- processing status
- completion summary

### Layer 2: Action Row

Used for:

- primary workflow transitions
- next-step decisions
- cancel / retry / export / restart style actions

Standard action component:

- `CapsuleActionButton`

Rules:

- keep actions horizontally stable
- maintain clear primary / secondary / destructive hierarchy
- keep the bottom action row visually predictable across phases

---

## 5. Key Components

### CapsuleActionButton

Standardized capsule-style button for footer actions.

Use cases:

- Start Processing
- Export
- Retry
- Cancel
- Start New Job

Style hierarchy:

- Primary: most likely next step
- Secondary: optional non-destructive action
- Destructive: cancel or delete level action only

### UpwardMenuPicker

AppKit-bridged picker designed to open upward when used in the lower workflow support region.

Use this when native menu behavior would visually interfere with the bottom interaction area.

Typical uses:

- Language
- FPS
- Model
- Template-related workflow options

### Inspector

The Inspector is a read-only, optional contextual panel.

Rules:

- it may remain accessible as a toolbar-level view control
- it must not become the primary place for required workflow actions
- its presence does not justify moving primary actions away from the footer structure

---

## 6. Processing-State Development Rule

`Processing` is a protected workflow state.

Because DizzyFlow may rely on heavy external execution during this phase:

- editing interactions should not remain active
- configuration changes should not remain active
- unrelated workflow branching should be minimized
- optional surfaces must not interfere with execution safety
- cancel remains the only active workflow action

From an implementation standpoint:

- preserve safety first
- do not introduce interactive ambiguity during processing
- prefer clear status messaging over additional controls

---

## 7. macOS Version Compatibility

DizzyFlow is currently validated primarily against macOS 14 and macOS 15.

However, some implementation decisions were intentionally made with macOS 13-era behavior in mind, even if the current project deployment configuration is set to macOS 14 or later.

This means:

- do not assume older compatibility-aware code is accidental
- do not remove version-conscious layout or behavior adjustments casually
- if a compatibility-related simplification is proposed, treat it as an explicit policy decision rather than a silent cleanup

### General Rules

- do not assume SwiftUI behavior is identical across versions
- do not rely blindly on default spacing, animation, or split-view behavior
- avoid scattering version checks across many views
- isolate version-specific behavior through helpers, wrappers, modifiers, or adapters
- maintain stable user-facing UX even if internal implementation differs

### Critical Areas

- `NavigationSplitView` behavior
- inspector width and presentation
- sidebar resizing and selection behavior
- toolbar/titlebar rendering differences
- footer material and contrast handling
- focus and keyboard interaction consistency

### Active Validation Baseline

Current active validation should focus on:

- macOS 14
- macOS 15

### Historical Compatibility Awareness

Some layout and interaction decisions may reflect earlier support considerations for macOS 13-era behavior.

Therefore:

- preserve compatibility-aware intent unless removal is explicitly approved
- prefer documented simplification over silent deletion
- when changing compatibility code, explain whether the change is safe because project support policy has changed

### macOS 15 (Sequoia)

Implementation should ensure:

- footer structure remains stable under tiling and resize
- bottom controls stay readable
- action hierarchy remains clear under aggressive width changes

### macOS 14 (Sonoma)

Implementation should ensure:

- footer contrast remains readable
- central content and footer boundary remain visually clear
- the lower support structure does not feel visually detached or washed out

Do not hard-code appearance assumptions into documentation unless they are genuinely project standards.  
Exact visual compensation values should live in implementation code, not in this guide.
---

## 8. Workflow State Machine

DizzyFlow operates on a 6-phase workflow model:

    Idle
    Ready
    Processing
    Completed
    Failed
    Cancelled

Development must preserve clear, explicit transitions between these phases.

Rules:

- do not introduce hidden or implicit transitions
- do not bypass Store-managed state updates
- terminal states should remain semantically distinct
- processing must preserve protected interaction behavior

---

## 9. Scope Discipline

Until explicitly expanded, the current prototype focus is:

- workflow data flow
- state transitions
- structural UI composition
- footer-first interaction behavior
- safe processing UX
- settings structure
- model / preprocessor / VAD related configuration direction

Do not prematurely implement:

- real STT production integration
- advanced editing workflows
- AI-assisted editing systems such as GEM4
- high-complexity version management
- speculative infrastructure that is not yet required

---

## 10. Localization Implementation Rules

Localization must remain a presentation-layer concern.

Do not:

- hardcode new user-facing strings in views when they belong in localization resources
- use enum raw values as UI labels
- store localized text in domain models
- translate external payload text
- build variable user-facing strings through raw concatenation
- couple localized values to persistence or workflow logic

Do:

- use Xcode localization resources for application-authored user-facing strings
- keep English and Korean resources updated together
- use full localized wrapper strings for variable messages
- consult `docs/ux/terms.md` before introducing new product terminology
- keep implementation aligned with `docs/ux/localization.md` and `AGENT.md`

### Recommended Resource Location

Recommended primary resource:

- `Resources/Localization/DizzyFlow.xcstrings`

A single String Catalog file is acceptable for v1 if semantic key discipline is maintained.

### Required Key Namespaces

Use these namespaces:

- `term.*`
- `phase.*`
- `workflow.*`
- `settings.*`
- `shared.*`
- `error.*`
- `external.*`
- `view.*`

Examples:

- `phase.processing.label`
- `phase.processing.status`
- `workflow.action.cancel`
- `settings.general.programLanguage.label`
- `external.import.failed`

### Workflow State Resource Pattern

Use separate keys for compact labels and sentence-style status text when the UI role differs.

Preferred:

- `phase.processing.label`
- `phase.processing.status`
- `phase.completed.label`
- `phase.completed.status`

This is especially important for Korean UI naturalness.

### Variable String Pattern

Preferred:

- localized full format string in catalog
- payload inserted through placeholder

Good examples:

- English: `Import failed: %@`
- Korean: `가져오기에 실패했습니다: %@`

Avoid:

- `"가져오기 실패: " + payload`
- `"\(payload)을 불러오지 못했습니다"` when payload grammar is unpredictable

### Domain Mapping Pattern

Preferred pattern:

- domain state remains language-neutral
- presentation maps state to localization keys
- localized resources provide final display text

Example direction:

- `WorkflowPhase.processing` -> `phase.processing.label`
- `WorkflowPhase.processing` -> `phase.processing.status`

### Review Rule

When changing localization-related code or resources, review:

- `docs/ux/terms.md`
- `docs/ux/localization.md`
- `AGENT.md`

Update documentation where needed in the same change.

---

## 11. Validation Rules

Preferred test command:

    xcodebuild test -scheme DizzyFlow -destination 'platform=macOS'

Validation guidance:

- report actual test results when tests exist
- report build/self-check results honestly when tests are incomplete
- never claim validation that was not performed
- if something fails, provide a concise reason and environment details

When relevant, validation reports should mention:

- Xcode version
- macOS version
- whether the result was build-only, test-only, or manual self-check

---

## 12. Relationship to Other Documents

This guide should be read together with:

- `README.md`
- `AGENT.md`
- `docs/ux/dizzyflow_ui_standard.md`
- `docs/ux/dizzyflow_ux_master_guide.md`
- `docs/ux/dizzyflow_scope_current_vs_v2.md`
- `docs/ux/terms.md`
- `docs/ux/localization.md`

Document roles:

- `README.md`  
  project overview and documentation entry point

- `AGENT.md`  
  implementation and collaboration rules

- `dizzyflow_ui_standard.md`  
  visual hierarchy and component-level standards

- `dizzyflow_ux_master_guide.md`  
  workflow behavior across phases

- `dizzyflow_scope_current_vs_v2.md`  
  current prototype boundary versus future scope

- `terms.md`  
  canonical product terminology

- `localization.md`  
  localization policy and Xcode String Catalog structure

---

## 13. Final Rule

When in doubt, prefer:

- workflow continuity
- explicit state ownership
- simpler view responsibilities
- safer processing behavior
- more stable macOS behavior

over:

- speculative abstraction
- visually clever but unstable layout behavior
- duplicated state
- unapproved architecture changes
- premature feature expansion
