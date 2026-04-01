import SwiftUI

struct InspectorPanelView: View {
    let selectedSection: SidebarSection
    @ObservedObject var store: WorkflowStore

    var body: some View {
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
                        infoRow(
                            title: "Created",
                            value: document.createdAt.formatted(date: .abbreviated, time: .shortened)
                        )
                        if let updated = store.lastUpdated {
                            infoRow(
                                title: "Last Updated",
                                value: updated.formatted(date: .abbreviated, time: .shortened)
                            )
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
}

#Preview {
    InspectorPanelView(selectedSection: .documents, store: WorkflowStore())
}
