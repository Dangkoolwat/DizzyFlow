# Walkthrough

## Data Model

`SubtitleDocument` now carries `workflowPhase` and `lastUpdated`.

## Store

`WorkflowStore` keeps `selectedDocumentID` and updates documents in place.
Mock workflow execution now targets a specific document identifier.

## UI

The documents list uses identifier-based selection.
Each row shows the document title and current phase.
Inspector and detail views continue to read through `WorkflowStore`.
