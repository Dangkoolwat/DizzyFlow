# Walkthrough

## 변경 사항 요약

### 신규 파일
- `BottomControlStack.swift`: Generic 하단 2층 컨테이너 (`.ultraThinMaterial` 배경, 상단 `Divider` 경계선)
- `CapsuleActionButton.swift`: Primary/Destructive 분기형 캡슐 액션 버튼

### 수정 파일

| 파일 | 변경 내용 |
|---|---|
| `SettingsBarView.swift` | 설정/메시지 로직 전부 제거 → `EmptyView()` |
| `ContentView.swift` | 툴바에서 SettingsBarView 제거 (Inspector 토글만 유지) |
| `DocumentsWorkspaceView.swift` | SettingsBarView 참조 및 Divider 제거 |
| `HomeWorkspaceView.swift` | 하단 2층: 1층 설정 피커 + 2층 파일 업로드/시작하기 |
| `ProcessingWorkspaceView.swift` | 하단 2층: 1층 진행 메시지 + 2층 작업 취소 |
| `CompletedWorkspaceView.swift` | 하단 2층: 1층 완료 메시지 + 2층 FCPXML/SRT/새 작업 |
| `FailedWorkspaceView.swift` | 하단 2층: 1층 실패 단계/원인 + 2층 새 작업 |
| `CancelledWorkspaceView.swift` | 하단 2층: 1층 취소 안내/중단 시점 + 2층 다시 시작/새 작업 |

### Tahoe 시각적 구분감 체크
- ✅ SRT 미리보기 영역: `Color(NSColor.textBackgroundColor).opacity(0.6)` 배경 적용
- ✅ 하단 전체: `.background(.ultraThinMaterial)` + `.overlay(alignment: .top) { Divider() }` 적용

## 빌드 검증
- `xcodebuild` macOS 타겟 빌드 성공 (`BUILD SUCCEEDED`)
