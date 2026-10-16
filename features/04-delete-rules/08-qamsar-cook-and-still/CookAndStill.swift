// Feature: Delete rules
// Slot 08 — Qamsar cook and still
// Teaches:
// - One delete runs cascade on the slips and nullify on the still.
// - The slips are gone. The still remains, with an empty cook line.

import SwiftData
import SwiftUI

@Model
final class BenchStill {
    var stillName: String
    var cook: VoidCook?

    init(stillName: String) {
        self.stillName = stillName
    }
}

@Model
final class VoidSlip {
    var line: String
    var cook: VoidCook?

    init(line: String) {
        self.line = line
    }
}

@Model
final class VoidCook {
    var lotCode: String
    var distillerName: String
    @Relationship(deleteRule: .nullify, inverse: \BenchStill.cook)
    var still: BenchStill?
    @Relationship(deleteRule: .cascade, inverse: \VoidSlip.cook)
    var slips: [VoidSlip] = []

    init(lotCode: String, distillerName: String) {
        self.lotCode = lotCode
        self.distillerName = distillerName
    }
}

struct CookAndStillScreen: View {
    private let container = MemoryStore.containerOrCrash(VoidCook.self, VoidSlip.self, BenchStill.self)

    var body: some View {
        CookAndStillEditor()
            .modelContainer(container)
    }
}

private struct CookAndStillEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cook: VoidCook?
    @State private var slipCount = -1
    @State private var stillLine = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 08",
            title: "Qamsar cook and still",
            situation: "On 18 May Hossein Nazeri voids the cook card for QS-22. The slips belong to the cook. Still 2 is the house's copper, not the cook's paper.",
            teaches: [
                "One delete runs cascade on the slips and nullify on the still.",
                "The slips are gone. The still remains, with an empty cook line."
            ]
        ) {
            if let cook {
                SplitFields(cook: cook, schema: modelContext.container.schema, slipCount: slipCount, stillLine: stillLine)
                if slipCount < 0 {
                    Button("Void the cook card") {
                        voidCook(cook)
                    }
                }
            } else {
                Button("File the cook on Still 2") {
                    fileCook()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func fileCook() {
        let still = BenchStill(stillName: "Still 2")
        let cook = VoidCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let clear = VoidSlip(line: "Clear")
        let rose = VoidSlip(line: "Long rose")
        modelContext.insert(still)
        modelContext.insert(cook)
        modelContext.insert(clear)
        modelContext.insert(rose)
        cook.still = still
        cook.slips.append(clear)
        cook.slips.append(rose)
        try? modelContext.save()
        self.cook = cook
    }

    private func voidCook(_ cook: VoidCook) {
        modelContext.delete(cook)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        let slips = (try? filed.fetch(FetchDescriptor<VoidSlip>())) ?? []
        let stills = (try? filed.fetch(FetchDescriptor<BenchStill>())) ?? []
        slipCount = slips.count
        stillLine = stills.first.map { "\($0.stillName), cook \($0.cook?.lotCode ?? "empty")" } ?? "No still"
    }
}

private struct SplitFields: View {
    let cook: VoidCook
    let schema: Schema
    let slipCount: Int
    let stillLine: String

    var body: some View {
        Section(cook.lotCode) {
            LabeledContent("Distiller", value: cook.distillerName)
            LabeledContent("Slips", value: ruleTitle("slips"))
            LabeledContent("Still", value: ruleTitle("still"))
        }
        if slipCount >= 0 {
            Section("Filed book") {
                LabeledContent("Slips", value: "\(slipCount)")
                Text(stillLine)
            }
        }
        Section {
            Text("A correction line under each slip goes with the cook when both links cascade.")
                .foregroundStyle(.secondary)
        }
    }

    private func ruleTitle(_ name: String) -> String {
        guard let rule = StoredRelationship.named(name, on: "VoidCook", in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
