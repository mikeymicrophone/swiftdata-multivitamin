// Feature: Relationships
// Slot 09 — Poligny tasting slip
// Teaches:
// - The slip is one model with two to-one links.
// - Each inverse list contains that slip.

import SwiftData
import SwiftUI

@Model
final class SlipTaster {
    var tasterName: String
    @Relationship(inverse: \TastingSlip.taster)
    var slips: [TastingSlip] = []

    init(tasterName: String) {
        self.tasterName = tasterName
    }
}

@Model
final class SlipWheel {
    var code: String
    @Relationship(inverse: \TastingSlip.wheel)
    var slips: [TastingSlip] = []

    init(code: String) {
        self.code = code
    }
}

@Model
final class TastingSlip {
    var note: String
    var scoredOn: Date
    var taster: SlipTaster?
    var wheel: SlipWheel?

    init(note: String, scoredOn: Date) {
        self.note = note
        self.scoredOn = scoredOn
    }
}

struct TastingSlipScreen: View {
    var body: some View {
        TastingSlipEditor()
            .inMemoryStore(for: TastingSlip.self, SlipTaster.self, SlipWheel.self)
    }
}

private struct TastingSlipEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var slip: TastingSlip?

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 09",
            title: "Poligny tasting slip",
            situation: "On 9 September Inès Garnier writes one slip for wheel PL-19: supple paste, fruit long, no hole. The slip belongs to her and to that wheel.",
            teaches: [
                "The slip is one model with two to-one links.",
                "Each inverse list contains that slip."
            ]
        ) {
            if let slip {
                SlipFields(slip: slip, schema: modelContext.container.schema)
            } else {
                Button("Write the slip") {
                    writeSlip()
                }
            }
        }
    }

    private func writeSlip() {
        let taster = SlipTaster(tasterName: "Inès Garnier")
        let wheel = SlipWheel(code: "PL-19")
        let slip = TastingSlip(
            note: "Supple paste, fruit long, no hole",
            scoredOn: GregorianDay.date(year: 2026, month: 9, day: 9, timeZoneIdentifier: "Europe/Paris")
        )
        modelContext.insert(taster)
        modelContext.insert(wheel)
        modelContext.insert(slip)
        slip.taster = taster
        slip.wheel = wheel
        self.slip = slip
    }
}

private struct SlipFields: View {
    let slip: TastingSlip
    let schema: Schema

    var body: some View {
        Section(slip.note) {
            LabeledContent("Taster", value: slip.taster?.tasterName ?? "None")
            LabeledContent("Wheel", value: slip.wheel?.code ?? "None")
            LabeledContent("Taster to one", value: toOne("taster"))
            LabeledContent("Wheel to one", value: toOne("wheel"))
        }

        Section("Inverses") {
            LabeledContent("On the taster", value: "\(slip.taster?.slips.count ?? 0)")
            LabeledContent("On the wheel", value: "\(slip.wheel?.slips.count ?? 0)")
        }

        Section {
            Text("Claire Roux reprints the cave rack. The old list was called meules.")
                .foregroundStyle(.secondary)
        }
    }

    private func toOne(_ name: String) -> String {
        StoredRelationship.named(name, on: "TastingSlip", in: schema)?.isToOneRelationship == true ? "Yes" : "No"
    }
}
