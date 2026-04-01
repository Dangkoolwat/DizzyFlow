# DizzyFlow

DizzyFlow is a workflow-first subtitle prototype for macOS.
The current build focuses on validating state flow and UI structure before adding real media processing.

## Current Status

The app currently includes:

- a `NavigationSplitView` shell with sidebar, workspace, and inspector
- a seeded document list managed by `WorkflowStore`
- a document-scoped mock workflow with `idle`, `ready`, `processing`, and `completed` phases
- a read-only inspector that reflects section and document context

## Current Architecture

Runtime flow:

`DizzyFlowApp` -> `WorkflowStore` -> `ContentView`

Core pieces:

- `DizzyFlowApp`: app entry point and store wiring
- `WorkflowStore`: shared state container and workflow transition owner
- `SubtitleDocument`: lightweight domain model for a work item and its workflow state
- `ContentView`: prototype UI for navigation, workspace, and inspector

## Project Structure

- `DizzyFlow/App`: app entry point and shared store
- `DizzyFlow/Domain`: domain models
- `DizzyFlow/Features`: SwiftUI screens and feature UI
- `docs`: product, architecture, workflow, and release documents
- `DizzyFlowTests`: unit tests
- `DizzyFlowUITests`: UI tests

## Documentation

- [docs/vision.md](/Users/sanghyoukjin/XcodeProjects/DizzyFlow/docs/vision.md): product direction
- [docs/workflow.md](/Users/sanghyoukjin/XcodeProjects/DizzyFlow/docs/workflow.md): workflow states and transitions
- [docs/architecture.md](/Users/sanghyoukjin/XcodeProjects/DizzyFlow/docs/architecture.md): app structure and data flow
- [docs/release_checklist.md](/Users/sanghyoukjin/XcodeProjects/DizzyFlow/docs/release_checklist.md): release readiness checklist
- [AGENT.md](/Users/sanghyoukjin/XcodeProjects/DizzyFlow/AGENT.md): repository-specific working rules

## Not Implemented Yet

- real media import
- speech-to-text or subtitle engine integration
- subtitle editing workflow
- import/export pipeline
- persistence
- per-document workflow history beyond current in-memory phase tracking
