// Feature: Codable and enums
// Slot 01 — Miahuatlán agave
// Teaches:
// - A String-backed Codable enum can be a stored property.
// - CaseIterable supplies a Picker without storing its display labels separately.

import SwiftData
import SwiftUI

enum HarvestAgave: String, Codable, CaseIterable {
    case espadin = "Espadín"
    case cuishe = "Cuishe"
    case tobala = "Tobalá"
}

@Model
final class AgaveHarvest {
    var lotCode: String
    var growerName: String
    var agave: HarvestAgave

    init(lotCode: String, growerName: String, agave: HarvestAgave = .espadin) {
        self.lotCode = lotCode
        self.growerName = growerName
        self.agave = agave
    }
}

struct AgaveHarvestScreen: View {
    var body: some View {
        AgaveHarvestEditor().inMemoryStore(for: AgaveHarvest.self)
    }
}

private struct AgaveHarvestEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var harvest: AgaveHarvest?
    @State private var filedAgave = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 01",
            title: "Miahuatlán agave",
            situation: "On 2 March 2026 Inés Santiago cuts espadín for lot SC-26 near Miahuatlán. The piñas go to Lucía's palenque in Santa Catarina Minas.",
            teaches: [
                "A String-backed Codable enum can be a stored property.",
                "CaseIterable supplies a Picker without storing its display labels separately."
            ]
        ) {
            if let harvest {
                HarvestFields(harvest: harvest)
                Button("File the agave name") {
                    do {
                        try modelContext.save()
                        filedAgave = try modelContext.freshFirst(AgaveHarvest.self)?.agave.rawValue ?? "No harvest"
                    } catch {
                        filedAgave = error.localizedDescription
                    }
                }
                LabeledContent("New context", value: filedAgave)
            } else {
                Button("Receive Inés's piñas") {
                    let harvest = AgaveHarvest(lotCode: "SC-26", growerName: "Inés Santiago")
                    modelContext.insert(harvest)
                    self.harvest = harvest
                }
            }
        }
    }
}

private struct HarvestFields: View {
    @Bindable var harvest: AgaveHarvest

    var body: some View {
        Section(harvest.lotCode) {
            Text(harvest.growerName)
            Picker("Agave", selection: $harvest.agave) {
                ForEach(HarvestAgave.allCases, id: \.self) { agave in
                    Text(agave.rawValue).tag(agave)
                }
            }
        }
    }
}
