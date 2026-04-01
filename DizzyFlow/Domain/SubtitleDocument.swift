import Foundation

struct SubtitleDocument: Identifiable, Hashable {
    let id: UUID
    var title: String
    var createdAt: Date
    var workflowPhase: WorkflowPhase
    var lastUpdated: Date?

    init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = Date(),
        workflowPhase: WorkflowPhase = .idle,
        lastUpdated: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.workflowPhase = workflowPhase
        self.lastUpdated = lastUpdated
    }
}
