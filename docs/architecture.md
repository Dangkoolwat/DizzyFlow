# DizzyFlow Architecture

## Overview

DizzyFlow is a macOS SwiftUI application built around a 6-phase workflow state machine for subtitle generation.
The app follows a "Workflow-first" philosophy with a 3-panel UI (Sidebar + Workspace + Inspector).

## Runtime Structure

`DizzyFlowApp` → `WorkflowStore` → `ContentView` → destination-specific views

- `DizzyFlowApp` creates one `WorkflowStore` for the app session.
- `WorkflowStore` owns the document list, selection, settings, workflow phase, and processing task.
- `ContentView` renders UI from store state and dispatches user actions back into the store.

## Layers

### App

- `DizzyFlowApp` is the application entry point.
- Creates and owns the shared `WorkflowStore`.

### Domain

- `SubtitleDocument` — the primary workflow item (title, phase, settings snapshot, segments, failure info).
- `SubtitleSegment` — individual subtitle unit with index, timecodes, and text content.

### State

- `WorkflowStore` is the single source of truth.
- Owns `documents: [SubtitleDocument]`, `selectedDocumentID`, and workflow settings (`selectedFPS`, `selectedLanguage`, `selectedTemplate`, `selectedModel`).
- `WorkflowPhase` (6 states): `idle` → `ready` → `processing` → `completed` | `failed` | `cancelled`.
- `ProcessingStep` (5 stages): `audioAnalysis` → `vadAnalysis` → `transcription` → `srtGeneration` → `fcpxmlGeneration`.
- State transitions: `startProcessing()`, `cancelProcessing()`, `restartProcessing()`, `startNewWorkflow()`.

### Features

- `ContentView` — main 3-panel layout with flat sidebar.
- `SidebarDestination` — selection model for Home, Document(UUID), and Settings.
- Phase-specific workspace views:
  - `HomeWorkspaceView` — Idle/Ready (file drop, settings bar, start button)
  - `ProcessingWorkspaceView` — Safe Lock with progress bar, cumulative scroll results, cancel button
  - `CompletedWorkspaceView` — SRT preview, FCPXML/SRT download, new workflow
  - `FailedWorkspaceView` — failure info, new workflow
  - `CancelledWorkspaceView` — cancel info, restart/new workflow
- `DocumentDetailView` — phase-based routing container (no internal list)
- `SettingsBarView` — top bar showing settings in Idle/Ready, processing messages otherwise
- `SegmentCardView` — individual subtitle segment card with highlight
- `InspectorPanelView` — contextual read-only information and Tips! cards

## Data Flow

1. The app launches; `WorkflowStore` starts with no documents.
2. User navigates to Home, adjusts settings, drops/selects a media file.
3. User presses "시작하기" — `WorkflowStore.startProcessing()`:
   - Creates `SubtitleDocument` with settings snapshot.
   - Inserts at top of `documents` array.
   - Sets `selectedDocumentID` → sidebar auto-navigates to new document.
   - Starts async mock workflow task.
4. During Processing: Safe Lock dims sidebar. Segments accumulate in real-time.
5. On completion/failure/cancel: document phase updates; user can download, restart, or start new.
6. User can switch to completed documents from the sidebar at any time.

## UI Composition

### Sidebar (Flat Structure)

- `Home` — fixed at top.
- `Documents` — `WorkflowStore.documents` listed directly (title + phase badge).
- `Settings` — fixed at bottom (placeholder).
- Safe Lock: entire sidebar disabled + dimmed during Processing.

### Workspace

- Routes via `SidebarDestination` in `ContentView`.
- Each phase has a dedicated view per UX docs.

### Inspector

- Destination-aware (Home / Document / Settings).
- Document inspector is further phase-aware (Idle, Processing, Completed, Failed, Cancelled).
- Shows metadata, settings snapshot, processing step list, Tips! cards.

## Current Constraints

- Workflow execution is a mock task with fixed delays.
- No engine abstraction, import/export, or persistence layer.
- Settings screen is a placeholder.
- File drop captures filename only (no actual media processing).

## Intended Direction

- Integrate real engine (Sherpa-onnx / WhisperKit) behind the store.
- Add persistence layer for documents.
- Implement Settings screen (General, VAD, Preprocessor, Models, About).
- Add file export (SRT, FCPXML) functionality.
