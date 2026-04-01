import Foundation
import Combine

@MainActor
final class WorkflowStore: ObservableObject {
    @Published var documents: [SubtitleDocument]
    @Published var selectedDocumentID: SubtitleDocument.ID?

    private var workflowTask: Task<Void, Never>?
    private let mockStepDurationNanoseconds: UInt64

    init(
        documents: [SubtitleDocument]? = nil,
        mockStepDurationNanoseconds: UInt64 = 1_000_000_000
    ) {
        self.documents = documents ?? [
            SubtitleDocument(title: "Interview_001"),
            SubtitleDocument(title: "Podcast_Test"),
            SubtitleDocument(title: "YouTube_Sample")
        ]
        self.mockStepDurationNanoseconds = mockStepDurationNanoseconds
    }

    var selectedDocument: SubtitleDocument? {
        guard let selectedDocumentID else {
            return nil
        }

        return documents.first { $0.id == selectedDocumentID }
    }

    var currentPhase: WorkflowPhase {
        selectedDocument?.workflowPhase ?? .idle
    }

    var lastUpdated: Date? {
        selectedDocument?.lastUpdated
    }

    func selectDocument(_ document: SubtitleDocument?) {
        workflowTask?.cancel()
        workflowTask = nil
        selectedDocumentID = document?.id

        guard let selectedDocumentID else {
            return
        }

        updateDocument(id: selectedDocumentID) { document in
            document.workflowPhase = .ready
            document.lastUpdated = Date()
        }
    }

    func startMockWorkflow() {
        guard let selectedDocumentID else {
            return
        }

        workflowTask?.cancel()
        workflowTask = Task { [weak self] in
            await self?.runMockWorkflow(for: selectedDocumentID)
        }
    }

    private func runMockWorkflow(for documentID: SubtitleDocument.ID) async {
        guard !Task.isCancelled, selectedDocumentID == documentID else { return }

        updatePhase(.ready, for: documentID)

        do {
            try await Task.sleep(nanoseconds: mockStepDurationNanoseconds)
        } catch {
            return
        }

        guard !Task.isCancelled, selectedDocumentID == documentID else { return }

        updatePhase(.processing, for: documentID)

        do {
            try await Task.sleep(nanoseconds: mockStepDurationNanoseconds)
        } catch {
            return
        }

        guard !Task.isCancelled, selectedDocumentID == documentID else { return }

        updatePhase(.completed, for: documentID)
        workflowTask = nil
    }

    private func updatePhase(_ phase: WorkflowPhase, for documentID: SubtitleDocument.ID) {
        updateDocument(id: documentID) { document in
            document.workflowPhase = phase
            document.lastUpdated = Date()
        }
    }

    private func updateDocument(
        id: SubtitleDocument.ID,
        _ update: (inout SubtitleDocument) -> Void
    ) {
        guard let index = documents.firstIndex(where: { $0.id == id }) else {
            return
        }

        update(&documents[index])
    }
}

enum WorkflowPhase: String {
    case idle
    case ready
    case processing
    case completed
}
