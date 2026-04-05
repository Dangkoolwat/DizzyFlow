import SwiftUI
import Foundation

// MARK: - Settings Categories

/// 설정 카테고리 내부 전환을 위한 열거형 (사용자 피드백 반영)
enum SettingsCategory: String, CaseIterable, Identifiable {
    case general = "General"
    case vad = "VAD"
    case models = "Model"
    case license = "License"
    case about = "About"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .general: return "gearshape"
        case .vad: return "waveform"
        case .models: return "cpu"
        case .license: return "doc.text"
        case .about: return "info.circle"
        }
    }
}

// MARK: - Settings Workspace View

/// 2단 레이아웃(Master-Detail) 설정 워크스페이스 뷰
struct SettingsWorkspaceView: View {
    @ObservedObject var store: WorkflowStore
    @State private var selectedCategory: SettingsCategory = .general

    var body: some View {
        HStack(spacing: 0) {
            // --- 좌측: 카테고리 리스트 (Master) ---
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 2) {
                        ForEach(SettingsCategory.allCases) { category in
                            categoryRow(for: category)
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
            .frame(width: 200)
            .background(Color.black.opacity(0.02)) // 미세한 구분감

            Divider()

            // --- 우측: 상세 설정 (Detail) ---
            ZStack {
                Color(nsColor: .windowBackgroundColor) // 기본 배경색 (macOS 15 호환성)

                Group {
                    switch selectedCategory {
                    case .general:
                        GeneralSettingsView(store: store)
                    case .vad:
                        VADSettingsView(store: store)
                    case .models:
                        ModelsSettingsView(store: store)
                    case .license:
                        LicenseSettingsView(store: store)
                    case .about:
                        AboutSettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private func categoryRow(for category: SettingsCategory) -> some View {
        Button {
            selectedCategory = category
        } label: {
            HStack(spacing: 10) {
                Image(systemName: category.icon)
                    .font(.body)
                    .frame(width: 20)

                Text(category.rawValue)
                    .font(.body)

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(selectedCategory == category ? Color.accentColor : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(selectedCategory == category ? .white : .primary)
    }
}

// MARK: - Detail Views (Merged)

struct GeneralSettingsView: View {
    @ObservedObject var store: WorkflowStore
    @State private var localLanguage: String = ""
    @State private var removeSymbol: Bool = false
    @State private var downloadPath: String = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    detailHeader(title: "General Settings", subtitle: "앱 전반의 기본 설정을 관리합니다.")

                    SettingsSectionView(title: "프로그램 언어 설정") {
                        HStack {
                            Picker("언어 선택", selection: $localLanguage) {
                                Text("Korean").tag("Korean")
                                Text("English").tag("English")
                            }
                            .pickerStyle(.menu)
                            .frame(width: 140) // 너비 단축
                            
                            Spacer()
                        }
                    }

                    SettingsSectionView(title: "문서 편집 설정") {
                        Toggle("Remove Symbol", isOn: $removeSymbol)
                            .help("자동생성된 문서에서 특정 기호를 삭제합니다.")
                    }

                    SettingsSectionView(title: "Model Download Location") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(downloadPath)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                Spacer()
                                Button("변경...") {
                                    // 경로 변경 로직 (Mock)
                                }
                            }
                            Text("모델을 전체 옮기겠습니까? 확인 후 전체 이동이 진행됩니다.")
                                .font(.system(size: 10))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .padding(32)
            }

            detailSaveFooter {
                store.globalSettings.language = localLanguage
                store.globalSettings.removeSymbolEnabled = removeSymbol
                store.globalSettings.modelDownloadLocation = downloadPath
            }
        }
        .onAppear {
            localLanguage = store.globalSettings.language
            removeSymbol = store.globalSettings.removeSymbolEnabled
            downloadPath = store.globalSettings.modelDownloadLocation
        }
    }
}

struct VADSettingsView: View {
    @ObservedObject var store: WorkflowStore
    @State private var threshold: Double = 0.5
    @State private var aggressiveness: Int = 2

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    detailHeader(title: "VAD Settings", subtitle: "보이스 활동 감지(Voice Activity Detection)의 정밀도를 조절합니다.")

                    SettingsSectionView(title: "감지 임계값 (Threshold)") {
                        VStack(alignment: .leading) {
                            Slider(value: $threshold, in: 0...1)
                            Text("현재 값: \(threshold, specifier: "%.2f")")
                                .font(.caption)
                                .monospacedDigit()
                        }
                    }

                    SettingsSectionView(title: "공격성 (Aggressiveness)") {
                        Picker("단계 선택", selection: $aggressiveness) {
                            Text("낮음 (0)").tag(0)
                            Text("보통 (1)").tag(1)
                            Text("높음 (2)").tag(2)
                            Text("매우 높음 (3)").tag(3)
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding(32)
            }

            detailSaveFooter {
                store.globalSettings.vadThreshold = threshold
                store.globalSettings.vadAggressiveness = aggressiveness
            }
        }
        .onAppear {
            threshold = store.globalSettings.vadThreshold
            aggressiveness = store.globalSettings.vadAggressiveness
        }
    }
}

// MARK: - Models Mock Data Struct
struct ModelItem: Identifiable {
    let id = UUID()
    let name: String
    let isDownloaded: Bool
    let description: String
}

struct ModelsSettingsView: View {
    @ObservedObject var store: WorkflowStore
    
    // Mock Data
    let sherpaModels = [
        ModelItem(name: "Sherpa-Onnx-Model-Standard-v1.0", isDownloaded: true, description: "이 모델은 인텔 맥 환경의 고정밀 전사에 특화되어 있습니다."),
        ModelItem(name: "Sherpa-Onnx-Tiny-Fast", isDownloaded: false, description: "경량화된 엔진으로 실시간 스트리밍 답변에 적합합니다."),
        ModelItem(name: "Sherpa-Multilingual-Exp", isDownloaded: false, description: "다국어 혼합 인식 성능을 테스트하기 위한 실험적 모델입니다.")
    ]
    
    let whisperModels = [
        ModelItem(name: "Whisper-Large-v3-Turbo", isDownloaded: true, description: "Apple Silicon Neural Engine을 100% 활용하는 초고속 모델입니다."),
        ModelItem(name: "Whisper-Medium-Base", isDownloaded: true, description: "안정적인 하위 호환성을 제공하는 표준 모델입니다."),
        ModelItem(name: "Whisper-Distilled-Tiny", isDownloaded: false, description: "최소한의 메모리 점유율로 저사양 기기에서 구동 가능한 모델입니다.")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    detailHeader(title: "Model Settings", subtitle: "각 서비스별 모델 정보와 리소스를 관리합니다.")

                    modelServiceSection(title: "Sherpa-onnx", models: sherpaModels)
                    
                    modelServiceSection(title: "WhisperKit", models: whisperModels)
                }
                .padding(32)
            }
            
            detailSaveFooter {
                // 전역 상태 저장 로직
            }
        }
    }

    private func modelServiceSection(title: String, models: [ModelItem]) -> some View {
        SettingsSectionView(title: title) {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(models) { model in
                        modelRow2Line(model: model)
                        if model.id != models.last?.id {
                            Divider().padding(.vertical, 4)
                        }
                    }
                }
                .padding(.trailing, 8) // 스크롤바와 텍스트 간격 확보
            }
            .frame(maxHeight: 240) // 리스트 영역 최대 높이 설정 (스크롤 활성화)
        }
    }

    /// 모델 행: 2단 구성 (사용자 피드백 반영)
    private func modelRow2Line(model: ModelItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // 1단: 이름 (왼쪽) --- 아이콘들 (오른쪽)
            HStack {
                Text(model.name)
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                HStack(spacing: 10) {
                    // 다운로드 아이콘
                    Image(systemName: "arrow.down.circle")
                        .font(.title3)
                        .foregroundStyle(model.isDownloaded ? Color.gray.opacity(0.3) : Color.accentColor)
                        .onTapGesture {
                            // 다운로드 시작 시뮬레이션
                        }
                    
                    // 휴지통 아이콘
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundStyle(model.isDownloaded ? Color.red : Color.gray.opacity(0.3))
                        .onTapGesture {
                            // 제거 시뮬레이션
                        }
                }
            }
            
            // 2단: 설명 및 진행률 영역 (Mock 진행바 포함 가능)
            VStack(alignment: .leading, spacing: 4) {
                Text(model.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                if !model.isDownloaded {
                    // 다운로드 중인 경우를 가정한 UI 영역 (메시지 및 프로그레스)
                    HStack(spacing: 8) {
                        ProgressView(value: 0.4) // Mock 진행률
                            .controlSize(.small)
                            .frame(width: 100)
                        
                        Text("40% - 대기 중...")
                            .font(.system(size: 9))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.top, 2)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct LicenseSettingsView: View {
    @ObservedObject var store: WorkflowStore
    @State private var licenseText: String = "라이선스 파일을 불러오는 중..."
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    detailHeader(title: "License Information", subtitle: "제품에 사용된 외부 모듈 및 라이브러리에 대한 라이선스 안내입니다.")
                    
                    Spacer(minLength: 20)
                    
                    // 창 너비 확장을 막기 위해 maxWidth를 부모 전체 너비에 맞추고 
                    // 내부 박스 너비는 적절한 비율로 고정
                    HStack {
                        Spacer()
                        VStack(alignment: .leading) {
                            ScrollView {
                                Text(licenseText)
                                    .font(.system(.body, design: .monospaced))
                                    .padding(24)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(maxWidth: 600) // 최대 너비 제한 (창 늘어짐 방지)
                        .frame(height: 420)
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                        Spacer()
                    }
                    .frame(maxWidth: .infinity) // 부모 내에서 좌우 여백 확보
                    
                    Spacer(minLength: 40)
                }
                .padding(32)
                .frame(maxWidth: .infinity) // 컨텐츠가 부모를 뚫고 나가지 않도록
            }
        }
        .onAppear {
            loadLicenseFile()
        }
    }
    
    private func loadLicenseFile() {
        let path = "/Users/sanghyoukjin/XcodeProjects/DizzyFlow/DizzyFlow/Resources/license.txt"
        if let content = try? String(contentsOfFile: path, encoding: .utf8) {
            licenseText = content
        } else {
            licenseText = "라이선스 파일(license.txt)을 찾을 수 없습니다."
        }
    }
}

struct AboutSettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 32) {
                Spacer(minLength: 40)

                Image(systemName: "app.dashed")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue.gradient)

                VStack(spacing: 8) {
                    Text("DizzyFlow")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("v1.5.0 (Prototype)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text("DizzyFlow는 워크플로우 중심의 자막 제작 환경을 제공하는 macOS 전용 플랫폼입니다.\n연락처: contact@daangcool.com")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Divider()

                VStack(spacing: 4) {
                    Text("© 2026 Sanghyouk Jin")
                    Text("Powered by Google Gemini & Apple SwiftUI")
                }
                .font(.caption)
                .foregroundStyle(.tertiary)

                Spacer()
            }
            .padding(32)
        }
    }
}

// MARK: - Layout Helpers

private func detailHeader(title: String, subtitle: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
        Text(subtitle)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}

private struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: () -> Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            content()
                .padding(12)
                .background(Color.black.opacity(0.03))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

private func detailSaveFooter(action: @escaping () -> Void) -> some View {
    VStack(spacing: 0) {
        Divider()
        HStack {
            Spacer()
            CapsuleActionButton(title: "Save Settings", icon: "checkmark.circle.fill", isPrimary: true) {
                action()
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    SettingsWorkspaceView(store: WorkflowStore())
}
