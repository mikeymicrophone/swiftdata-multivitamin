// Feature: Attributes
// Slot 06 — Arequipa renamed kilos
// Teaches:
// - originalName records the column's previous name.
// - A property with no original name stores an empty original name.

import SwiftData
import SwiftUI

@Model
final class ScouredWeight {
    var lotCode: String
    var millerName: String
    @Attribute(originalName: "fleeceKilos") var scouredKilos: Double
    var weighedOn: Date

    init(lotCode: String, millerName: String, scouredKilos: Double, weighedOn: Date) {
        self.lotCode = lotCode
        self.millerName = millerName
        self.scouredKilos = scouredKilos
        self.weighedOn = weighedOn
    }
}

struct ScouredWeightScreen: View {
    private let container = MemoryStore.containerOrCrash(ScouredWeight.self)

    var body: some View {
        ScouredWeightEditor()
            .modelContainer(container)
    }
}

private struct ScouredWeightEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var weight: ScouredWeight?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 06",
            title: "Arequipa renamed kilos",
            situation: "On 11 June Raúl Mamani reprints the mill card. The old column was fleece kilos. The card now says scoured kilos.",
            teaches: [
                "originalName records the column's previous name.",
                "A property with no original name stores an empty original name."
            ]
        ) {
            if let weight {
                WeightFields(weight: weight, schema: modelContext.container.schema)
            } else {
                Button("Reprint the weight") {
                    reprint()
                }
            }
        }
    }

    private func reprint() {
        let weight = ScouredWeight(
            lotCode: "AQ-10",
            millerName: "Raúl Mamani",
            scouredKilos: 1.1,
            weighedOn: GregorianDay.date(year: 2026, month: 6, day: 11, timeZoneIdentifier: "America/Lima")
        )
        modelContext.insert(weight)
        self.weight = weight
    }
}

private struct WeightFields: View {
    let weight: ScouredWeight
    let schema: Schema

    private var scoured: Schema.Attribute? {
        StoredAttribute.named("scouredKilos", on: "ScouredWeight", in: schema)
    }

    private var lot: Schema.Attribute? {
        StoredAttribute.named("lotCode", on: "ScouredWeight", in: schema)
    }

    private var previousLotColumn: String {
        let previous = lot?.originalName ?? ""
        return previous.isEmpty ? "Empty" : previous
    }

    var body: some View {
        Section("Lavadero Mamani") {
            LabeledContent("Miller", value: weight.millerName)
            LabeledContent("Lot", value: weight.lotCode)
            LabeledContent("Scoured kilos", value: weight.scouredKilos.formatted(.number.precision(.fractionLength(1))))
            LabeledContent("Previous column", value: scoured?.originalName ?? "")
            LabeledContent("Lot's previous column", value: previousLotColumn)
        }
    }
}
