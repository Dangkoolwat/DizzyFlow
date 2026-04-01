# Proposal

## Change

Move workflow phase and update timestamp onto `SubtitleDocument`.
Keep selection state in `WorkflowStore`, but derive the visible workflow state from the selected document.

## Expected Benefit

- Workflow progress becomes document-scoped.
- The store remains the single transition owner.
- UI can show state for each document without inventing a separate persistence layer yet.
