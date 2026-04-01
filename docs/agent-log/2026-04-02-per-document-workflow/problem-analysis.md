# Problem Analysis

## Problem

The workflow phase was stored globally in `WorkflowStore`.
That meant workflow progress belonged to the current selection instead of the document itself.

## Consequences

- Changing selection could hide the actual state of previously processed documents.
- The inspector and documents workspace could only describe one global phase.
- The data model did not match the workflow-first direction described in the docs.
