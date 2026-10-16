// Feature: Delete rules
// Slot 06 — Qamsar copper still
// Teaches:
// - .deny is stored on the still's cook list.
// - The save still removes the still. The charged cook remains, with an empty still line.

import SwiftData
import SwiftUI

@Model
final class ChargedCook {
    var lotCode: String
    var distillerName: String
    var still: CopperStill?

    init(lotCode: String, distillerName: String) {
        self.lotCode = lotCode
        self.distillerName = distillerName
    }
}

@Model
final class CopperStill {
    var stillName: String
    var smithName: String
    // The schema stores deny. Saving the deletion still removes the still.
    @Relationship(deleteRule: .deny, inverse: \ChargedCook.still)
    var cooks: [ChargedCook] = []

    init(stillName: String, smithName: String) {
        self.stillName = stillName
        self.smithName = smithName
    }
}

struct CopperStillScreen: View {
    private let container = MemoryStore.containerOrCrash(CopperStill.self, ChargedCook.self)

    var body: some View {
        CopperStillEditor()
            .modelContainer(container)
    }
}

private struct CopperStillEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var still: CopperStill?
    @State private var stillCount = -1
    @State private var cookLine = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 06",
            title: "Qamsar copper still",
            situation: "On 16 May the card for Still 2 is pulled while cook QS-22 is charged on it. The rule on that list is deny.",
            teaches: [
                ".deny is stored on the still's cook list.",
                "The save still removes the still. The charged cook remains, with an empty still line."
            ]
        ) {
            if let still {
                StillFields(still: still, schema: modelContext.container.schema, stillCount: stillCount, cookLine: cookLine)
                if stillCount < 0 {
                    Button("Pull the still card") {
                        pullCard(still)
                    }
                }
            } else {
                Button("Charge Still 2") {
                    chargeStill()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func chargeStill() {
        let still = CopperStill(stillName: "Still 2", smithName: "Farhad Golshan")
        let cook = ChargedCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        modelContext.insert(still)
        modelContext.insert(cook)
        still.cooks.append(cook)
        try? modelContext.save()
        self.still = still
    }

    private func pullCard(_ still: CopperStill) {
        modelContext.delete(still)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        let stills = (try? filed.fetch(FetchDescriptor<CopperStill>())) ?? []
        let cooks = (try? filed.fetch(FetchDescriptor<ChargedCook>())) ?? []
        stillCount = stills.count
        cookLine = cooks.first.map { "\($0.lotCode), still \($0.still?.stillName ?? "empty")" } ?? "No cook"
    }
}

private struct StillFields: View {
    let still: CopperStill
    let schema: Schema
    let stillCount: Int
    let cookLine: String

    var body: some View {
        Section(still.stillName) {
            LabeledContent("Smith", value: still.smithName)
            LabeledContent("Rule", value: ruleTitle)
            LabeledContent("Charged", value: still.cooks.map(\.lotCode).joined(separator: ", "))
        }
        if stillCount >= 0 {
            Section("Filed book") {
                LabeledContent("Stills", value: "\(stillCount)")
                Text(cookLine)
            }
        }
        Section {
            Text("The chalk tally on the still-house wall is wiped next.")
                .foregroundStyle(.secondary)
        }
    }

    private var ruleTitle: String {
        guard let rule = StoredRelationship.named("cooks", on: "CopperStill", in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
