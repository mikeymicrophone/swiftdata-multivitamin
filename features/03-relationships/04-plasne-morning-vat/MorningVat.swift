// Feature: Relationships
// Slot 04 — Plasne morning vat
// Teaches:
// - Setting the wheel's vat fills the vat's wheel list.
// - The list is the inverse. Nobody appends to it.

import SwiftData
import SwiftUI

@Model
final class VatWheel {
    var code: String
    var vat: MorningVat?

    init(code: String, vat: MorningVat? = nil) {
        self.code = code
        self.vat = vat
    }
}

@Model
final class MorningVat {
    var vatName: String
    var cheesemakerName: String
    @Relationship(inverse: \VatWheel.vat)
    var wheels: [VatWheel] = []

    init(vatName: String, cheesemakerName: String) {
        self.vatName = vatName
        self.cheesemakerName = cheesemakerName
    }
}

struct MorningVatScreen: View {
    var body: some View {
        MorningVatEditor()
            .inMemoryStore(for: VatWheel.self, MorningVat.self)
    }
}

private struct MorningVatEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var vat: MorningVat?
    @State private var wheel: VatWheel?

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 04",
            title: "Plasne morning vat",
            situation: "On 3 September Lucien Morel charges the morning vat with the plateau milk and marks wheel PL-19 as that vat's wheel.",
            teaches: [
                "Setting the wheel's vat fills the vat's wheel list.",
                "The list is the inverse. Nobody appends to it."
            ]
        ) {
            if let vat, let wheel {
                VatFields(vat: vat, wheel: wheel)
            } else {
                Button("Mark the vat on PL-19") {
                    markVat()
                }
            }
        }
    }

    private func markVat() {
        let vat = MorningVat(vatName: "Cuve du matin", cheesemakerName: "Lucien Morel")
        let wheel = VatWheel(code: "PL-19")
        modelContext.insert(vat)
        modelContext.insert(wheel)
        wheel.vat = vat
        self.vat = vat
        self.wheel = wheel
    }
}

private struct VatFields: View {
    let vat: MorningVat
    let wheel: VatWheel

    var body: some View {
        Section(wheel.code) {
            LabeledContent("Vat", value: wheel.vat?.vatName ?? "None")
            LabeledContent("Cheesemaker", value: vat.cheesemakerName)
        }

        Section(vat.vatName) {
            Text(vat.wheels.map(\.code).joined(separator: ", "))
        }

        Section {
            Text("Claire Roux racks PL-19 in the young cave at Les Rousses.")
                .foregroundStyle(.secondary)
        }
    }
}
