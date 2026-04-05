import SwiftUI
import UniformTypeIdentifiers

/// Home Workspace — Idle/Ready 상태의 메인 작업 영역.
///
/// - Idle: 파일 드롭/선택 유도 (중앙) + 하단 설정 + 파일 업로드 버튼
/// - Ready: Mock 썸네일 + 파일 메타 확인 (중앙) + 하단 설정 + 시작하기 버튼
///
/// 상세 메타 정보(포맷, 코덱 등)는 Inspector에서 표시.
/// 중앙 Workspace에서는 "확신감"을 위한 시각 요소만 배치.
struct HomeWorkspaceView: View {
    @ObservedObject var store: WorkflowStore
    @State private var isTargeted = false

    var body: some View {
        VStack(spacing: 0) {
            // 메인 콘텐츠 (중앙 영역)
            if store.pendingFile != nil {
                readyContent
            } else {
                idleContent
            }

            // 하단 2층 구조
            bottomControlArea
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Idle Content (중앙)

    private var idleContent: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 6) {
                Image(systemName: "waveform.and.mic")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)

                Text("DizzyFlow")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Workflow-first subtitle tool")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            // 파일 드롭 영역
            dropZone

            Text("미디어 파일을 드래그하거나 선택하여 자막 워크플로우를 시작하세요.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 360)

            Spacer()
        }
        .padding(40)
    }

    // MARK: - Ready Content (중앙)

    private var readyContent: some View {
        VStack(spacing: 16) {
            Spacer()

            if let file = store.pendingFile {
                // 파일 확인 카드 (썸네일 + 메타 요약) — 메인 컬러 테두리
                fileConfirmationCard(file: file)

                // 설정 요약 카드 — 동일 너비
                settingsSummaryCard
            }

            Spacer()
        }
        .padding(.horizontal, 60)
        .padding(.vertical, 40)
    }

    // MARK: - 하단 2층 구조

    private var bottomControlArea: some View {
        BottomControlStack {
            // 1층: 설정 피커 (Idle/Ready 공용)
            settingsRow
        } actionContent: {
            // 2층: 액션 버튼
            HStack(spacing: 12) {
                if store.pendingFile != nil {
                    // Ready 상태: 시작하기 + 다른 파일
                    CapsuleActionButton(
                        title: "시작하기",
                        icon: "play.fill",
                        isPrimary: true
                    ) {
                        store.startProcessing()
                    }

                    CapsuleActionButton(
                        title: "다른 파일 선택",
                        icon: "arrow.triangle.2.circlepath"
                    ) {
                        store.clearPendingFile()
                    }
                } else {
                    // Idle 상태: 파일 업로드
                    CapsuleActionButton(
                        title: "미디어 파일 선택",
                        icon: "folder.badge.plus",
                        isPrimary: true
                    ) {
                        simulateFileSelection()
                    }
                }

                Spacer()
            }
        }
    }

    // MARK: - 1층 설정 행

    private var settingsRow: some View {
        HStack(spacing: 16) {
            settingPicker(
                title: "FPS",
                selection: $store.selectedFPS,
                options: ["23.976", "24", "25", "29.97", "30", "60"]
            )

            settingPicker(
                title: "언어",
                selection: $store.selectedLanguage,
                options: ["Korean", "English", "Japanese", "Chinese", "Auto"]
            )

            settingPicker(
                title: "FCP 템플릿",
                selection: $store.selectedTemplate,
                options: ["Default", "Basic Title", "Custom Lower Third"]
            )

            settingPicker(
                title: "전사 모델",
                selection: $store.selectedModel,
                options: ["Sherpa-onnx", "WhisperKit"]
            )

            Spacer()
        }
    }

    private func settingPicker(
        title: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {
        UpwardMenuPicker(
            title: title,
            selection: selection,
            options: options
        )
        .fixedSize()
    }

    // MARK: - File Confirmation Card

    private func fileConfirmationCard(file: PendingFileInfo) -> some View {
        HStack(spacing: 16) {
            // Mock 썸네일 영역
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(.controlBackgroundColor),
                                Color(.controlBackgroundColor).opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 80)

                Image(systemName: file.systemIcon)
                    .font(.system(size: 32))
                    .foregroundStyle(Color.accentColor.opacity(0.8))
            }

            // 파일 정보
            VStack(alignment: .leading, spacing: 6) {
                Text(file.fileName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                HStack(spacing: 12) {
                    metaBadge(icon: "clock", text: file.displayDuration)
                    metaBadge(icon: "internaldrive", text: file.displaySize)
                }

                Text(file.displayFormat)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.accentColor.opacity(0.5), lineWidth: 1.5)
        )
    }

    private func metaBadge(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Settings Summary Card

    private var settingsSummaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("적용 설정")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            settingSummaryRow(label: "FPS", value: store.selectedFPS)
            settingSummaryRow(label: "언어", value: store.selectedLanguage)
            settingSummaryRow(label: "FCP 템플릿", value: store.selectedTemplate)
            settingSummaryRow(label: "전사 모델", value: store.selectedModel)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.03))
        )
    }

    // MARK: - Drop Zone

    private var dropZone: some View {
        RoundedRectangle(cornerRadius: 16)
            .strokeBorder(
                style: StrokeStyle(lineWidth: 2, dash: [8])
            )
            .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 160)
            .foregroundStyle(isTargeted ? Color.accentColor : Color.secondary)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isTargeted
                          ? Color.accentColor.opacity(0.05)
                          : Color.clear)
            )
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "arrow.down.doc")
                        .font(.title)
                        .foregroundStyle(isTargeted ? Color.accentColor : Color.secondary)

                    Text("여기에 미디어 파일을 드래그하세요")
                        .font(.headline)
                        .foregroundStyle(isTargeted ? .primary : .secondary)
                }
            )
            .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
                handleDrop(providers: providers)
                return true
            }
    }

    // MARK: - Helpers

    private func settingSummaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .trailing)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }

    private func handleDrop(providers: [NSItemProvider]) {
        guard let provider = providers.first else { return }
        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            DispatchQueue.main.async {
                store.prepareReady(fileName: url.lastPathComponent)
            }
        }
    }

    private func simulateFileSelection() {
        store.prepareReady(fileName: "Interview_2026_04.mov")
    }
}

#Preview {
    HomeWorkspaceView(store: WorkflowStore())
}
