// Feature: Delete rules
// Slot 07 — Qamsar wall tally
// Teaches:
// - .noAction is stored on the tally's mark list.
// - Wiping the tally leaves the mark, and the mark's tally line is empty.

import SwiftData
import SwiftUI

@Model
final class ChalkMark {
    var lotCode: String
    var tally: WallTally?

    init(lotCode: String) {
        self.lotCode = lotCode
    }
}

@Model
final class WallTally {
    var wallName: String
    var distillerName: String
    // The schema stores noAction. After the save the mark remains and its tally line is empty.
    @Relationship(deleteRule: .noAction, inverse: \ChalkMark.tally)
    var marks: [ChalkMark] = []

    init(wallName: String, distillerName: String) {
        self.wallName = wallName
        self.distillerName = distillerName
    }
}

struct WallTallyScreen: View {
    private let container = MemoryStore.containerOrCrash(WallTally.self, ChalkMark.self)

    var body: some View {
        WallTallyEditor()
            .modelContainer(container)
    }
}

private struct WallTallyEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var tally: WallTally?
    @State private var tallyCount = -1
    @State private var markLine = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 07",
            title: "Qamsar wall tally",
            situation: "On 17 May Hossein Nazeri wipes the heading off the still-house wall. The chalk mark for QS-22 was written under that heading.",
            teaches: [
                ".noAction is stored on the tally's mark list.",
                "Wiping the tally leaves the mark, and the mark's tally line is empty."
            ]
        ) {
            if let tally {
                TallyFields(tally: tally, schema: modelContext.container.schema, tallyCount: tallyCount, markLine: markLine)
                if tallyCount < 0 {
                    Button("Wipe the tally") {
                        wipe(tally)
                    }
                }
            } else {
                Button("Chalk QS-22") {
                    chalk()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func chalk() {
        let tally = WallTally(wallName: "Still-house wall, Qamsar", distillerName: "Hossein Nazeri")
        let mark = ChalkMark(lotCode: "QS-22")
        modelContext.insert(tally)
        modelContext.insert(mark)
        tally.marks.append(mark)
        try? modelContext.save()
        self.tally = tally
    }

    private func wipe(_ tally: WallTally) {
        modelContext.delete(tally)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        let tallies = (try? filed.fetch(FetchDescriptor<WallTally>())) ?? []
        let marks = (try? filed.fetch(FetchDescriptor<ChalkMark>())) ?? []
        tallyCount = tallies.count
        markLine = marks.first.map { "\($0.lotCode), tally \($0.tally?.wallName ?? "empty")" } ?? "No mark"
    }
}

private struct TallyFields: View {
    let tally: WallTally
    let schema: Schema
    let tallyCount: Int
    let markLine: String

    var body: some View {
        Section(tally.wallName) {
            LabeledContent("Distiller", value: tally.distillerName)
            LabeledContent("Rule", value: ruleTitle)
        }
        if tallyCount >= 0 {
            Section("Filed book") {
                LabeledContent("Tallies", value: "\(tallyCount)")
                Text(markLine)
            }
        }
        Section {
            Text("Voiding the cook card next takes the slips and leaves the still.")
                .foregroundStyle(.secondary)
        }
    }

    private var ruleTitle: String {
        guard let rule = StoredRelationship.named("marks", on: "WallTally", in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
