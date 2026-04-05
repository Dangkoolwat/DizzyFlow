# 구현 계획: 설정(Settings) UI 고도화

본 문서는 실제 코드 작업에 적용된 설정 화면 개선 절차를 기록합니다.

## 1. 개조 단계 (Step-by-Step)
1. **단계 1: 테마 전환기 메뉴 개편 (`ContentView.swift`)**
   - [MODIFY] `Picker` -> `Menu` 구성 요소 변환.
   - [MODIFY] 툴바 아이콘 스케일 및 스타일(`borderlessButton`) 적용.
   - [ADD] 사이드바 Settings 버튼 토글 로직 구현.

2. **단계 2: 설정 상세 뷰 통합 수정 (`SettingsWorkspaceView.swift`)**
   - [DELETE] `SettingsCategory.gemma4` 열거형 및 관련 뷰 호출 구간 삭제.
   - [MODIFY] `GeneralSettingsView` 테마 섹션 제거 및 언어 피커 너비(`140pt`) 제한.
   - [MODIFY] `ModelsSettingsView` 레이아웃을 2단 구조(`modelRow2Line`)로 변경.
   - [ADD] 모델 리스트 가변 높이에 따른 `ScrollView` 및 `maxHeight` 제약 추가.
   - [MODIFY] `LicenseSettingsView` 중앙 박스 너비(`maxWidth: 600`) 및 레이아웃 확장성 수정.
   - [ADD] 외부 `license.txt` 파일 로드용 UTF-8 인코딩 명시 및 로직 안정화.

3. **단계 3: 검증 및 정리**
   - [CHECK] `xcodebuild`를 통한 프로젝트 빌드 성공 확인.
   - [CLEAN] 불필요해진 임시 변수 및 레거시 목업 코드 정리.

## 2. 영향 범위 (Affected Modules)
- `App/WorkflowStore.swift`: 설정 데이터 모델 구조는 유지하되, 일부 데이터 연동 최적화.
- `Features/ContentView.swift`: 사이드바 토글 및 상단 툴바 UI 변경.
- `Features/SettingsWorkspaceView.swift`: 설정 카테고리 및 세부 레이아웃 전면 개편.

## 3. 리스크 및 보안 영역
- **리스크**: 라이선스 파일(`license.txt`)이 누락될 경우를 대비한 기본 텍스트 방어 로직 적용 완료.
- **성능**: 모델 리스트 스크롤 시 프레임 드랍이 없도록 `VStack` 대신 효율적인 스택 구조 확인.
