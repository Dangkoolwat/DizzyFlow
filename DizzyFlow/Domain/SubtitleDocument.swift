import Foundation

/// 하나의 자막 작업 문서. WorkflowStore를 통해 관리된다.
///
/// segments와 currentlyProcessingID는 Processing 단계에서
/// 실시간 데이터 누적과 하이라이트를 지원하기 위한 본체 프로퍼티다.
struct SubtitleDocument: Identifiable, Hashable {
    let id: UUID
    var title: String
    var createdAt: Date
    var workflowPhase: WorkflowPhase
    var lastUpdated: Date?

    // MARK: - Processing 실시간 데이터

    /// 엔진이 생성한 세그먼트의 누적 배열
    var segments: [SubtitleSegment]

    /// 현재 처리 중인 세그먼트 ID (하이라이트용)
    var currentlyProcessingID: UUID?

    // MARK: - 입력/결과 메타정보

    /// 선택한 미디어 파일명
    var inputFileName: String?

    /// 실패 시 어느 단계에서 실패했는지
    var failedStep: String?

    /// 실패 시 사용자 안내 메시지
    var failureMessage: String?

    // MARK: - 작업 당시 설정 스냅샷

    var settingsFPS: String?
    var settingsLanguage: String?
    var settingsTemplate: String?
    var settingsModel: String?

    init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = Date(),
        workflowPhase: WorkflowPhase = .idle,
        lastUpdated: Date? = nil,
        segments: [SubtitleSegment] = [],
        currentlyProcessingID: UUID? = nil,
        inputFileName: String? = nil,
        failedStep: String? = nil,
        failureMessage: String? = nil,
        settingsFPS: String? = nil,
        settingsLanguage: String? = nil,
        settingsTemplate: String? = nil,
        settingsModel: String? = nil
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.workflowPhase = workflowPhase
        self.lastUpdated = lastUpdated
        self.segments = segments
        self.currentlyProcessingID = currentlyProcessingID
        self.inputFileName = inputFileName
        self.failedStep = failedStep
        self.failureMessage = failureMessage
        self.settingsFPS = settingsFPS
        self.settingsLanguage = settingsLanguage
        self.settingsTemplate = settingsTemplate
        self.settingsModel = settingsModel
    }
}
