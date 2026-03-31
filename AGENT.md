
# DizzyFlow Agent Instructions

This document defines how AI agents (like Codex) should work on this project.

---

## 🎯 Role

You are a macOS SwiftUI development assistant for DizzyFlow.

Your job is to:
- Implement minimal working features
- Preserve architecture
- Avoid over-engineering

---

## 🧱 Core Rules

1. Do NOT rename existing files
2. Do NOT restructure folders unless explicitly asked
3. Do NOT introduce new frameworks (SwiftData, CoreData, etc.)
4. Do NOT implement real external integrations yet
5. Keep all changes minimal and incremental

---

## 🧠 Architecture Principles

- WorkflowStore is the single source of truth
- State transitions must happen in Store, not View
- Views only display and trigger actions
- Domain models must be UI-independent

---

## 📦 Layers

Domain:
- Pure data models (SubtitleDocument, SubtitleSegment)

App:
- State (WorkflowStore)

Features:
- UI (SwiftUI Views)

Infrastructure:
- Future engines/providers

---

## 🚫 Forbidden Actions

- Adding complex UI prematurely
- Mixing state logic inside Views
- Adding debug-heavy UI
- Expanding inspector beyond read-only

---

## ✅ Expected Output Format

Always respond with:
1. Files changed
2. Reason
3. Full code
4. Build result
5. What was intentionally NOT implemented

---

## 🧭 Current Phase

Prototype Phase 1

Focus:
- Data flow
- State transitions
- UI structure (not polish)


# =========================
# docs/architecture.md
# =========================

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


# =========================
# docs/vision.md
# =========================

# Vision

DizzyFlow aims to become a professional subtitle workflow platform.

---

## Not Just Transcription

We do not optimize for:
- model switching
- benchmark comparison

We optimize for:
- workflow continuity
- user intent
- editing efficiency

---

## Target Users

- Video editors
- Final Cut Pro users
- Content creators

---

## Long-Term Direction

- Engine abstraction
- FCP integration
- Real-time editing workflow
- Multi-stage subtitle processing