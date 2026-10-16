// Feature: Delete rules
// Slot 12 — Qamsar blank card
// Teaches:
// - .cascade is stored even when the cook has no slips.
// - Voiding that card removes the cook, and the save stands.

import SwiftData
import SwiftUI

@Model
final class BlankSlip {
    var line: String
    var cook: BlankCook?

    init(line: String) {
        self.line = line
    }
}

@Model
final class BlankCook {
    var lotCode: String
    var distillerName: String
    @Relationship(deleteRule: .cascade, inverse: \BlankSlip.cook)
    var slips: [BlankSlip] = []

    init(lotCode: String, distillerName: String) {
        self.lotCode = lotCode
        self.distillerName = distillerName
    }
}

struct BlankCardScreen: View {
    private let container = MemoryStore.containerOrCrash(BlankCook.self, BlankSlip.self)

    var body: some View {
        BlankCardEditor()
            .modelContainer(container)
    }
}

private struct BlankCardEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cook: BlankCook?
    @State private var cookCount = -1

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 12",
            title: "Qamsar blank card",
            situation: "On 19 May Hossein Nazeri writes a cook card for a second charge and voids it before any slip is hung.",
            teaches: [
                ".cascade is stored even when the cook has no slips.",
                "Voiding that card removes the cook, and the save stands."
            ]
        ) {
            if let cook {
                BlankFields(cook: cook, schema: modelContext.container.schema, cookCount: cookCount)
                if cookCount < 0 {
                    Button("Void the blank card") {
                        voidCard(cook)
                    }
                }
            } else {
                Button("Write the blank card") {
                    writeCard()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func writeCard() {
        let cook = BlankCook(lotCode: "QS-23", distillerName: "Hossein Nazeri")
        modelContext.insert(cook)
        try? modelContext.save()
        self.cook = cook
    }

    private func voidCard(_ cook: BlankCook) {
        modelContext.delete(cook)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        cookCount = ((try? filed.fetch(FetchDescriptor<BlankCook>())) ?? []).count
    }
}

private struct BlankFields: View {
    let cook: BlankCook
    let schema: Schema
    let cookCount: Int

    var body: some View {
        Section(cook.lotCode) {
            LabeledContent("Distiller", value: cook.distillerName)
            LabeledContent("Rule", value: ruleTitle)
            LabeledContent("Slips", value: "\(cook.slips.count)")
        }
        if cookCount >= 0 {
            Section("Filed book") {
                LabeledContent("Cooks", value: "\(cookCount)")
            }
        }
        Section {
            Text("On 20 May the four outcomes sit on Maryam Farahi's counter.")
                .foregroundStyle(.secondary)
        }
    }

    private var ruleTitle: String {
        guard let rule = StoredRelationship.named("slips", on: "BlankCook", in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
