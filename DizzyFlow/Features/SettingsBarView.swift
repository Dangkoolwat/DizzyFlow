import SwiftUI

/// 상단 설정 바 — Idle/Ready 단계에서 표시. Processing 이후에는 메시지 영역으로 전환.
struct SettingsBarView: View {
    @ObservedObject var store: WorkflowStore

    var body: some View {
        Group {
            if store.isProcessing {
                processingMessageBar
            } else if store.currentPhase == .completed {
                statusMessageBar(
                    icon: "checkmark.circle.fill",
                    message: "작업 완료",
                    color: .green
                )
            } else if store.currentPhase == .failed {
                statusMessageBar(
                    icon: "exclamationmark.triangle.fill",
                    message: "작업 실패",
                    color: .red
                )
            } else if store.currentPhase == .cancelled {
                statusMessageBar(
                    icon: "xmark.circle.fill",
                    message: "사용자 취소",
                    color: .orange
                )
            } else {
                settingsEditBar
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    // MARK: - Settings Edit Bar (Idle / Ready)

    private var settingsEditBar: some View {
        HStack(spacing: 20) {
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
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)

            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .fixedSize()
        }
    }

    // MARK: - Processing Message Bar

    private var processingMessageBar: some View {
        HStack(spacing: 12) {
            ProgressView()
                .controlSize(.small)

            Text(store.currentProcessingStep?.rawValue ?? "처리 준비 중...")
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()

            if let step = store.currentProcessingStep {
                Text("\(Int(step.progress * 100))%")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
    }

    // MARK: - Status Message Bar (Terminal States)

    private func statusMessageBar(
        icon: String,
        message: String,
        color: Color
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(color)

            Text(message)
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()
        }
    }
}

#Preview("Idle") {
    SettingsBarView(store: WorkflowStore())
}
