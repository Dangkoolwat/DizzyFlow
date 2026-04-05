import SwiftUI
import AppKit

/// 무조건 위쪽으로 열리는 텍스트 메뉴 피커
struct UpwardMenuPicker: NSViewRepresentable {
    let title: String
    @Binding var selection: String
    let options: [String]

    func makeNSView(context: Context) -> NSButton {
        let button = NSButton()
        button.title = "\(title): \(selection)"
        button.target = context.coordinator
        button.action = #selector(Coordinator.showMenu(_:))
        button.isBordered = false
        button.bezelStyle = .inline
        button.font = NSFont.systemFont(ofSize: 12)
        button.contentTintColor = NSColor.labelColor
        return button
    }

    func updateNSView(_ nsView: NSButton, context: Context) {
        nsView.title = "\(title): \(selection)"
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: UpwardMenuPicker

        init(_ parent: UpwardMenuPicker) {
            self.parent = parent
        }

        @objc func showMenu(_ sender: NSButton) {
            let menu = NSMenu()
            menu.autoenablesItems = false
            menu.minimumWidth = sender.bounds.width
            
            // 기존 .state = .on 코드가 macOS 특유의 "선택 항목 중앙 스냅핑"을 유발하여
            // 억지로 메뉴 방향을 꼬아버리는 주범이었습니다. 시스템 state를 뺍니다.
            let checkImage = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)
            
            for option in parent.options {
                let item = NSMenuItem(title: option, action: #selector(optionSelected(_:)), keyEquivalent: "")
                item.target = self
                
                // 선택됨(✓) 표시를 시스템 state가 아닌 이미지로 처리하여 스냅핑 락 다운 방지
                if option == parent.selection {
                    item.image = checkImage
                }
                
                menu.addItem(item)
            }
            
            let yOffset: CGFloat = 12
            let point: NSPoint
            
            if sender.isFlipped {
                point = NSPoint(x: -8, y: sender.bounds.minY - yOffset)
            } else {
                point = NSPoint(x: -8, y: sender.bounds.maxY + yOffset)
            }
            
            // 이제 macOS가 스냅을 무시하므로, 정확히 마지막 항목(bottom)이 버튼 위에 맞물리며 전부 위로 떠오릅니다!
            menu.popUp(positioning: menu.items.last, at: point, in: sender)
        }

        @objc func optionSelected(_ sender: NSMenuItem) {
            parent.selection = sender.title
        }
    }
}
