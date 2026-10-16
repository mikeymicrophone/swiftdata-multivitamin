// Feature: @Model basics
// Slot 05 — Fabriano damp pack
// Teaches:
// - String, Int, Double, Bool, and Date store as themselves.
// - One model can carry that mix without an attribute wrapper.

import SwiftData
import SwiftUI

@Model
final class RagDampSlip {
    var ragDescription: String
    var sheetCount: Int
    var dampPercent: Double
    var sized: Bool
    var dampedOn: Date

    init(ragDescription: String, sheetCount: Int, dampPercent: Double, sized: Bool, dampedOn: Date) {
        self.ragDescription = ragDescription
        self.sheetCount = sheetCount
        self.dampPercent = dampPercent
        self.sized = sized
        self.dampedOn = dampedOn
    }
}

struct RagDampSlipScreen: View {
    var body: some View {
        RagDampSlipEditor()
            .inMemoryStore(for: RagDampSlip.self)
    }
}

private struct RagDampSlipEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var slip: RagDampSlip?

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 05",
            title: "Fabriano damp pack",
            situation: "Chiara Fioravanti damps the cotton rag that will take the quince impressions. The slip holds a description, a count, a percent, a yes, and a day.",
            teaches: [
                "String, Int, Double, Bool, and Date store as themselves.",
                "One model can carry that mix without an attribute wrapper."
            ]
        ) {
            if let slip {
                DampFields(slip: slip)
            } else {
                Button("Damp the pack") {
                    dampPack()
                }
            }
        }
    }

    private func dampPack() {
        let slip = RagDampSlip(
            ragDescription: "Cotton offcuts from the Prato mills",
            sheetCount: 80,
            dampPercent: 42.5,
            sized: true,
            dampedOn: GregorianDay.date(year: 2026, month: 3, day: 9, timeZoneIdentifier: "Europe/Rome")
        )
        modelContext.insert(slip)
        self.slip = slip
    }
}

private struct DampFields: View {
    @Bindable var slip: RagDampSlip

    var body: some View {
        Section("Fioravanti rag mill") {
            TextField("Rag", text: $slip.ragDescription)
            Stepper(value: $slip.sheetCount, in: 1...400) {
                Text("Sheets: \(slip.sheetCount)")
            }
            Stepper(value: $slip.dampPercent, in: 20...80, step: 0.5) {
                Text("Damp: \(slip.dampPercent.formatted(.number.precision(.fractionLength(1))))%")
            }
            Toggle("Sheets are sized", isOn: $slip.sized)
            DatePicker("Damped", selection: $slip.dampedOn, displayedComponents: .date)
        }

        Section {
            Text("The damp pack and the bitten plates meet at Giulia Bruni's road desk in Verona.")
                .foregroundStyle(.secondary)
        }
    }
}
