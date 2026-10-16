// Feature: Attributes
// Slot 10 — Puno bale code
// Teaches:
// - One property can carry more than one attribute option.
// - PU-77 is unique and marked for Spotlight.

import SwiftData
import SwiftUI

@Model
final class BalePlate {
    @Attribute(.unique, .spotlight) var baleCode: String
    var clerkName: String
    var destination: String
    var sealedOn: Date

    init(baleCode: String, clerkName: String, destination: String, sealedOn: Date) {
        self.baleCode = baleCode
        self.clerkName = clerkName
        self.destination = destination
        self.sealedOn = sealedOn
    }
}

struct BalePlateScreen: View {
    private let container = MemoryStore.containerOrCrash(BalePlate.self)

    var body: some View {
        BalePlateEditor()
            .modelContainer(container)
    }
}

private struct BalePlateEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var plate: BalePlate?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 10",
            title: "Puno bale code",
            situation: "On 12 June Soledad Condori nails plate PU-77 on the bale. The code is the only one of its kind, and it is marked for Spotlight.",
            teaches: [
                "One property can carry more than one attribute option.",
                "PU-77 is unique and marked for Spotlight."
            ]
        ) {
            if let plate {
                PlateFields(plate: plate, schema: modelContext.container.schema)
            } else {
                Button("Nail the plate") {
                    nailPlate()
                }
            }
        }
    }

    private func nailPlate() {
        let plate = BalePlate(
            baleCode: "PU-77",
            clerkName: "Soledad Condori",
            destination: "Taller Choque, Sucre",
            sealedOn: GregorianDay.date(year: 2026, month: 6, day: 12, timeZoneIdentifier: "America/Lima")
        )
        modelContext.insert(plate)
        self.plate = plate
    }
}

private struct PlateFields: View {
    let plate: BalePlate
    let schema: Schema

    private var attribute: Schema.Attribute? {
        StoredAttribute.named("baleCode", on: "BalePlate", in: schema)
    }

    var body: some View {
        Section("Condori road desk") {
            LabeledContent("Clerk", value: plate.clerkName)
            LabeledContent("Bale", value: plate.baleCode)
            LabeledContent("Destination", value: plate.destination)
            LabeledContent("Unique", value: attribute?.isUnique == true ? "Yes" : "No")
            LabeledContent("Spotlight", value: attribute?.options.contains(.spotlight) == true ? "Marked" : "Unmarked")
        }
    }
}
