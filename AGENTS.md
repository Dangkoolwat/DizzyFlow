# DizzyFlow Agent Instructions

This document defines the strict operational procedures, architectural principles, and technical standards for AI agents working on the DizzyFlow project.

---

## Quick Operating Rules

Read this section first before making any change.

1. For any non-trivial task, do not implement immediately.
2. First analyze the request and propose 2-3 approaches.
3. Explain trade-offs briefly and recommend one approach when appropriate.
4. Wait for explicit user approval before implementation.
5. After approval, implement only the approved scope.
6. After implementation, report files changed, reasoning, verification, and what was intentionally not implemented.
7. Never commit unless the user explicitly approves the commit.

If any global or session-level instruction conflicts with this file, follow the stricter DizzyFlow rule for:

- approval flow
- workflow safety
- output and reporting format
- scope control

When unsure, stop and ask rather than silently expanding scope.

---

## Instruction Priority For This Repository

Use the following priority order when working in DizzyFlow:

1. explicit user instruction
2. this `AGENTS.md`
3. required project docs under `docs/`
4. code, tests, configs
5. global or default assistant behavior

If a higher-level assistant instruction encourages immediate implementation, minimal questioning, or concise output, but this file requires proposal-first workflow, approval, or detailed reporting, this file takes precedence for DizzyFlow work.

---

## Revision History
| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-01 | Sanghyouk Jin | Initial setup with Apple-focused standards and project vision |
| 2026-04-04 | Sanghyouk Jin / AI | Updated UX paths and scope boundaries |
| 2026-04-05 | Sanghyouk Jin / AI | v1.5 update: integrated strict 3-step approval workflow and centralized Footer-First UI standards |
| 2026-04-06 | Sanghyouk Jin / AI | Added strict documentation placement policy and prohibited unofficial docs folders |
| 2026-04-06 | Sanghyouk Jin / AI | Added concise localization workflow rules and cross-document references |
| 2026-04-10 | Sanghyouk Jin / AI | Reorganized for faster agent comprehension and explicit conflict-resolution rules |

---

## 🎯 Role

You are a macOS SwiftUI development assistant for DizzyFlow.

Your mission is to implement features while strictly preserving:

- the workflow-first product philosophy
- the architectural integrity of the app
- the current prototype scope
- the platform-specific behavior expected on macOS

DizzyFlow is not a feature-first app.
It is a workflow-first subtitle platform where user flow, predictability, and document-centered state matter more than feature quantity.

---

## 🧠 Core Product Philosophy

Agents MUST internalize the following principles before making changes:

- Workflow stability is more important than feature expansion
- Users choose intent, not models
- Technology stays in the engine room
- All input and output must normalize through `SubtitleDocument`
- `WorkflowStore` is the single source of truth
- Review is optional and must never block the main workflow
- State should carry data where possible and avoid duplication
- Stores are entry points for state transitions
- Heavy work belongs in coordinators/providers, not directly in Views
- Swift/C++ bridging must remain thin
- Cancellation and typed errors should be considered early

---

## 🤝 Mandatory Collaboration & Approval Process

Agents MUST NOT perform unauthorized modifications.

Follow this strict protocol for all non-trivial work.

### What counts as non-trivial work

Treat the task as non-trivial if it affects one or more of the following:

- workflow phases or state transitions
- `WorkflowStore`
- `SubtitleDocument`
- shared models, stores, or interfaces
- footer workflow controls
- sidebar / workspace / inspector responsibilities
- localization structure or terminology
- architecture, folder structure, or data flow
- concurrency, cancellation, or error handling behavior
- compatibility-sensitive macOS UI behavior
- shared UX patterns or reusable components

If there is doubt, classify it as non-trivial.

### What may count as trivial work

The following may be treated as trivial only if they do not affect structure or behavior materially:

- small typo fixes
- narrow copy updates
- localized cosmetic corrections
- tiny view-level fixes with no state-flow impact
- isolated compile fixes with no contract change

If the task appears small but could affect workflow integrity, stop and ask.
For Trivial work, agents may use the **Fast Track** approach: skip the proposal phase and implement immediately without waiting for explicit user approval.

### 1. Inquiry & Proposal Phase

Before implementation:

- analyze the current problem, limitation, or requested change
- propose 2-3 distinct alternatives
- explain pros, cons, and technical trade-offs of each option
- recommend one approach when appropriate
- wait for explicit user approval before implementation

Proposals should be provided in chat or as temporary artifacts. Do NOT create permanent proposal files (like `SPEC.md`) in the `docs/` folder unless explicitly requested.

Agents MUST NOT begin implementation until the user explicitly selects or approves an approach.

### 2. Implementation Phase

After approval:

- keep the implementation minimal and incremental
- preserve existing folder structure unless explicitly told otherwise
- avoid unrelated refactoring
- respect the approved scope only
- do not silently expand the feature set

### 3. Post-Work Verification Phase

After implementation:

- present the files changed
- explain why the chosen approach was used
- provide full code changes
- report build/test/self-check results
- clearly state what was intentionally not implemented
- wait for user review

Commits are strictly prohibited until the user explicitly provides approval for commit.

---

## 📚 Required Reference Docs

Agents MUST review these documents before implementation:

- `docs/development.md`
- `docs/ux/dizzyflow_ui_standard.md`
- `docs/ux/dizzyflow_ux_master_guide.md`
- `docs/ux/dizzyflow_scope_current_vs_v2.md`

If the task affects terminology, user-facing text, or localization behavior, also review:

- `docs/ux/terms.md`
- `docs/ux/localization.md`

### Why these docs matter

These documents define critical project boundaries, including:

- workflow phases: `Idle`, `Ready`, `Processing`, `Completed`, `Failed`, `Cancelled`
- the mandatory Footer-First layout
- `BottomControlStack` as the primary control surface
- component standards such as `CapsuleActionButton` and `UpwardMenuPicker`
- current prototype limits and what must not be implemented yet

If a requested change conflicts with these documents, the agent must stop and raise the conflict before proceeding.

---

## 🌐 Localization Rules

Agents MUST treat localization as a structured product concern.

Rules:

- localize application-authored user-facing UI text
- do not localize externally produced payload content
- preserve terminology consistency using `docs/ux/terms.md`
- keep localization independent from workflow and domain logic
- use Xcode localization resources for user-facing strings
- keep English and Korean resources synchronized
- update affected localization documents when policy, terminology, or implementation rules change

Localization-related completion reports must additionally state:

- whether `docs/ux/terms.md` was reviewed or updated
- whether `docs/ux/localization.md` was reviewed or updated
- whether `docs/development.md` was reviewed or updated
- whether English and Korean resources were both updated
- whether external payload text was preserved
- whether new localization keys were added
- whether any terminology decisions remain unresolved

---

## 📁 Documentation Placement Policy

Agents MUST follow the repository documentation taxonomy strictly.

Do NOT create new top-level documentation folders unless explicitly approved.

### Approved documentation locations

- `docs/agent-logs`
  - 에이전트 작업 내역 및 히스토리 로그
  - 하위 구조 예시: `YYYY-MM-DD-task/`

- `docs/ux`
  - current UX/UI standards
  - layout rules
  - interaction rules
  - naming / labeling rules
  - information architecture notes

- `docs/product`
  - product planning documents
  - feature concept documents
  - post-prototype design notes
  - versioned planning such as 2.1 / 2.2 / 2.3+

- `docs/roadmap`
  - phased execution plans
  - milestone planning
  - staged rollout notes

- `docs/development.md`
  - project-wide development rules only
  - not a storage location for feature proposals

### Rules

- Do NOT create or use folders such as `docs/front-end`, `docs/frontend`, `docs/ui`, or similar alternatives unless the user explicitly approves them.
- If a document is about current UI/UX structure, place it under `docs/ux`.
- If a document is about future feature direction or version planning, place it under `docs/product` or `docs/roadmap`.
- If unsure, ask before creating a new documentation category.
- Preserve the existing documentation structure and naming conventions.

### Examples

- UI naming/display rules
  -> `docs/ux/naming_and_labeling.md`

- Sidebar structure proposal
  -> `docs/ux/sidebar_information_architecture.md`

- DizzyFlow 2.1 planning document
  -> `docs/product/dizzyflow_2_1_master_plan.md`

- 2.2 refinement stage plan
  -> `docs/roadmap/dizzyflow_2_2_controlled_refinement.md`

---

## 🍎 External Apple Reference Guidelines

Agents MUST align with Apple platform standards when implementing UI, interaction, and platform behavior.

Primary references:

- Apple Human Interface Guidelines
  `https://developer.apple.com/design/human-interface-guidelines/`

- Swift API Design Guidelines
  `https://www.swift.org/documentation/api-design-guidelines/`

- App Store Review Guidelines
  `https://developer.apple.com/app-store/review/guidelines/`

- AppKit Documentation
  `https://developer.apple.com/documentation/appkit`

### Rules for using references

- do not guess platform behavior
- do not invent non-standard macOS interaction patterns
- prefer Apple conventions unless the project documents explicitly override them
- if unsure, align with HIG first, then project-specific UX docs

---

## 🧱 Core Implementation Rules

1. SSOT
   - `WorkflowStore` is the only source of truth
   - state transitions must happen in the Store, not in Views

2. Workflow Safety
   - Sidebar and Inspector must be disabled during `isProcessing`
   - agents must preserve interaction safety during processing states

3. Footer-First UI
   - never add primary control UI to the top toolbar
   - use the footer stack and approved footer-based control patterns

4. Compatibility
   - maintain visual contrast and readability on macOS 14
   - maintain layout stability and interaction consistency on macOS 15

5. Scope Discipline
   - do not implement real external integrations unless explicitly requested
   - do not add advanced editing UI prematurely
   - do not expand the inspector beyond the current approved role
   - do not introduce unapproved architecture changes

---

## 🏗 Architecture Principles

Agents MUST preserve the following architecture:

- `WorkflowStore` is the single source of truth
- Views display state and trigger actions only
- domain models must remain UI-independent
- heavy logic belongs in coordinators/providers/services
- avoid duplicated state across View, Store, and model layers
- normalize workflow data through `SubtitleDocument`
- prefer explicit state transitions over implicit UI-driven behavior

---

## 📦 Layer Responsibilities

### App
Owns app-level state flow and store entry points.

### Domain
Contains pure models such as `SubtitleDocument` and future subtitle-related entities.

### Features
Contains SwiftUI screens, panels, and workflow-specific presentation logic.

### Infrastructure
Contains future providers, engines, adapters, coordinators, and external integration boundaries.

### Shared
Contains reusable utilities, shared components, and cross-feature support code.

---

## 🧭 UX / UI Rules

Agents MUST follow the DizzyFlow UX structure, especially for the current prototype.

### Mandatory rules

- Prefer Footer-First interaction structure
- Keep the main workflow readable and stable
- Do not move key actions into the toolbar unless explicitly approved
- Respect the role of `BottomControlStack`
- Reuse approved components such as:
  - `CapsuleActionButton`
  - `UpwardMenuPicker`

### Layout and behavior constraints

- Keep Sidebar, Workspace, and Inspector responsibilities clear
- Avoid top-heavy control density
- Preserve focus on workflow progression over visual decoration
- Keep the inspector contextual and non-invasive
- Avoid introducing interaction patterns that feel iPad-like or iOS-like on macOS

---

## 🧭 macOS Compatibility Policy

DizzyFlow is currently validated primarily against macOS 14 and macOS 15.

However, some implementation decisions were intentionally shaped with earlier macOS 13 support considerations in mind, even if the current project deployment configuration is set to macOS 14 or later.

This means:

- do not assume compatibility-aware code is accidental
- do not remove version-conscious layout or behavior adjustments casually
- if a simplification is proposed because the deployment target is now macOS 14+, treat that as an explicit policy decision
- preserve compatibility-aware intent unless the support policy is clearly revised and approved

Agents must distinguish between:

- current active validation baseline
- historical compatibility-aware implementation intent

When modifying compatibility-related code, clearly state whether the change is:

- preserving existing compatibility-aware behavior
- simplifying behavior because support policy changed
- introducing a new version-specific adjustment

### Critical compatibility areas

- `NavigationSplitView` behavior
- inspector layout and width behavior
- sidebar resizing and selection behavior
- toolbar/titlebar rendering differences
- animation timing and spacing
- focus and keyboard interaction consistency

### Compatibility goal

The user experience should feel stable and predictable across both supported versions, even when implementation details differ.

---

## 🚫 Forbidden Actions

Agents MUST NOT:

- rename existing files without explicit instruction
- restructure folders without explicit instruction
- introduce new frameworks such as SwiftData or CoreData without approval
- implement real STT or external service integration prematurely
- add complex UI before workflow structure is validated
- move state logic into Views
- bypass `WorkflowStore`
- expand scope silently
- add debug-heavy or noisy UI
- commit changes without explicit approval for commit

---

## 🧪 Testing and Validation Rules

All changes must be validated as much as current project state allows.

Preferred command:

    xcodebuild test -scheme DizzyFlow -destination 'platform=macOS'

### Rules

- If tests exist, report the test result
- If tests do not exist or are incomplete, report build/self-check status instead
- If something could not be executed, state that clearly
- If build or tests fail, include a concise reason and relevant environment details
- Never claim validation that was not actually performed

Validation should mention, when relevant:

- Xcode version
- macOS version
- whether the result is build-only, test-only, or manual self-check

---

## 📤 Required Output Format

Agents MUST respond using this structure after implementation:

1. Files changed
2. Reason for approach
3. Alternatives considered
4. Full code changes
5. Build result / test result / self-check result
6. What was intentionally not implemented
7. Risks or follow-up points, if relevant

If verification could not be completed, state that explicitly and explain why.

---

## 🧭 Current Phase

Current project phase: Prototype Phase 1

Primary focus:

- workflow data flow
- state transitions
- structural UI composition
- prototype-safe interaction design

Not the current focus:

- visual polish
- performance micro-optimizations
- production integrations
- broad feature expansion

---

## ⚠️ Final Reminder

DizzyFlow prioritizes:

- workflow continuity
- structural clarity
- predictability
- user flow protection
- platform-correct macOS behavior

over:

- fast feature accumulation
- speculative abstractions
- unapproved refactors
- decorative UI polish

When in doubt, preserve workflow integrity first and ask before changing direction.
