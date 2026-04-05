import Foundation
import Combine
import SwiftUI // ColorScheme 및 UI 관련 타입 지원용

// MARK: - AppTheme

/// DizzyFlow의 전역 색상 테마 설정.
enum AppTheme: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case auto = "Auto"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .auto: return "circle.lefthalf.filled"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .auto: return nil
        }
    }
}

// MARK: - GlobalSettings

/// 앱 전체에서 유지되는 설정 데이터. (Detail Job Desc 6 반영)
struct GlobalSettings {
    // General (일반)
    var language: String = "Korean"        // 드롭다운: 한국어 | 영어
    var theme: AppTheme = .auto
    var removeSymbolEnabled: Bool = false // 자동생성 문서에서 특정 기호 삭제
    var modelDownloadLocation: String = "/usr/local/share/dizzyflow/models"

    // VAD (Voice Activity Detection)
    var vadThreshold: Double = 0.5
    var vadAggressiveness: Int = 2

    // Preprocessor (전처리)
    var noiseReductionEnabled: Bool = true
    var normalizationEnabled: Bool = true

    // Models (모델)
    var selectedEngine: String = "Sherpa-onnx"
    // 각 서비스별 모델 정보 (향후 JSON 연동 예정)
    var modelInfoJSON: String = "{}"

    // License (라이선스)
    var licenseInfo: String = "DizzyFlow는 다음 오픈소스 라이브러리를 사용합니다:\n- WhisperKit\n- Sherpa-onnx\n- Swift UI"

    // Gemma4 (향후)
    var gemmaPrompt: String = "기본 프롬프트: 자막의 가독성을 높여주세요."
}

// MARK: - WorkflowPhase

/// DizzyFlow의 6단계 상태 머신.
/// docs/ux/dizzyflow_ux_processing_terminal_states.md 와 동기화되어 있다.
enum WorkflowPhase: String, CaseIterable {
    case idle
    case ready
    case processing
    case completed
    case failed
    case cancelled
}

// MARK: - ProcessingStep

/// Processing 중 세부 단계. 상단 메시지와 진행 바에 사용된다.
enum ProcessingStep: String, CaseIterable {
    case audioAnalysis   = "오디오 분석 중..."
    case vadAnalysis     = "VAD 분석 중..."
    case transcription   = "전사 생성 중..."
    case srtGeneration   = "SRT 생성 중..."
    case fcpxmlGeneration = "FCPXML 생성 중..."

    /// 전체 단계 수 대비 현재 단계의 진행률 (0.0 ~ 1.0)
    var progress: Double {
        guard let index = Self.allCases.firstIndex(of: self) else { return 0 }
        return Double(index + 1) / Double(Self.allCases.count)
    }
}

// MARK: - PendingFileInfo

/// Ready 상태에서 사용자에게 보여줄 파일 메타 정보. (Mock)
/// Document는 아직 생성하지 않으며, 시작 버튼 클릭 시점에 Document로 전환.
struct PendingFileInfo {
    let fileName: String
    let fileExtension: String
    let displaySize: String
    let displayDuration: String
    let displayFormat: String
    let displayCodec: String

    /// 파일명에서 Mock 메타 정보를 자동 생성
    init(fileName: String) {
        self.fileName = fileName
        self.fileExtension = (fileName as NSString).pathExtension.lowercased()

        // Mock metadata — 프로토타입용 가상 값
        switch fileExtension {
        case "mov":
            displaySize = "2.4 GB"
            displayDuration = "00:28:15"
            displayFormat = "Apple ProRes 422"
            displayCodec = "PCM Audio / ProRes Video"
        case "mp4":
            displaySize = "1.1 GB"
            displayDuration = "00:45:30"
            displayFormat = "H.264 / AAC"
            displayCodec = "AAC Audio / H.264 Video"
        case "wav", "mp3", "m4a", "aac":
            displaySize = "320 MB"
            displayDuration = "01:12:00"
            displayFormat = "Audio Only"
            displayCodec = fileExtension.uppercased()
        default:
            displaySize = "1.8 GB"
            displayDuration = "00:35:42"
            displayFormat = "Media File"
            displayCodec = "Unknown"
        }
    }

    /// SF Symbol name for file type icon
    var systemIcon: String {
        switch fileExtension {
        case "mov", "mp4", "avi", "mkv":
            return "film"
        case "wav", "mp3", "m4a", "aac":
            return "waveform"
        default:
            return "doc"
        }
    }
}

// MARK: - WorkflowStore

@MainActor
final class WorkflowStore: ObservableObject {

    // MARK: Published State

    @Published var documents: [SubtitleDocument]
    @Published var selectedDocumentID: SubtitleDocument.ID?

    /// Processing 중 현재 세부 단계
    @Published var currentProcessingStep: ProcessingStep?

    // MARK: - Global Settings & Theme

    /// 전역 앱 테마 (상단 툴바에서 제어)
    @Published var appTheme: AppTheme = .auto

    /// 상세 설정 데이터
    @Published var globalSettings: GlobalSettings = GlobalSettings()

    /// Ready 단계의 대기 중인 파일 정보 (Document 생성 전 상태)
    @Published var pendingFile: PendingFileInfo?

    // MARK: Workflow Settings (Idle/Ready에서 수정 가능)

    @Published var selectedFPS: String = "23.976"
    @Published var selectedLanguage: String = "Korean"
    @Published var selectedTemplate: String = "Default"
    @Published var selectedModel: String = "Sherpa-onnx"

    // MARK: Private

    private var workflowTask: Task<Void, Never>?
    private let mockStepDurationNanoseconds: UInt64

    // MARK: Init

    init(
        documents: [SubtitleDocument]? = nil,
        mockStepDurationNanoseconds: UInt64 = 1_500_000_000
    ) {
        self.documents = documents ?? []
        self.mockStepDurationNanoseconds = mockStepDurationNanoseconds
    }

    // MARK: - Computed Properties

    var selectedDocument: SubtitleDocument? {
        guard let selectedDocumentID else { return nil }
        return documents.first { $0.id == selectedDocumentID }
    }

    var currentPhase: WorkflowPhase {
        if pendingFile != nil && selectedDocument == nil {
            return .ready
        }
        return selectedDocument?.workflowPhase ?? .idle
    }

    var lastUpdated: Date? {
        selectedDocument?.lastUpdated
    }

    /// Processing 상태인지 여부 — Safe Lock 판단에 사용
    var isProcessing: Bool {
        currentPhase == .processing
    }

    // MARK: - Document Selection

    func selectDocument(_ document: SubtitleDocument?) {
        selectedDocumentID = document?.id
    }

    // MARK: - Idle/Ready 전이

    /// 파일이 선택되어 Ready 상태로 전환 (Document는 아직 생성하지 않음)
    /// Idle 상태의 Home에서 파일 드롭 또는 파일 선택 완료 시 호출
    func prepareReady(fileName: String) {
        workflowTask?.cancel()
        workflowTask = nil
        pendingFile = PendingFileInfo(fileName: fileName)
    }

    /// Ready → Idle 복귀 (파일 선택 해제)
    func clearPendingFile() {
        pendingFile = nil
    }

    // MARK: - Processing 시작 (Ready → Processing)

    /// "시작하기" 버튼 시점. Document 생성 + Processing 진입.
    func startProcessing() {
        guard let file = pendingFile else { return }
        workflowTask?.cancel()

        // 새 Document 생성 (시작 버튼을 누른 시점에만 생성)
        let newDoc = SubtitleDocument(
            title: file.fileName.replacingOccurrences(of: ".", with: "_"),
            workflowPhase: .processing,
            lastUpdated: Date(),
            inputFileName: file.fileName,
            settingsFPS: selectedFPS,
            settingsLanguage: selectedLanguage,
            settingsTemplate: selectedTemplate,
            settingsModel: selectedModel
        )

        documents.insert(newDoc, at: 0)
        selectedDocumentID = newDoc.id
        pendingFile = nil

        workflowTask = Task { [weak self] in
            await self?.runMockWorkflow(for: newDoc.id)
        }
    }

    // MARK: - Cancel (Processing → Cancelled)

    func cancelProcessing() {
        workflowTask?.cancel()
        workflowTask = nil
        currentProcessingStep = nil

        guard let id = selectedDocumentID else { return }

        updateDocument(id: id) { doc in
            doc.workflowPhase = .cancelled
            doc.currentlyProcessingID = nil
            doc.lastUpdated = Date()
        }
    }

    // MARK: - Restart (Cancelled → Processing, rerun)

    func restartProcessing() {
        guard let id = selectedDocumentID else { return }
        guard selectedDocument?.workflowPhase == .cancelled else { return }

        workflowTask?.cancel()

        updateDocument(id: id) { doc in
            doc.workflowPhase = .processing
            doc.segments = []
            doc.currentlyProcessingID = nil
            doc.lastUpdated = Date()
        }

        workflowTask = Task { [weak self] in
            await self?.runMockWorkflow(for: id)
        }
    }

    // MARK: - New Workflow (Terminal → Idle)

    /// 어떤 Terminal State에서든 새 작업으로 전환
    func startNewWorkflow() {
        workflowTask?.cancel()
        workflowTask = nil
        currentProcessingStep = nil
        selectedDocumentID = nil
        pendingFile = nil
    }

    // MARK: - Mock Workflow Engine

    private func runMockWorkflow(for documentID: SubtitleDocument.ID) async {
        // Mock subtitle data
        let mockSubtitles = [
            (0.0, 2.5, "안녕하세요, DizzyFlow 데모입니다."),
            (2.5, 5.0, "이 워크플로우는 전사 작업을 자동화합니다."),
            (5.0, 8.2, "파일을 드롭하고 시작 버튼을 누르면"),
            (8.2, 11.0, "오디오 분석부터 FCPXML 생성까지 자동으로 진행됩니다."),
            (11.0, 14.5, "실시간으로 자막이 생성되는 과정을 확인할 수 있습니다."),
            (14.5, 17.0, "Safe Lock으로 작업 중 안전하게 보호됩니다."),
            (17.0, 20.0, "처리가 완료되면 SRT와 FCPXML을 다운로드할 수 있습니다."),
            (20.0, 23.5, "Final Cut Pro 워크플로우에 바로 활용 가능합니다."),
            (23.5, 26.0, "DizzyFlow는 워크플로우 우선 자막 도구입니다."),
            (26.0, 29.0, "감사합니다.")
        ]

        // Step 1: Audio Analysis
        await advanceStep(.audioAnalysis, for: documentID)
        if Task.isCancelled { return }

        // Step 2: VAD Analysis
        await advanceStep(.vadAnalysis, for: documentID)
        if Task.isCancelled { return }

        // Step 3: Transcription — 세그먼트를 하나씩 누적 생성
        currentProcessingStep = .transcription
        for (index, subtitle) in mockSubtitles.enumerated() {
            guard !Task.isCancelled else { return }
            guard selectedDocumentID == documentID else { return }

            let segment = SubtitleSegment(
                index: index + 1,
                startTime: subtitle.0,
                endTime: subtitle.1,
                text: subtitle.2
            )

            updateDocument(id: documentID) { doc in
                doc.currentlyProcessingID = segment.id
                doc.segments.append(segment)
                doc.lastUpdated = Date()
            }

            do {
                try await Task.sleep(nanoseconds: mockStepDurationNanoseconds / 3)
            } catch {
                return
            }
        }

        // 전사 완료 — 하이라이트 해제
        updateDocument(id: documentID) { doc in
            doc.currentlyProcessingID = nil
        }

        if Task.isCancelled { return }

        // Step 4: SRT Generation
        await advanceStep(.srtGeneration, for: documentID)
        if Task.isCancelled { return }

        // Step 5: FCPXML Generation
        await advanceStep(.fcpxmlGeneration, for: documentID)
        if Task.isCancelled { return }

        // 완료
        guard selectedDocumentID == documentID else { return }

        currentProcessingStep = nil
        updateDocument(id: documentID) { doc in
            doc.workflowPhase = .completed
            doc.lastUpdated = Date()
        }

        workflowTask = nil
    }

    /// Processing 세부 단계 하나를 시뮬레이트
    private func advanceStep(
        _ step: ProcessingStep,
        for documentID: SubtitleDocument.ID
    ) async {
        guard !Task.isCancelled, selectedDocumentID == documentID else { return }

        currentProcessingStep = step

        do {
            try await Task.sleep(nanoseconds: mockStepDurationNanoseconds)
        } catch {
            return
        }
    }

    // MARK: - Document Mutation

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
