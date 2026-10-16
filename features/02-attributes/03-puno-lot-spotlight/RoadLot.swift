// Feature: Attributes
// Slot 03 — Puno lot spotlight
// Teaches:
// - @Attribute(.spotlight) marks a property for Spotlight.
// - The mark is on the attribute. This in-memory store is not a Spotlight catalog.

import SwiftData
import SwiftUI

@Model
final class RoadLot {
    @Attribute(.spotlight) var lotName: String
    var deskName: String
    var clerkName: String
    var leavesOn: Date

    init(lotName: String, deskName: String, clerkName: String, leavesOn: Date) {
        self.lotName = lotName
        self.deskName = deskName
        self.clerkName = clerkName
        self.leavesOn = leavesOn
    }
}

struct RoadLotScreen: View {
    private let container = MemoryStore.containerOrCrash(RoadLot.self)

    var body: some View {
        RoadLotEditor()
            .modelContainer(container)
    }
}

private struct RoadLotEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var lot: RoadLot?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 03",
            title: "Puno lot spotlight",
            situation: "On 12 June Soledad Condori writes the lot name the Puno road desk will search for. The name is marked for Spotlight. This store does not keep a Spotlight catalog.",
            teaches: [
                "@Attribute(.spotlight) marks a property for Spotlight.",
                "The mark is on the attribute. This in-memory store is not a Spotlight catalog."
            ]
        ) {
            if let lot {
                LotFields(lot: lot, schema: modelContext.container.schema)
            } else {
                Button("Write the lot name") {
                    writeLot()
                }
            }
        }
    }

    private func writeLot() {
        let lot = RoadLot(
            lotName: "Lucanas chaccu, shawl for La Paz",
            deskName: "Condori road desk",
            clerkName: "Soledad Condori",
            leavesOn: GregorianDay.date(year: 2026, month: 6, day: 12, timeZoneIdentifier: "America/Lima")
        )
        modelContext.insert(lot)
        self.lot = lot
    }
}

private struct LotFields: View {
    let lot: RoadLot
    let schema: Schema

    private var marked: Bool {
        StoredAttribute.named("lotName", on: "RoadLot", in: schema)?.options.contains(.spotlight) == true
    }

    var body: some View {
        Section(lot.deskName) {
            LabeledContent("Clerk", value: lot.clerkName)
            LabeledContent("Lot", value: lot.lotName)
            LabeledContent("Leaves", value: lot.leavesOn.formatted(date: .long, time: .omitted))
            LabeledContent("Spotlight", value: marked ? "Marked" : "Unmarked")
        }

        Section {
            Text("The bale is bound for Rosario Choque's dye studio in Sucre.")
                .foregroundStyle(.secondary)
        }
    }
}
