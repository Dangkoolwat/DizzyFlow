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
