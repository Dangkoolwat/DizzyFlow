import SwiftUI

/// Inspector 패널 — 현재 선택에 따라 컨텍스트 정보와 Tips를 카드 형태로 표시.
///
/// - Home: 일반 팁 + 설정 안내
/// - Document: workflowPhase별 상세 정보
/// - Settings: 카테고리별 Tips
///
/// 모든 정보는 의미 단위로 그룹화된 라운딩 카드로 출력한다.
struct InspectorPanelView: View {
    let destination: SidebarDestination
    @ObservedObject var store: WorkflowStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                inspectorContent
            }
            .padding(12)
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
        VStack(alignment: .leading, spacing: 12) {
            // Ready 상태: 파일 + 설정 상세
            if let file = store.pendingFile {
                inspectorCard(title: "화면 정보") {
                    infoRow(title: "화면", value: "Home")
                    infoRow(title: "상태", value: "Ready")
                }

                inspectorCard(title: "파일 정보") {
                    infoRow(title: "파일명", value: file.fileName)
                    infoRow(title: "크기", value: file.displaySize)
                    infoRow(title: "재생 시간", value: file.displayDuration)
                    infoRow(title: "포맷", value: file.displayFormat)
                    infoRow(title: "코덱", value: file.displayCodec)
                }

                inspectorCard(title: "적용 설정") {
                    infoRow(title: "FPS", value: store.selectedFPS)
                    infoRow(title: "언어", value: store.selectedLanguage)
                    infoRow(title: "FCP 템플릿", value: store.selectedTemplate)
                    infoRow(title: "전사 모델", value: store.selectedModel)
                }

                tipCard("✅ Tips!", message: "파일과 설정을 확인한 후 '시작하기'를 누르세요.")
            } else {
                // Idle 상태
                inspectorCard(title: "화면 정보") {
                    infoRow(title: "화면", value: "Home")
                    infoRow(title: "상태", value: "Idle")
                }

                tipCard("💡 Tips!", message: "미디어 파일을 드래그하거나 선택하여 워크플로우를 시작하세요.")
                tipCard("⚙️ Tips!", message: "하단 설정 바에서 FPS, 언어, 템플릿, 모델을 미리 조정할 수 있습니다.")
                tipCard("📋 Tips!", message: "마지막 사용 설정이 자동으로 기억됩니다.")
            }
        }
    }

    // MARK: - Document Inspector (Phase별)

    @ViewBuilder
    private func documentInspector(for document: SubtitleDocument) -> some View {
        // ── 공통: 문서 정보 카드 ──
        inspectorCard(title: "문서 정보") {
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

        // ── Phase별 상세 카드 ──
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

    @ViewBuilder
    private func idleReadyInspector(for document: SubtitleDocument) -> some View {
        if document.inputFileName != nil ||
            document.settingsFPS != nil {
            inspectorCard(title: "작업 설정") {
                if let fileName = document.inputFileName {
                    infoRow(title: "파일", value: fileName)
                }
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
            }
        }

        tipCard("💡 Tips!", message: "설정은 시작 전까지 언제든 수정할 수 있습니다.")
    }

    // MARK: Processing

    @ViewBuilder
    private func processingInspector(for document: SubtitleDocument) -> some View {
        inspectorCard(title: "진행 단계") {
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

            if let step = store.currentProcessingStep {
                Divider()
                infoRow(title: "전체 진행률", value: "\(Int(step.progress * 100))%")
            }
        }

        inspectorCard(title: "작업 정보") {
            if let fileName = document.inputFileName {
                infoRow(title: "입력 파일", value: fileName)
            }
            if let fps = document.settingsFPS {
                infoRow(title: "FPS", value: fps)
            }
            if let model = document.settingsModel {
                infoRow(title: "모델", value: model)
            }
            infoRow(title: "생성된 세그먼트", value: "\(document.segments.count)")
        }

        tipCard("🔒 Tips!", message: "작업 중에는 Safe Lock이 적용되어 설정 변경과 다른 문서 전환이 차단됩니다.")
        tipCard("❌ Tips!", message: "작업을 중단하려면 '작업 취소' 버튼을 사용하세요.")
    }

    // MARK: Completed

    @ViewBuilder
    private func completedInspector(for document: SubtitleDocument) -> some View {
        inspectorCard(title: "결과") {
            infoRow(title: "결과", value: "성공")
            infoRow(title: "세그먼트 수", value: "\(document.segments.count)")
            if let fileName = document.inputFileName {
                infoRow(title: "입력 파일", value: fileName)
            }
        }

        inspectorCard(title: "적용 설정") {
            if let fps = document.settingsFPS {
                infoRow(title: "FPS", value: fps)
            }
            if let lang = document.settingsLanguage {
                infoRow(title: "언어", value: lang)
            }
            if let model = document.settingsModel {
                infoRow(title: "모델", value: model)
            }
        }

        tipCard("📥 Tips!", message: "FCPXML을 먼저 다운로드하여 Final Cut Pro에서 바로 활용하세요.")
        tipCard("📄 Tips!", message: "SRT 파일도 함께 다운로드하여 범용 자막으로 사용할 수 있습니다.")
    }

    // MARK: Failed

    @ViewBuilder
    private func failedInspector(for document: SubtitleDocument) -> some View {
        inspectorCard(title: "오류 정보") {
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
        }

        tipCard("⚠️ Tips!", message: "새 작업을 시작하여 다른 파일이나 설정으로 다시 시도해 보세요.")
    }

    // MARK: Cancelled

    @ViewBuilder
    private func cancelledInspector(for document: SubtitleDocument) -> some View {
        inspectorCard(title: "취소 정보") {
            infoRow(title: "결과", value: "사용자 취소")
            infoRow(title: "취소 시점 세그먼트", value: "\(document.segments.count)")
            if let fileName = document.inputFileName {
                infoRow(title: "입력 파일", value: fileName)
            }
        }

        tipCard("🔄 Tips!", message: "'다시 시작' 버튼으로 같은 설정으로 처음부터 재실행할 수 있습니다.")
    }

    // MARK: - Settings Inspector

    private var settingsInspector: some View {
        VStack(alignment: .leading, spacing: 12) {
            inspectorCard(title: "화면 정보") {
                infoRow(title: "화면", value: "Settings")
            }

            tipCard("⚙️ Tips!", message: "설정 변경 후 저장 버튼을 눌러야 반영됩니다.")
            tipCard("📦 Tips!", message: "모델 관리는 카드 단위로 다운로드/삭제할 수 있습니다.")
        }
    }

    // MARK: - No Context

    private var noContextView: some View {
        inspectorCard(title: "컨텍스트 없음") {
            Text("문서를 선택하면 상태 정보가 표시됩니다.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Reusable Components

    /// 의미 단위 정보 그룹 카드 — 라운딩 사각형 배경
    private func inspectorCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            content()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.03))
        )
    }

    /// 개별 정보 행
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.tertiary)

            Text(value)
                .font(.callout)
        }
    }

    /// 팁 카드
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
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                } else if stepIndex == currentIndex {
                    ProgressView()
                        .controlSize(.mini)
                } else {
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
