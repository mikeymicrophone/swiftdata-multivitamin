// Feature: Delete rules
// Slot 05 — Kashan seal chit
// Teaches:
// - The cascade sits on the chit, which is the model that is voided.
// - Voiding the chit deletes the cook it warrants.

import SwiftData
import SwiftUI

@Model
final class WarrantCook {
    var lotCode: String
    var chit: SealChit?

    init(lotCode: String) {
        self.lotCode = lotCode
    }
}

@Model
final class SealChit {
    var smithName: String
    var shopName: String
    @Relationship(deleteRule: .cascade, inverse: \WarrantCook.chit)
    var cook: WarrantCook?

    init(smithName: String, shopName: String) {
        self.smithName = smithName
        self.shopName = shopName
    }
}

struct SealChitScreen: View {
    var body: some View {
        SealChitEditor()
            .inMemoryStore(for: SealChit.self, WarrantCook.self)
    }
}

private struct SealChitEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var chit: SealChit?
    @State private var chitCount = -1
    @State private var cookCount = -1

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 05",
            title: "Kashan seal chit",
            situation: "On 15 May Farhad Golshan writes a seal chit in the Kashan bazaar copper row for cook QS-22. Voiding the chit withdraws that cook.",
            teaches: [
                "The cascade sits on the chit, which is the model that is voided.",
                "Voiding the chit deletes the cook it warrants."
            ]
        ) {
            if let chit {
                ChitFields(chit: chit, schema: modelContext.container.schema, chitCount: chitCount, cookCount: cookCount)
                if chitCount < 0 {
                    Button("Void the seal chit") {
                        voidChit(chit)
                    }
                }
            } else {
                Button("Write the seal chit") {
                    writeChit()
                }
            }
        }
    }

    private func writeChit() {
        let chit = SealChit(smithName: "Farhad Golshan", shopName: "Kashan bazaar, copper row")
        let cook = WarrantCook(lotCode: "QS-22")
        modelContext.insert(chit)
        modelContext.insert(cook)
        chit.cook = cook
        try? modelContext.save()
        self.chit = chit
    }

    private func voidChit(_ chit: SealChit) {
        modelContext.delete(chit)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        chitCount = (try? filed.fetchCount(FetchDescriptor<SealChit>())) ?? 0
        cookCount = (try? filed.fetchCount(FetchDescriptor<WarrantCook>())) ?? 0
    }
}

private struct ChitFields: View {
    let chit: SealChit
    let schema: Schema
    let chitCount: Int
    let cookCount: Int

    var body: some View {
        Section(chit.shopName) {
            LabeledContent("Smith", value: chit.smithName)
            LabeledContent("Rule", value: ruleTitle)
            LabeledContent("Cook", value: chit.cook?.lotCode ?? "None")
        }
        if chitCount >= 0 {
            Section("Filed book") {
                LabeledContent("Chits", value: "\(chitCount)")
                LabeledContent("Cooks", value: "\(cookCount)")
            }
        }
        Section {
            Text("The copper still's card is the next paper on Hossein's nail.")
                .foregroundStyle(.secondary)
        }
    }

    private var ruleTitle: String {
        guard let rule = StoredRelationship.named("cook", on: "SealChit", in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
