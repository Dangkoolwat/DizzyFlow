# Workflow Model

## Purpose

This document describes the current prototype workflow implemented in `WorkflowStore`.
The workflow is intentionally simple and exists to validate the app's state model and UI flow before engine integration.

## Current Actors

- `ContentView` presents the workflow UI.
- `WorkflowStore` owns document selection and workflow phase transitions.
- `SubtitleDocument` represents the selected work item.

## Workflow Phases

The app currently uses four phases:

- `idle`: no document is selected.
- `ready`: a document is selected and the workflow can start.
- `processing`: the mock workflow is running.
- `completed`: the mock workflow finished.

## Transition Rules

### Selection-Driven Transitions

1. App starts with seeded documents and no selection.
2. When no document is selected, the phase stays `idle`.
3. When the user selects a document, the phase becomes `ready`.
4. When the user clears the selection, the phase returns to `idle`.

### Workflow-Driven Transitions

1. The user selects a document in the Documents section.
2. The user triggers `Start Mock Workflow`.
3. The store resets the phase to `ready`.
4. After the first mock delay, the phase moves to `processing`.
5. After the second mock delay, the phase moves to `completed`.

## Notes About Current Behavior

- Workflow phase and `lastUpdated` are stored per document.
- Starting a new workflow cancels any previous in-flight mock task.
- Selecting a document moves that document into `ready`.
- `lastUpdated` is refreshed on every visible transition for the active document.
- There is no persistence, so selection and progress reset when the app restarts.

## UI Mapping

- `Home`: landing surface for starting a new workflow in the future.
- `Documents`: current working area for selecting a document and running the mock workflow.
- `Inspector`: read-only summary of the selected section and document state.

## Known Gaps

- No cancellation UI even though the underlying task can be cancelled.
- No failure or retry state.
- No real engine or subtitle generation pipeline.
- No per-document workflow history.

## Future Extensions

- Add explicit `failed` and `cancelled` phases.
- Replace mock delays with a real processing pipeline.
- Track pipeline stages such as import, transcription, review, and export.
