# DizzyFlow Localization Policy

## 1. Purpose

This document defines localization scope, terminology behavior, resource organization, language quality rules, and Xcode resource structure for DizzyFlow.

Localization in DizzyFlow follows practical Apple and Xcode workflows where they support maintainable editing and stable UI resources.
However, Apple platform conventions do not override DizzyFlow’s workflow and UX rules.

## 2. Supported Languages

v1 supported languages:

- English
- Korean

Program language is a global application setting in:

- `Settings > General`

It is a program-level setting and must not be treated as a workflow-local option.

## 3. Localization Scope

Localize:

- application-authored user-facing UI strings
- status text
- workflow messages
- settings labels
- shared messages
- shared error messages
- wrapper text around external payloads

Do not localize:

- imported content
- externally generated payloads
- raw model output
- filenames and paths
- internal identifiers
- persistence keys
- analytics keys

## 4. Product Language Rule

Localization must prioritize:

- user comprehension
- workflow clarity
- natural product language
- stable terminology

Literal one-to-one translation is not required.

English source strings must be written as user-facing product copy.
Korean translations may use stable English-derived product terms where they improve clarity and usability.

See:

- `docs/ux/terms.md`

## 5. Korean Adaptation Rule

Korean may use English-derived product terms when they are more natural, more familiar, or more stable in actual UI.

Examples:

- Workflow -> 워크플로우
- Model -> 모델
- Inspector -> 인스펙터
- VAD -> VAD

Do not force literal Korean renderings when they reduce readability or product clarity.

## 6. External Payload Rule

Content imported from or produced by external systems must remain unchanged.

Only application-authored wrapper text may be localized.

Correct:

- `Processing failed: %@`
- `처리에 실패했습니다: %@`

Incorrect:

- translating the payload itself
- rewriting imported subtitle content
- changing model output for stylistic consistency

## 7. Variable String Rule

Use full localized wrapper sentences.

Do not:

- build user-facing messages through raw concatenation
- attach Korean particles directly to unpredictable external payloads
- mutate external payload text to force grammar

Preferred:

- `Import failed: %@`
- `가져오기에 실패했습니다: %@`

Use neutral Korean sentence structures when grammar would otherwise become awkward.

## 8. Xcode String Catalog Policy

DizzyFlow may keep application-authored user-facing strings in one primary String Catalog file.

Recommended file:

- `Resources/Localization/DizzyFlow.xcstrings`

One file is acceptable only if semantic structure remains explicit through key design.

Use these namespaces:

- `term.*`
- `phase.*`
- `workflow.*`
- `settings.*`
- `shared.*`
- `error.*`
- `external.*`
- `view.*`

Example keys:

- `term.workflow`
- `phase.processing.label`
- `phase.processing.status`
- `workflow.action.start`
- `settings.general.programLanguage.label`
- `shared.button.cancel`
- `error.file.openFailed`
- `external.processing.failed`

## 9. Namespace Meaning

### `term.*`
Canonical product terms.

Examples:

- `term.workflow`
- `term.subtitleDocument`
- `term.model`
- `term.inspector`

### `phase.*`
Workflow phase labels and sentence-style status expressions.

Examples:

- `phase.ready.label`
- `phase.ready.status`
- `phase.processing.label`
- `phase.processing.status`
- `phase.completed.label`
- `phase.completed.status`

### `workflow.*`
Workflow actions and support-region messages.

Examples:

- `workflow.action.start`
- `workflow.action.cancel`
- `workflow.action.retry`
- `workflow.support.noDocument`
- `workflow.support.readyToProcess`

### `settings.*`
Settings UI strings.

Examples:

- `settings.general.title`
- `settings.general.programLanguage.label`
- `settings.general.programLanguage.description`

### `shared.*`
Common reusable UI strings.

Examples:

- `shared.button.save`
- `shared.button.cancel`
- `shared.button.done`
- `shared.status.loading`

### `error.*`
Application-authored error messages.

Examples:

- `error.file.openFailed`
- `error.file.unsupportedFormat`
- `error.processing.failed`

### `external.*`
Localized wrappers around external payloads.

Examples:

- `external.import.failed`
- `external.processing.failed`

### `view.*`
Truly view-specific UI strings.

Examples:

- `view.about.title`
- `view.about.licenseSection`
- `view.inspector.emptyState`

## 10. Label and Status Split

Workflow states may require both:

- compact label form
- sentence-style status form

Especially in Korean, these should be treated as separate localized resources when the UI role differs.

Preferred examples:

- `phase.processing.label`
  - English: `Processing`
  - Korean: `처리 중`

- `phase.processing.status`
  - English: `Processing...`
  - Korean: `처리 중입니다...`

- `phase.completed.label`
  - English: `Completed`
  - Korean: `완료`

- `phase.completed.status`
  - English: `Completed`
  - Korean: `완료되었습니다`

## 11. Editing Principle

Localization resources must remain practical to edit in Xcode.

Therefore:

- use stable semantic keys
- keep English and Korean synchronized
- avoid opaque generated names
- avoid duplicated semantic keys
- prefer one obvious resource location for a string
- keep resource values understandable without code archaeology

## 12. Documentation Relationships

Related documents:

- `AGENTS.md`
- `docs/ux/terms.md`
- `docs/development.md`

Responsibility split:

- `docs/ux/terms.md` = terminology source of truth
- `AGENTS.md` = agent behavior rules
- `docs/development.md` = implementation guidance

## 13. Completion Reporting

When localization-related work is reported, the report should additionally state:

- whether `docs/ux/terms.md` was reviewed or updated
- whether `docs/ux/localization.md` was reviewed or updated
- whether `docs/development.md` was reviewed or updated
- whether English and Korean resources were both updated
- whether external payload text was preserved
- whether new localization keys were added
- whether any terminology decisions remain unresolved

## 14. Final Rule

If there is tension between translation purity and product clarity:

prefer product clarity.

If there is tension between convenience and consistency:

prefer consistency.

If there is tension between localization flexibility and workflow safety:

prefer workflow safety.
