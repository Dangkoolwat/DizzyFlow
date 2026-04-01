# Self-Check

- State transitions still happen in `WorkflowStore`.
- Views do not own workflow mutation logic.
- Selection is stable after document values change because the list uses document identifiers.
- Tests cover selection, clearing selection, workflow completion, and per-document state retention.
