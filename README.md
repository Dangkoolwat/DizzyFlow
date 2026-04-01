# DizzyFlow

A workflow-first subtitle platform for macOS creators.

DizzyFlow is designed for professional video editors, especially those working with Final Cut Pro, focusing on preserving workflow continuity rather than exposing AI model complexity.

---

## 🚀 Current Status

Prototype Phase 1

- NavigationSplitView layout
- WorkflowStore (state management)
- SubtitleDocument (core data model)
- Mock workflow (ready → processing → completed)
- Read-only inspector

---

## 🧠 Philosophy

- Technology stays in the engine room
- Users choose intent, not models
- Workflow stability over feature expansion
- All data flows through SubtitleDocument
- Review is optional

---

## 🏗 Architecture (Overview)

Core flow:

    User Intent → WorkflowStore → Engine (future) → SubtitleDocument → UI

UI structure:

    Sidebar → navigation
    Workspace → main interaction
    Inspector → read-only context

---

## 📁 Project Structure

    App
    Domain
    Features
    Infrastructure
    Shared

---

## 📚 Documentation

- architecture.md → system structure
- vision.md → product direction
- AGENT.md → development rules
- docs/decisions → architecture decisions (ADR)
- docs/release-checklist.md → release checklist

---

## 🛣 Roadmap

- SubtitleSegment model
- File input pipeline
- Engine abstraction
- Editing workflow
- Final Cut Pro integration

---

## ⚠️ Not Included Yet

- Real STT engine
- File import/export
- Editing UI
- External integrations
- Persistence

---

## 👤 Author

Sanghyouk Jin
