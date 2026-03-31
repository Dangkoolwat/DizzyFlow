# DizzyFlow Architecture

---

## Core Flow

User Intent → WorkflowStore → Engine (future) → SubtitleDocument → UI

---

## Key Concepts

### WorkflowStore
- Entry point of all state transitions
- Owns workflow phase

### SubtitleDocument
- Normalized data structure
- Independent of engine output

---

## UI Structure

    Sidebar
    Workspace
    Inspector (read-only)

---

## Design Decisions

- Inspector is read-only
- Actions happen in workspace
- Review is optional

---

## Current Limitations

- No persistence
- No engine integration
- No editing pipeline


# =========================
# docs/workflow.md
# =========================

# Workflow Model

---

## States

- idle
- ready
- processing
- completed

---

## Flow

1. User selects document
2. State → ready
3. User triggers workflow
4. State → processing
5. Mock delay
6. State → completed

---

## Future Extensions

- cancellation
- error states
- retry
- multi-stage pipeline