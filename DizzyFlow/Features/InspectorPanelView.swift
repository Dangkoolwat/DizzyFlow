import SwiftUI

/// Inspector 패널 — 현재 선택에 따라 컨텍스트 정보와 Tips를 표시.
///
/// - Home: 일반 팁 + 설정 안내
/// - Document: workflowPhase별 상세 정보
///   - Idle/Ready: 설정 설명 + 파일 메타
///   - Processing: 읽기 전용 진행 정보 (단계 리스트, 진행률, 파일/설정)
///   - Completed: 완료 메타 + 결과물 정보
///   - Failed: 오류 디버깅 보조 정보
///   - Cancelled: 취소 정보
/// - Settings: 카테고리별 Tips!
struct InspectorPanelView: View {
    let destination: SidebarDestination
    @ObservedObject var store: WorkflowStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Inspector")
                    .font(.headline)

                Divider()

                inspectorContent

                Spacer()
            }
            .padding(16)
        }
    }

    // MARK: - Content Routing

    @ViewBuilder
    private var inspectorContent: some View {
        switch destination {
        case .home:
            homeInspector

        case .document:
            if let document = store.selectedDocument {
                documentInspector(for: document)
            } else {
                noContextView
            }

        case .settings:
            settingsInspector
        }
    }

    // MARK: - Home Inspector

    private var homeInspector: some View {
        VStack(alignment: .leading, spacing: 16) {
            infoRow(title: "화면", value: "Home")
            infoRow(title: "상태", value: store.pendingFile != nil ? "Ready" : "Idle")

            // Ready 상태: 파일 메타 정보 상세
            if let file = store.pendingFile {
                Divider()

                Text("파일 정보")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                infoRow(title: "파일명", value: file.fileName)
                infoRow(title: "크기", value: file.displaySize)
                infoRow(title: "재생 시간", value: file.displayDuration)
                infoRow(title: "포맷", value: file.displayFormat)
                infoRow(title: "코덱", value: file.displayCodec)

                Divider()

                Text("적용 설정")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                infoRow(title: "FPS", value: store.selectedFPS)
                infoRow(title: "언어", value: store.selectedLanguage)
                infoRow(title: "FCP 템플릿", value: store.selectedTemplate)
                infoRow(title: "전사 모델", value: store.selectedModel)

                tipCard("✅ Tips!", message: "파일과 설정을 확인한 후 '시작하기'를 누르세요. 설정은 상단 바에서 변경 가능합니다.")
            } else {
                // Idle 상태: 일반 안내
                tipCard("💡 Tips!", message: "미디어 파일을 드래그하거나 선택하여 워크플로우를 시작하세요.")
                tipCard("⚙️ Tips!", message: "상단 설정 바에서 FPS, 언어, 템플릿, 모델을 미리 조정할 수 있습니다.")
                tipCard("📋 Tips!", message: "마지막 사용 설정이 자동으로 기억됩니다.")
            }
        }
    }

    // MARK: - Document Inspector (Phase별)

    @ViewBuilder
    private func documentInspector(for document: SubtitleDocument) -> some View {
        // 공통 정보
        VStack(alignment: .leading, spacing: 12) {
            infoRow(title: "문서", value: document.title)
            infoRow(title: "상태", value: document.workflowPhase.rawValue.capitalized)
            infoRow(
                title: "생성",
                value: document.createdAt.formatted(date: .abbreviated, time: .shortened)
            )
            if let updated = document.lastUpdated {
                infoRow(
                    title: "마지막 업데이트",
                    value: updated.formatted(date: .abbreviated, time: .shortened)
                )
            }
        }

        Divider()

        // Phase별 상세
        switch document.workflowPhase {
        case .idle, .ready:
            idleReadyInspector(for: document)

        case .processing:
            processingInspector(for: document)

        case .completed:
            completedInspector(for: document)

        case .failed:
            failedInspector(for: document)

        case .cancelled:
            cancelledInspector(for: document)
        }
    }

    // MARK: Idle / Ready

    private func idleReadyInspector(for document: SubtitleDocument) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let fileName = document.inputFileName {
                infoRow(title: "파일", value: fileName)
            }

            // 설정 스냅샷
            if let fps = document.settingsFPS {
                infoRow(title: "FPS", value: fps)
            }
            if let lang = document.settingsLanguage {
                infoRow(title: "언어", value: lang)
            }
            if let tmpl = document.settingsTemplate {
                infoRow(title: "FCP 템플릿", value: tmpl)
            }
            if let model = document.settingsModel {
                infoRow(title: "전사 모델", value: model)
            }

            tipCard("💡 Tips!", message: "설정은 시작 전까지 언제든 수정할 수 있습니다.")
        }
    }

    // MARK: Processing

    private func processingInspector(for document: SubtitleDocument) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 단계 리스트
            Text("진행 단계")
                .font(.subheadline)
                .fontWeight(.semibold)

            ForEach(ProcessingStep.allCases, id: \.self) { step in
                HStack(spacing: 8) {
                    stepStatusIcon(step: step)

                    Text(step.rawValue.replacingOccurrences(of: "...", with: ""))
                        .font(.caption)
                        .foregroundStyle(
                            step == store.currentProcessingStep ? .primary : .secondary
                        )
                }
            }

            Divider()

            // 전체 진행률
            if let step = store.currentProcessingStep {
                infoRow(title: "전체 진행률", value: "\(Int(step.progress * 100))%")
            }

            // 파일 정보
            if let fileName = document.inputFileName {
                infoRow(title: "입력 파일", value: fileName)
            }

            // 적용 설정
            if let fps = document.settingsFPS {
                infoRow(title: "FPS", value: fps)
            }
            if let model = document.settingsModel {
                infoRow(title: "모델", value: model)
            }

            // 세그먼트 수
            infoRow(title: "생성된 세그먼트", value: "\(document.segments.count)")

            tipCard("🔒 Tips!", message: "작업 중에는 Safe Lock이 적용되어 설정 변경과 다른 문서 전환이 차단됩니다.")
            tipCard("❌ Tips!", message: "작업을 중단하려면 '작업 취소' 버튼을 사용하세요.")
        }
    }

    // MARK: Completed

    private func completedInspector(for document: SubtitleDocument) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(title: "결과", value: "성공")
            infoRow(title: "세그먼트 수", value: "\(document.segments.count)")

            if let fileName = document.inputFileName {
                infoRow(title: "입력 파일", value: fileName)
            }
            if let fps = document.settingsFPS {
                infoRow(title: "FPS", value: fps)
            }
            if let lang = document.settingsLanguage {
                infoRow(title: "언어", value: lang)
            }
            if let model = document.settingsModel {
                infoRow(title: "모델", value: model)
            }

            tipCard("📥 Tips!", message: "FCPXML을 먼저 다운로드하여 Final Cut Pro에서 바로 활용하세요.")
            tipCard("📄 Tips!", message: "SRT 파일도 함께 다운로드하여 범용 자막으로 사용할 수 있습니다.")
        }
    }

    // MARK: Failed

    private func failedInspector(for document: SubtitleDocument) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(title: "결과", value: "실패")

            if let step = document.failedStep {
                infoRow(title: "실패 단계", value: step)
            }
            if let message = document.failureMessage {
                infoRow(title: "오류 메시지", value: message)
            }
            if let fileName = document.inputFileName {
                infoRow(title: "입력 파일", value: fileName)
            }

            tipCard("⚠️ Tips!", message: "새 작업을 시작하여 다른 파일이나 설정으로 다시 시도해 보세요.")
        }
    }

    // MARK: Cancelled

    private func cancelledInspector(for document: SubtitleDocument) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(title: "결과", value: "사용자 취소")
            infoRow(title: "취소 시점 세그먼트", value: "\(document.segments.count)")

            if let fileName = document.inputFileName {
                infoRow(title: "입력 파일", value: fileName)
            }

            tipCard("🔄 Tips!", message: "'다시 시작' 버튼으로 같은 설정으로 처음부터 재실행할 수 있습니다.")
        }
    }

    // MARK: - Settings Inspector

    private var settingsInspector: some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(title: "화면", value: "Settings")

            tipCard("⚙️ Tips!", message: "설정 변경 후 저장 버튼을 눌러야 반영됩니다.")
            tipCard("📦 Tips!", message: "모델 관리는 카드 단위로 다운로드/삭제할 수 있습니다.")
        }
    }

    // MARK: - No Context

    private var noContextView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("컨텍스트 없음")
                .font(.subheadline)
                .fontWeight(.semibold)

            Text("문서를 선택하면 상태 정보가 표시됩니다.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Reusable Components

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
        }
    }

    private func tipCard(_ title: String, message: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.accentColor)

            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.06))
        )
    }

    /// Processing 진행 단계 아이콘
    private func stepStatusIcon(step: ProcessingStep) -> some View {
        Group {
            if let currentStep = store.currentProcessingStep {
                let allSteps = ProcessingStep.allCases
                let currentIndex = allSteps.firstIndex(of: currentStep) ?? 0
                let stepIndex = allSteps.firstIndex(of: step) ?? 0

                if stepIndex < currentIndex {
                    // 완료
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                } else if stepIndex == currentIndex {
                    // 진행 중
                    ProgressView()
                        .controlSize(.mini)
                } else {
                    // 대기
                    Image(systemName: "circle")
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                }
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(.tertiary)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    InspectorPanelView(destination: .home, store: WorkflowStore())
}
