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
    var body: some View {
        CookBatchEditor()
            .inMemoryStore(for: CookBatch.self, TasteSlip.self)
    }
}

private enum VoidOutcome {
    case hanging
    case voided(cooks: Int, slips: Int)
    case refused(any Error)
}

private struct CookBatchEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cook: CookBatch?
    @State private var outcome = VoidOutcome.hanging

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
                CookFields(cook: cook, rule: rule)
            }
            switch outcome {
            case .hanging where cook == nil:
                Button("Hang the tasting slips", action: hangSlips)
            case .hanging:
                Button("Void the cook card", role: .destructive) {
                    if let cook { outcome = voidCard(cook) }
                }
            case let .voided(cooks, slips):
                Section("Filed book") {
                    LabeledContent("Cooks", value: cooks, format: .number)
                    LabeledContent("Slips", value: slips, format: .number)
                }
            case .refused(let error):
                Section("Not voided") {
                    Text(error.localizedDescription)
                        .foregroundStyle(.red)
                }
            }
            Section {
                Text("One of those slips can be torn on its own.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var rule: String {
        StoredRelationship.named("slips", on: "CookBatch", in: modelContext.container.schema)
            .map { StoredRelationship.ruleTitle($0.deleteRule) } ?? "Missing"
    }

    private func hangSlips() {
        let cook = CookBatch(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        modelContext.insert(cook)
        for line in ["Clear", "Long rose"] {
            let slip = TasteSlip(line: line)
            modelContext.insert(slip)
            cook.slips.append(slip)
        }
        try? modelContext.save()
        self.cook = cook
    }

    private func voidCard(_ cook: CookBatch) -> VoidOutcome {
        modelContext.delete(cook)
        do {
            try modelContext.save()
            return .voided(
                cooks: try modelContext.freshCount(CookBatch.self),
                slips: try modelContext.freshCount(TasteSlip.self)
            )
        } catch {
            modelContext.rollback()
            return .refused(error)
        }
    }
}

private struct CookFields: View {
    let cook: CookBatch
    let rule: String

    var body: some View {
        Section(cook.lotCode) {
            LabeledContent("Distiller", value: cook.distillerName)
            LabeledContent("Rule", value: rule)
            LabeledContent("Slips", value: cook.slips.map(\.line).joined(separator: ", "))
        }
    }
}
