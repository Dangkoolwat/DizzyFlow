import SwiftUI

struct DocumentsWorkspaceView: View {
    @ObservedObject var store: WorkflowStore

    var body: some View {
        HStack(spacing: 0) {
            List(store.documents, selection: documentSelection) { document in
                documentRow(for: document)
                    .tag(document.id)
            }
            .listStyle(.sidebar)
            .frame(minWidth: 220, idealWidth: 260)

            Divider()

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
                    DocumentsWelcomeView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func documentRow(for document: SubtitleDocument) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(document.title)
            Text(document.workflowPhase.rawValue.capitalized)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var documentSelection: Binding<SubtitleDocument.ID?> {
        Binding(
            get: { store.selectedDocumentID },
            set: { newValue in
                store.selectDocument(
                    store.documents.first { $0.id == newValue }
                )
            }
        )
    }
}

private struct DocumentsWelcomeView: View {
    var body: some View {
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
}

#Preview {
    DocumentsWorkspaceView(store: WorkflowStore())
}
