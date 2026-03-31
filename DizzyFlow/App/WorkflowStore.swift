import Foundation
import Combine

@MainActor
final class WorkflowStore: ObservableObject {

    @Published var documents: [SubtitleDocument] = [
        SubtitleDocument(title: "Interview_001"),
        SubtitleDocument(title: "Podcast_Test"),
        SubtitleDocument(title: "YouTube_Sample")
    ]

    @Published var selectedDocument: SubtitleDocument?
    @Published var currentPhase: WorkflowPhase = .idle
    @Published var lastUpdated: Date?

    private var workflowTask: Task<Void, Never>?

    func selectDocument(_ document: SubtitleDocument?) {
        selectedDocument = document

        if document == nil {
            currentPhase = .idle
            lastUpdated = nil
        } else {
            currentPhase = .ready
            lastUpdated = Date()
        }
        workflowTask?.cancel()
    }

    func startMockWorkflow() {
        guard selectedDocument != nil else {
            return
        }

        workflowTask?.cancel()
        workflowTask = Task { [weak self] in
            await self?.runMockWorkflow()
        }
    }

    private func runMockWorkflow() async {
        guard !Task.isCancelled, selectedDocument != nil else { return }

        currentPhase = .ready
        lastUpdated = Date()

        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {
            return
        }

        guard !Task.isCancelled, selectedDocument != nil else { return }

        currentPhase = .processing
        lastUpdated = Date()

        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {
            return
        }

        guard !Task.isCancelled, selectedDocument != nil else { return }

        currentPhase = .completed
        lastUpdated = Date()
        workflowTask = nil
    }
}

enum WorkflowPhase: String {
    case idle
    case ready
    case processing
    case completed
}
