import SwiftUI

struct ScenarioChrome<Content: View>: View {
    let kicker: String
    let title: String
    let situation: String
    let teaches: [String]
    private let content: Content

    init(
        kicker: String,
        title: String,
        situation: String,
        teaches: [String],
        @ViewBuilder content: () -> Content
    ) {
        self.kicker = kicker
        self.title = title
        self.situation = situation
        self.teaches = teaches
        self.content = content()
    }

    var body: some View {
        Form {
            Section {
                Text(situation)
                    .foregroundStyle(.secondary)
            } header: {
                Text(kicker)
            }

            content

            Section("Teaches") {
                ForEach(Array(teaches.enumerated()), id: \.offset) { _, line in
                    Text(line)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(title)
    }
}
