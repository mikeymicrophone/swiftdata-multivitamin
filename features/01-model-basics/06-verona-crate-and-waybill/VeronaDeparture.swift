// Feature: @Model basics
// Slot 06 — Verona crate and waybill
// Teaches:
// - One schema can hold two model types.
// - Those types stay separate records when neither points at the other.

import SwiftData
import SwiftUI

@Model
final class PlateCrateLabel {
    var crateCode: String
    var contents: String
    var handlingNote: String

    init(crateCode: String, contents: String, handlingNote: String) {
        self.crateCode = crateCode
        self.contents = contents
        self.handlingNote = handlingNote
    }
}

@Model
final class PlateWaybill {
    var waybillCode: String
    var carrierDesk: String
    var leavesOn: Date

    init(waybillCode: String, carrierDesk: String, leavesOn: Date) {
        self.waybillCode = waybillCode
        self.carrierDesk = carrierDesk
        self.leavesOn = leavesOn
    }
}

struct VeronaDepartureScreen: View {
    var body: some View {
        VeronaDepartureEditor()
            .inMemoryStore(for: PlateCrateLabel.self, PlateWaybill.self)
    }
}

private struct VeronaDepartureEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var label: PlateCrateLabel?
    @State private var waybill: PlateWaybill?

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 06",
            title: "Verona crate and waybill",
            situation: "Giulia Bruni writes two slips for the Tuesday departure. The crate label and the waybill do not point at each other.",
            teaches: [
                "One schema can hold two model types.",
                "Those types stay separate records when neither points at the other."
            ]
        ) {
            if let label, let waybill {
                DepartureFields(label: label, waybill: waybill)
            } else {
                Button("Write both slips") {
                    writeSlips()
                }
            }
        }
    }

    private func writeSlips() {
        let label = PlateCrateLabel(
            crateCode: "VR-14",
            contents: "Six bitten copper plates, waxed",
            handlingNote: "This side up"
        )
        let waybill = PlateWaybill(
            waybillCode: "BR-338",
            carrierDesk: "Brenner road desk",
            leavesOn: GregorianDay.date(year: 2026, month: 3, day: 11, timeZoneIdentifier: "Europe/Rome")
        )
        modelContext.insert(label)
        modelContext.insert(waybill)
        self.label = label
        self.waybill = waybill
    }
}

private struct DepartureFields: View {
    @Bindable var label: PlateCrateLabel
    let waybill: PlateWaybill

    var body: some View {
        Section("Crate \(label.crateCode)") {
            LabeledContent("Contents", value: label.contents)
            TextField("Handling note", text: $label.handlingNote)
        }

        Section("Waybill \(waybill.waybillCode)") {
            LabeledContent("Carrier", value: waybill.carrierDesk)
            LabeledContent("Leaves", value: waybill.leavesOn.formatted(date: .long, time: .omitted))
        }

        Section {
            Text("The handling note lives on the crate. The waybill still leaves with the \(waybill.carrierDesk).")
                .foregroundStyle(.secondary)
        }
    }
}
