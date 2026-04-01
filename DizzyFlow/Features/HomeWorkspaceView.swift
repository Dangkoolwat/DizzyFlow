import SwiftUI

struct HomeWorkspaceView: View {
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("DizzyFlow")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Workflow-first subtitle tool")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                .frame(maxWidth: .infinity, minHeight: 180)
                .foregroundStyle(.secondary)
                .overlay(
                    VStack(spacing: 8) {
                        Text("Drag media here")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("or choose a file to start")
                            .foregroundStyle(.secondary)
                    }
                )

            Button("Choose Media File") {
                // placeholder
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Text("Start a new subtitle workflow by landing your media here.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(40)
    }
}

#Preview {
    HomeWorkspaceView()
}
