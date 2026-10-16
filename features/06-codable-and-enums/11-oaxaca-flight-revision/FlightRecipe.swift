// Feature: Codable and enums
// Slot 11 — Oaxaca flight revision
// Teaches:
// - Copying a Codable recipe into another model creates an independent value snapshot.
// - A KeyPath reduction totals the nested pours after a whole-value replacement.

import SwiftData
import SwiftUI

struct FlightPour: Codable, Equatable {
    var lotCode: String
    var millilitres: Int
}

struct PourRecipe: Codable, Equatable {
    var pours: [FlightPour]

    func total(_ measure: KeyPath<FlightPour, Int>) -> Int {
        pours.reduce(0) { $0 + $1[keyPath: measure] }
    }
}

@Model
final class FlightRecipe {
    var serviceName: String
    var recipe: PourRecipe

    init(serviceName: String, recipe: PourRecipe) {
        self.serviceName = serviceName
        self.recipe = recipe
    }

    func resizeFirstPour(to millilitres: Int) {
        guard !recipe.pours.isEmpty else { return }
        var revised = recipe
        revised.pours[0].millilitres = millilitres
        recipe = revised
    }
}

struct FlightRecipeScreen: View {
    var body: some View {
        FlightRecipeDesk().inMemoryStore(for: FlightRecipe.self)
    }
}

private struct FlightRecipeDesk: View {
    @Environment(\.modelContext) private var modelContext
    @State private var receipts: [FlightRecipe] = []
    @State private var failure: String?

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 11",
            title: "Oaxaca flight revision",
            situation: "On 23 March Elena copies Sala del Tule's SC-26 flight for Madrid's Mesa del Agave. Madrid asks for a 20 ml first pour; Oaxaca keeps its 15 ml measure.",
            teaches: [
                "Copying a Codable recipe into another model creates an independent value snapshot.",
                "A KeyPath reduction totals the nested pours after a whole-value replacement."
            ]
        ) {
            ForEach(receipts) { receipt in
                Section(receipt.serviceName) {
                    ForEach(Array(receipt.recipe.pours.enumerated()), id: \.offset) { _, pour in
                        LabeledContent(pour.lotCode, value: "\(pour.millilitres) ml")
                    }
                    Text("Total \(receipt.recipe.total(\.millilitres)) ml")
                }
            }
            Button("Copy and resize Madrid's flight") {
                let recipe = PourRecipe(pours: [FlightPour(lotCode: "SC-26", millilitres: 15), FlightPour(lotCode: "SC-25 reserve", millilitres: 10)])
                let oaxaca = FlightRecipe(serviceName: "Sala del Tule, Oaxaca", recipe: recipe)
                let madrid = FlightRecipe(serviceName: "Mesa del Agave, Madrid", recipe: oaxaca.recipe)
                madrid.resizeFirstPour(to: 20)
                modelContext.insert(oaxaca)
                modelContext.insert(madrid)
                do {
                    try modelContext.save()
                    receipts = try modelContext.freshFetch(FetchDescriptor<FlightRecipe>(sortBy: [SortDescriptor(\FlightRecipe.serviceName)]))
                } catch { failure = error.localizedDescription }
            }
            .disabled(!receipts.isEmpty)
            if let failure { Text(failure).foregroundStyle(.red) }
        }
    }
}
