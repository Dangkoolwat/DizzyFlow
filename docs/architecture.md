# DizzyFlow Architecture

## Overview

DizzyFlow is currently a SwiftUI prototype organized around a single shared store.
The app validates a workflow-first interaction model before adding persistence, media import, or engine integration.

## Runtime Structure

The current runtime path is:

`DizzyFlowApp` -> `WorkflowStore` -> `ContentView` -> section-specific UI

- `DizzyFlowApp` creates one `WorkflowStore` for the app session.
- `WorkflowStore` owns document selection, workflow phase, and update timestamps.
- `ContentView` renders UI from store state and sends user actions back into the store.

## Layers

### App

- `DizzyFlowApp` is the application entry point.
- App-level dependency setup currently happens inline at launch.

### Domain

- `SubtitleDocument` is the only domain model implemented today.
- It stores lightweight metadata for a subtitle work item: identity, title, and creation date.

### State

- `WorkflowStore` is the central state container.
- It exposes seeded documents and the selected document identifier.
- Selected document state such as workflow phase and last update time is derived from the document itself.
- It also owns the mock async workflow task.

### Features

- `ContentView` contains the whole prototype UI.
- The view is split into three visible areas:
  - Sidebar for section selection
  - Workspace for the active section
  - Inspector for read-only context

## Data Flow

The current data flow is:

1. The app launches and creates a single `WorkflowStore`.
2. `ContentView` reads observable store state.
3. The user selects a section in the sidebar.
4. In the Documents section, the user selects a `SubtitleDocument`.
5. `WorkflowStore` updates the selected document and mutates document-scoped workflow state.
6. The user starts the mock workflow.
7. `WorkflowStore` runs an async task and advances the phase from `ready` to `processing` to `completed`.
8. The workspace and inspector re-render from the updated store state.

## UI Composition

### Sidebar

- Uses `SidebarSection` for top-level navigation.
- Current sections are `Home`, `Documents`, and `Recent`.

### Workspace

- `Home` is a landing screen for future media import.
- `Documents` is the active prototype flow and contains:
  - a document list
  - a detail panel
  - a trigger for the mock workflow
- `Recent` is currently a placeholder view.

### Inspector

- The inspector is read-only.
- It shows section-specific summary information.
- In the Documents section, it reflects the selected document, workflow phase, creation time, and last update time.

## Current Constraints

- Workflow execution is a mock task with fixed delays.
- There is no engine abstraction in code yet.
- There is no import, export, editing, or persistence layer.
- `ContentView` is currently large and mixes multiple feature surfaces in one file.

## Intended Direction

The current shape suggests a likely next architecture:

- keep `SubtitleDocument` as the canonical workflow item
- split `ContentView` into smaller feature views
- introduce engine and file pipeline boundaries behind the store
- preserve the read-only inspector pattern while expanding workspace actions
