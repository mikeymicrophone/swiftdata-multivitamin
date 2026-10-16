// Feature: Delete rules
// Slot 04 — Qamsar torn slip
// Teaches:
// - The cook's rule is cascade. The slip's rule back is nullify.
// - Tearing up the slip runs the slip's rule, and the cook stays.

import SwiftData
import SwiftUI

struct TornSlipScreen: View {
    var body: some View {
        TornSlipEditor()
            .inMemoryStore(for: CookBatch.self, TasteSlip.self)
    }
}

private struct TornSlipEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cook: CookBatch?
    @State private var torn: TasteSlip?
    @State private var cookLine = ""
    @State private var slipLine = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 04",
            title: "Qamsar torn slip",
            situation: "The same afternoon the clear slip is torn. The cook card for QS-22, and the long-rose slip, stay on the nail.",
            teaches: [
                "The cook's rule is cascade. The slip's rule back is nullify.",
                "Tearing up the slip runs the slip's rule, and the cook stays."
            ]
        ) {
            if let cook, let torn {
                TornFields(cook: cook, schema: modelContext.container.schema, cookLine: cookLine, slipLine: slipLine)
                if cookLine.isEmpty {
                    Button("Tear up the clear slip") {
                        tear(torn)
                    }
                }
            } else {
                Button("Hang both slips") {
                    hangSlips()
                }
            }
        }
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
        torn = clear
    }

    private func tear(_ slip: TasteSlip) {
        modelContext.delete(slip)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        let cooks = (try? filed.fetch(FetchDescriptor<CookBatch>())) ?? []
        let slips = (try? filed.fetch(FetchDescriptor<TasteSlip>())) ?? []
        cookLine = cooks.first.map { "\($0.lotCode), \($0.slips.map(\.line).joined(separator: ", "))" } ?? "No cook"
        slipLine = slips.map(\.line).joined(separator: ", ")
    }
}

private struct TornFields: View {
    let cook: CookBatch
    let schema: Schema
    let cookLine: String
    let slipLine: String

    var body: some View {
        Section(cook.lotCode) {
            LabeledContent("Cook rule", value: ruleTitle("slips", on: "CookBatch"))
            LabeledContent("Slip rule", value: ruleTitle("cook", on: "TasteSlip"))
        }
        if !cookLine.isEmpty {
            Section("Filed book") {
                Text(cookLine)
                LabeledContent("Slips", value: slipLine.isEmpty ? "None" : slipLine)
            }
        }
        Section {
            Text("Farhad Golshan's seal chit in the Kashan bazaar warrants this cook.")
                .foregroundStyle(.secondary)
        }
    }

    private func ruleTitle(_ name: String, on typeName: String) -> String {
        guard let rule = StoredRelationship.named(name, on: typeName, in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
