// Feature: Attributes
// Slot 04 — Sucre dye note
// Teaches:
// - @Attribute(.allowsCloudEncryption) marks a property that a synced store may encrypt.
// - The mark is on the attribute. This store does not sync.

import SwiftData
import SwiftUI

@Model
final class DyeFormula {
    var dyeName: String
    var dyerName: String
    @Attribute(.allowsCloudEncryption) var recipe: String
    var dyedOn: Date

    init(dyeName: String, dyerName: String, recipe: String, dyedOn: Date) {
        self.dyeName = dyeName
        self.dyerName = dyerName
        self.recipe = recipe
        self.dyedOn = dyedOn
    }
}

struct DyeFormulaScreen: View {
    var body: some View {
        DyeFormulaEditor()
            .inMemoryStore(for: DyeFormula.self)
    }
}

private struct DyeFormulaEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var formula: DyeFormula?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 04",
            title: "Sucre dye note",
            situation: "On 14 June Rosario Choque writes the chilca and cochineal bath at Taller Choque. The recipe is marked so a synced copy can be encrypted. This store does not sync.",
            teaches: [
                "@Attribute(.allowsCloudEncryption) marks a property that a synced store may encrypt.",
                "The mark is on the attribute. This store does not sync."
            ]
        ) {
            if let formula {
                FormulaFields(formula: formula, schema: modelContext.container.schema)
            } else {
                Button("Write the recipe") {
                    writeRecipe()
                }
            }
        }
    }

    private func writeRecipe() {
        let formula = DyeFormula(
            dyeName: "Chilca and cochineal",
            dyerName: "Rosario Choque",
            recipe: "Chilca 2, cochineal 1, cold bath",
            dyedOn: GregorianDay.date(year: 2026, month: 6, day: 14, timeZoneIdentifier: "America/La_Paz")
        )
        modelContext.insert(formula)
        self.formula = formula
    }
}

private struct FormulaFields: View {
    let formula: DyeFormula
    let schema: Schema

    private var marked: Bool {
        StoredAttribute.named("recipe", on: "DyeFormula", in: schema)?.options.contains(.allowsCloudEncryption) == true
    }

    var body: some View {
        Section("Taller Choque") {
            LabeledContent("Dyer", value: formula.dyerName)
            LabeledContent("Bath", value: formula.dyeName)
            LabeledContent("Recipe", value: formula.recipe)
            LabeledContent("Encryption", value: marked ? "Marked for a synced copy" : "Unmarked")
        }

        Section {
            Text("Edwin Cruz in Tarabuco will weave the dyed fiber.")
                .foregroundStyle(.secondary)
        }
    }
}
