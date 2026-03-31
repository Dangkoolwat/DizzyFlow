
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
