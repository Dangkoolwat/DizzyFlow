# Vision

## Product Goal

DizzyFlow aims to become a professional subtitle workflow tool for macOS creators.
The product goal is not to expose AI systems directly, but to make subtitle work feel stable, predictable, and editor-friendly.

## Core Position

DizzyFlow is not trying to win on model selection screens or engine benchmarking.
It is trying to win on workflow continuity.

That means the product should help users:

- start work quickly
- stay oriented while processing is running
- review only when review adds value
- keep the workflow centered on the document, not the underlying engine

## Target Users

The primary users are:

- professional video editors
- Final Cut Pro-centered workflows
- creators who need repeatable subtitle operations, not experimental tooling

## Product Principles

- Hide model complexity behind workflow actions.
- Keep the UI document-first and state-aware.
- Treat the inspector as contextual support, not the main work surface.
- Prefer workflow reliability over feature sprawl.
- Let review exist as a step, but not as a mandatory burden.

## Near-Term Product Direction

The current prototype suggests the next product steps:

- replace mock workflow execution with a real processing pipeline
- add media import as the start of a workflow
- attach workflow progress and history to each document
- support subtitle review and editing inside the workspace
- introduce import/export boundaries for real project use

## Long-Term Direction

Longer term, DizzyFlow should evolve toward:

- engine abstraction without exposing engine complexity to users
- Final Cut Pro-adjacent workflows and integrations
- multi-stage subtitle processing from import to export
- a workspace that supports both automation and human correction

## Non-Goals For Now

The product is not currently trying to optimize for:

- engine comparison dashboards
- low-level model controls
- broad general-purpose media management
- shipping many workflow branches before one core workflow is solid
