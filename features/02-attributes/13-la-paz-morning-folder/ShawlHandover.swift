// Feature: Attributes
// Slot 13 — La Paz morning folder
// Teaches:
// - One schema can hold several models, each with its own attribute marks.
// - The folder is the screen. The marks stay on the attributes.

import SwiftData
import SwiftUI

enum ShawlFolder {
    static let types: [any PersistentModel.Type] = [
        ShearingLicense.self,
        ScouredWeight.self,
        DyeFormula.self,
        ShawlCounter.self
    ]
}

struct ShawlHandoverScreen: View {
    private let container: ModelContainer

    init() {
        do {
            container = try MemoryStore.make(ShawlFolder.types)
        } catch {
            fatalError("In-memory store failed: \(error)")
        }
    }

    var body: some View {
        ShawlHandoverEditor()
            .modelContainer(container)
    }
}

private struct ShawlHandoverEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var laidOut = false

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 13",
            title: "La Paz morning folder",
            situation: "On 20 June Mariela Rojas lays four slips on the counter at Casa Rojas before the family collects the shawl. Each slip keeps the attribute mark it was written with.",
            teaches: [
                "One schema can hold several models, each with its own attribute marks.",
                "The folder is the screen. The marks stay on the attributes."
            ]
        ) {
            if laidOut {
                FolderFields(schema: modelContext.container.schema)
            } else {
                Button("Lay out the folder") {
                    layOut()
                }
            }
        }
    }

    private func layOut() {
        let license = ShearingLicense(
            earMark: "LQ-184",
            communityName: "Comunidad campesina de Lucanas",
            clerkName: "Florentina Quispe",
            conditionNote: "Cut on the left shoulder",
            shornOn: GregorianDay.date(year: 2026, month: 6, day: 8, timeZoneIdentifier: "America/Lima")
        )
        let weight = ScouredWeight(
            lotCode: "AQ-10",
            millerName: "Raúl Mamani",
            scouredKilos: 1.1,
            weighedOn: GregorianDay.date(year: 2026, month: 6, day: 11, timeZoneIdentifier: "America/Lima")
        )
        let formula = DyeFormula(
            dyeName: "Chilca and cochineal",
            dyerName: "Rosario Choque",
            recipe: "Chilca 2, cochineal 1, cold bath",
            dyedOn: GregorianDay.date(year: 2026, month: 6, day: 14, timeZoneIdentifier: "America/La_Paz")
        )
        let card = ShawlCounter(
            shopName: "Casa Rojas, Calle Linares",
            sellerName: "Mariela Rojas",
            askingBolivianos: 920,
            spokenMarkup: "Add forty bolivianos",
            openedOn: GregorianDay.date(year: 2026, month: 6, day: 18, timeZoneIdentifier: "America/La_Paz")
        )
        modelContext.insert(license)
        modelContext.insert(weight)
        modelContext.insert(formula)
        modelContext.insert(card)
        laidOut = true
    }
}

private struct FolderFields: View {
    let schema: Schema

    var body: some View {
        Section("License") {
            Text(mark("earMark", on: "ShearingLicense", option: .unique) ? "LQ-184 is a unique ear mark." : "Ear mark unmarked.")
        }
        Section("Scoured weight") {
            let previous = StoredAttribute.named("scouredKilos", on: "ScouredWeight", in: schema)?.originalName ?? ""
            Text("Scoured kilos, previously \(previous).")
        }
        Section("Dye") {
            Text(mark("recipe", on: "DyeFormula", option: .allowsCloudEncryption) ? "The Sucre recipe is marked for encryption on a synced copy." : "Recipe unmarked.")
        }
        Section("Counter") {
            Text(mark("spokenMarkup", on: "ShawlCounter", option: .ephemeral) ? "The spoken markup is ephemeral. The asking price is 920 bolivianos." : "Markup unmarked.")
        }
    }

    private func mark(_ name: String, on typeName: String, option: Schema.Attribute.Option) -> Bool {
        StoredAttribute.named(name, on: typeName, in: schema)?.options.contains(option) == true
    }
}
