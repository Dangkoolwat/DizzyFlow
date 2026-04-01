import SwiftUI

struct ContentView: View {
    @ObservedObject var store: WorkflowStore
    @State private var selectedSection: SidebarSection = .home
    @State private var showsInspector: Bool = true

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            HStack(spacing: 0) {
                mainWorkspace
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if showsInspector {
                    Divider()

                    inspectorPanel
                        .frame(width: 280)
                        .background(.background)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        showsInspector.toggle()
                    } label: {
                        Image(systemName: showsInspector ? "sidebar.right" : "sidebar.right")
                    }
                    .help(showsInspector ? "Hide Inspector" : "Show Inspector")
                }
            }
        }
        .frame(minWidth: 1000, minHeight: 640)
    }

    private var sidebar: some View {
        List(selection: $selectedSection) {
            ForEach(SidebarSection.allCases) { section in
                Label(section.title, systemImage: section.systemImage)
                    .tag(section)
            }
        }
        .navigationTitle("DizzyFlow")
    }

    private var mainWorkspace: some View {
        Group {
            switch selectedSection {
            case .home:
                HomeWorkspaceView()

            case .documents:
                DocumentsWorkspaceView(store: store)

            case .recent:
                PlaceholderWorkspaceView(
                    title: "Recent Workflows",
                    message: "Recent workflows will appear here."
                )
            }
        }
    }

    private var inspectorPanel: some View {
        InspectorPanelView(selectedSection: selectedSection, store: store)
    }
}

#Preview {
    ContentView(store: WorkflowStore())
}
