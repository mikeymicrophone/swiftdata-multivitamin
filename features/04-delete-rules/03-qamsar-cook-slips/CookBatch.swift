// Feature: Delete rules
// Slot 03 — Qamsar cook slips
// Teaches:
// - .cascade on the cook deletes the slips with the cook.
// - A new context finds neither the cook nor the slips.

import SwiftData
import SwiftUI

@Model
final class TasteSlip {
    var line: String
    var cook: CookBatch?

    init(line: String) {
        self.line = line
    }
}

@Model
final class CookBatch {
    var lotCode: String
    var distillerName: String
    @Relationship(deleteRule: .cascade, inverse: \TasteSlip.cook)
    var slips: [TasteSlip] = []

    init(lotCode: String, distillerName: String) {
        self.lotCode = lotCode
        self.distillerName = distillerName
    }
}

struct CookBatchScreen: View {
    private let container = MemoryStore.containerOrCrash(CookBatch.self, TasteSlip.self)

    var body: some View {
        CookBatchEditor()
            .modelContainer(container)
    }
}

private struct CookBatchEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cook: CookBatch?
    @State private var cookCount = -1
    @State private var slipCount = -1

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 03",
            title: "Qamsar cook slips",
            situation: "On 14 May Hossein Nazeri voids the cook card for QS-22. Two tasting slips were written only for that cook: clear, and a long rose.",
            teaches: [
                ".cascade on the cook deletes the slips with the cook.",
                "A new context finds neither the cook nor the slips."
            ]
        ) {
            if let cook {
                CookFields(cook: cook, schema: modelContext.container.schema, cookCount: cookCount, slipCount: slipCount)
                if cookCount < 0 {
                    Button("Void the cook card") {
                        voidCook(cook)
                    }
                }
            } else {
                Button("Hang the tasting slips") {
                    hangSlips()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func hangSlips() {
        let cook = CookBatch(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let clear = TasteSlip(line: "Clear")
        let rose = TasteSlip(line: "Long rose")
        modelContext.insert(cook)
        modelContext.insert(clear)
        modelContext.insert(rose)
        cook.slips.append(clear)
        cook.slips.append(rose)
        try? modelContext.save()
        self.cook = cook
    }

    private func voidCook(_ cook: CookBatch) {
        modelContext.delete(cook)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        cookCount = ((try? filed.fetch(FetchDescriptor<CookBatch>())) ?? []).count
        slipCount = ((try? filed.fetch(FetchDescriptor<TasteSlip>())) ?? []).count
    }
}

private struct CookFields: View {
    let cook: CookBatch
    let schema: Schema
    let cookCount: Int
    let slipCount: Int

    var body: some View {
        Section(cook.lotCode) {
            LabeledContent("Distiller", value: cook.distillerName)
            LabeledContent("Rule", value: ruleTitle)
            LabeledContent("Slips", value: cook.slips.map(\.line).joined(separator: ", "))
        }
        if cookCount >= 0 {
            Section("Filed book") {
                LabeledContent("Cooks", value: "\(cookCount)")
                LabeledContent("Slips", value: "\(slipCount)")
            }
        }
        Section {
            Text("One of those slips can be torn on its own.")
                .foregroundStyle(.secondary)
        }
    }

    private var ruleTitle: String {
        guard let rule = StoredRelationship.named("slips", on: "CookBatch", in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
