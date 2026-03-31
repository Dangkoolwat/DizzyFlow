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
                homeView

            case .documents:
                documentsWorkspace

            case .recent:
                placeholderWorkspace(
                    title: "Recent Workflows",
                    message: "Recent workflows will appear here."
                )
            }
        }
    }

    private var homeView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("DizzyFlow")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Workflow-first subtitle tool")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                .frame(maxWidth: .infinity, minHeight: 180)
                .foregroundStyle(.secondary)
                .overlay(
                    VStack(spacing: 8) {
                        Text("Drag media here")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("or choose a file to start")
                            .foregroundStyle(.secondary)
                    }
                )

            Button("Choose Media File") {
                // placeholder
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Text("Start a new subtitle workflow by landing your media here.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(40)
    }

    private var documentsWorkspace: some View {
        HStack(spacing: 0) {
            documentList
                .listStyle(.sidebar)
                .frame(minWidth: 220, idealWidth: 260)

            Divider()

            documentDetailView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var documentDetailView: some View {
        Group {
            if let document = store.selectedDocument {
                VStack(spacing: 24) {
                    Spacer()

                    VStack(spacing: 4) {
                        Text(document.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Phase: \(store.currentPhase.rawValue.capitalized)")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    Button("Start Mock Workflow") {
                        store.startMockWorkflow()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Spacer()
                }
                .padding(40)
            } else {
                welcomeView
            }
        }
    }

    private func placeholderWorkspace(title: String, message: String) -> some View {
        VStack(spacing: 12) {
            Spacer()

            Text(title)
                .font(.title)
                .fontWeight(.semibold)

            Text(message)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(40)
    }

    private var documentList: some View {
        List(store.documents, selection: documentSelection) { document in
            Label(document.title, systemImage: "doc.text")
                .tag(document)
        }
    }

    private var welcomeView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "waveform.and.mic")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text("DizzyFlow")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Workflow-first subtitle prototype")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 6) {
                Text("Start by choosing or importing media.")
                Text("The right inspector stays empty until there is meaningful context to show.")
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(40)
    }

    private var inspectorPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Inspector")
                .font(.headline)

            Divider()

            switch selectedSection {
            case .home:
                VStack(alignment: .leading, spacing: 12) {
                    infoRow(title: "Section", value: "Home")
                    infoRow(title: "State", value: "Idle")
                    infoRow(title: "Summary", value: "Start a new subtitle workflow from media input")
                    infoRow(title: "Tip", value: "Drag media or choose a file")
                }

            case .documents:
                if let document = store.selectedDocument {
                    VStack(alignment: .leading, spacing: 12) {
                        infoRow(title: "Document", value: document.title)
                        infoRow(title: "State", value: store.currentPhase.rawValue.capitalized)
                        infoRow(title: "Created", value: document.createdAt.formatted(date: .abbreviated, time: .shortened))
                        if let updated = store.lastUpdated {
                            infoRow(title: "Last Updated", value: updated.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("No Context")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text("Select a document to view its state.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

            case .recent:
                VStack(alignment: .leading, spacing: 12) {
                    infoRow(title: "Section", value: "Recent")
                    infoRow(title: "State", value: "Idle")
                    infoRow(title: "Summary", value: "Recent workflows will appear here")
                }
            }

            Spacer()
        }
        .padding(16)
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
        }
    }

    private var documentSelection: Binding<SubtitleDocument?> {
        Binding(
            get: { store.selectedDocument },
            set: { store.selectDocument($0) }
        )
    }
}

private enum SidebarSection: String, CaseIterable, Identifiable {
    case home
    case documents
    case recent

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .documents:
            return "Documents"
        case .recent:
            return "Recent"
        }
    }

    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .documents:
            return "doc.on.doc"
        case .recent:
            return "clock"
        }
    }
}

#Preview {
    ContentView(store: WorkflowStore())
}
