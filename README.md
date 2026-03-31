# DizzyFlow

DizzyFlow is a workflow-first subtitle platform designed for creators using tools like Final Cut Pro.

This is not just a transcription tool.  
It is a system designed to preserve and accelerate the user's workflow.

---

## 🚀 Current Status

Early prototype (v0.1)

- NavigationSplitView layout
- WorkflowStore with state transitions
- SubtitleDocument core model
- Mock workflow (ready → processing → completed)
- Read-only inspector panel

---

## 🧠 Philosophy

- Technology stays in the engine room
- Users choose intent, not models
- Workflow stability over feature expansion
- All data flows through SubtitleDocument

---

## 🏗 Architecture Overview

    Sidebar → User Entry / Navigation
    Workspace → Main Workflow Area
    Inspector → Read-only context panel

Core components:

- WorkflowStore (state entry point)
- SubtitleDocument (normalized data model)
- SwiftUI + Observation (@Observable)

---

## 📁 Project Structure

    App
    Domain
    Features
    Infrastructure
    Shared

---

## ⚠️ What is NOT included (yet)

- Real STT engine
- File import/export
- Drag & drop
- Editing UI
- External integrations

---

## 🛣 Roadmap (short)

- Home workflow entry
- SubtitleSegment model
- Result rendering
- File input pipeline
- Engine abstraction

---

## 👤 Author

Sanghyouk Jin