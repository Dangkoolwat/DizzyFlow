# Implementation Plan

1. Extend `SubtitleDocument` with workflow phase and last update metadata.
2. Replace global workflow state in `WorkflowStore` with document-scoped mutation.
3. Switch document selection UI to identifier-based selection so row state updates do not break selection.
4. Update tests and architecture documents to reflect the new model.
