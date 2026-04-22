# Graph Report - /Users/sanghyoukjin/XcodeProjects/DizzyFlow  (2026-04-21)

## Corpus Check
- 22 files · ~24,785 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 151 nodes · 221 edges · 12 communities detected
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 22 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]

## God Nodes (most connected - your core abstractions)
1. `WorkflowStore` - 18 edges
2. `InspectorPanelView` - 12 edges
3. `WorkflowPhase` - 9 edges
4. `SettingsCategory` - 9 edges
5. `ProcessingStep` - 8 edges
6. `HomeWorkspaceView` - 8 edges
7. `AppTheme` - 7 edges
8. `DizzyFlowUITests` - 6 edges
9. `DizzyFlowTests` - 6 edges
10. `UpwardMenuPicker` - 6 edges

## Surprising Connections (you probably didn't know these)
- `detailSaveFooter()` --calls--> `CapsuleActionButton`  [INFERRED]
  /Users/sanghyoukjin/XcodeProjects/DizzyFlow/DizzyFlow/Features/SettingsWorkspaceView.swift → /Users/sanghyoukjin/XcodeProjects/DizzyFlow/DizzyFlow/Features/CapsuleActionButton.swift

## Communities

### Community 0 - "Community 0"
Cohesion: 0.09
Nodes (21): CaseIterable, SegmentCardView, String, AppTheme, auto, dark, light, GlobalSettings (+13 more)

### Community 1 - "Community 1"
Cohesion: 0.14
Nodes (12): BottomControlStack, CapsuleActionButton, SettingsBarView, AboutSettingsView, detailSaveFooter(), GeneralSettingsView, LicenseSettingsView, ModelsSettingsView (+4 more)

### Community 2 - "Community 2"
Cohesion: 0.19
Nodes (3): DizzyFlowTests, ObservableObject, WorkflowStore

### Community 3 - "Community 3"
Cohesion: 0.15
Nodes (5): CancelledWorkspaceView, CompletedWorkspaceView, DocumentDetailView, FailedWorkspaceView, ProcessingWorkspaceView

### Community 4 - "Community 4"
Cohesion: 0.15
Nodes (9): Hashable, Identifiable, ModelItem, SidebarDestination, document, home, settings, SubtitleDocument (+1 more)

### Community 5 - "Community 5"
Cohesion: 0.52
Nodes (1): InspectorPanelView

### Community 6 - "Community 6"
Cohesion: 0.21
Nodes (4): Coordinator, UpwardMenuPicker, NSObject, NSViewRepresentable

### Community 7 - "Community 7"
Cohesion: 0.18
Nodes (3): DizzyFlowUITests, DizzyFlowUITestsLaunchTests, XCTestCase

### Community 8 - "Community 8"
Cohesion: 0.24
Nodes (2): HomeWorkspaceView, PendingFileInfo

### Community 9 - "Community 9"
Cohesion: 0.33
Nodes (6): SettingsCategory, about, general, license, models, vad

### Community 10 - "Community 10"
Cohesion: 0.67
Nodes (1): ContentView

### Community 11 - "Community 11"
Cohesion: 0.67
Nodes (2): App, DizzyFlowApp

## Knowledge Gaps
- **23 isolated node(s):** `light`, `dark`, `auto`, `GlobalSettings`, `idle` (+18 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `HomeWorkspaceView` connect `Community 8` to `Community 1`, `Community 6`?**
  _High betweenness centrality (0.277) - this node is a cross-community bridge._
- **Why does `WorkflowStore` connect `Community 2` to `Community 0`, `Community 8`?**
  _High betweenness centrality (0.225) - this node is a cross-community bridge._
- **Why does `SettingsCategory` connect `Community 9` to `Community 0`, `Community 1`, `Community 4`?**
  _High betweenness centrality (0.135) - this node is a cross-community bridge._
- **Are the 5 inferred relationships involving `WorkflowStore` (e.g. with `.selectingDocumentSetsReadyPhase()` and `.clearingSelectionReturnsToIdle()`) actually correct?**
  _`WorkflowStore` has 5 INFERRED edges - model-reasoned connections that need verification._
- **What connects `light`, `dark`, `auto` to the rest of the system?**
  _23 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.09 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.14 - nodes in this community are weakly interconnected._