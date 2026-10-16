// Feature: Codable and enums
// Slot 02 — Minas roast
// Teaches:
// - A Codable struct is a value on the roast card, not a related model.
// - Copying, editing, and assigning the value files the revised roast.

import SwiftData
import SwiftUI

struct RoastMeasure: Codable, Equatable {
    var kilos: Int
    var coveredHours: Int
}

@Model
final class RoastCard {
    var lotCode: String
    var measure: RoastMeasure

    init(lotCode: String, measure: RoastMeasure) {
        self.lotCode = lotCode
        self.measure = measure
    }

    func extendRoast(by hours: Int) {
        var revised = measure
        revised.coveredHours += hours
        measure = revised
    }
}

struct RoastCardScreen: View {
    var body: some View {
        RoastCardEditor().inMemoryStore(for: RoastCard.self)
    }
}

private struct RoastCardEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var roast: RoastCard?
    @State private var filed: RoastMeasure?
    @State private var failure: String?

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 02",
            title: "Minas roast",
            situation: "On 3 March Lucía Hernández covers 840 kilos of Inés's espadín in the earth oven at Palenque del Guayabo, Santa Catarina Minas. She adds six hours to the 72-hour roast.",
            teaches: [
                "A Codable struct is a value on the roast card, not a related model.",
                "Copying, editing, and assigning the value files the revised roast."
            ]
        ) {
            if let roast {
                Grid(alignment: .leading) {
                    GridRow { Text("Reading"); Text("Kilos"); Text("Hours") }
                    GridRow { Text("Open card"); Text("\(roast.measure.kilos)"); Text("\(roast.measure.coveredHours)") }
                    if let filed {
                        GridRow { Text("New context"); Text("\(filed.kilos)"); Text("\(filed.coveredHours)") }
                    }
                }
                Button("Keep the oven covered six more hours") {
                    roast.extendRoast(by: 6)
                    do {
                        try modelContext.save()
                        filed = try modelContext.freshFirst(RoastCard.self)?.measure
                    } catch { failure = error.localizedDescription }
                }
            } else {
                Button("Write the oven card") {
                    let roast = RoastCard(lotCode: "SC-26", measure: RoastMeasure(kilos: 840, coveredHours: 72))
                    modelContext.insert(roast)
                    self.roast = roast
                }
            }
            if let failure { Text(failure).foregroundStyle(.red) }
        }
    }
}
