// Feature: Relationships
// Slot 02 — Plateau roll
// Teaches:
// - The fruitière's roll is a to-many.
// - maximumModelCount stays 0, and the roll still holds both notes.

import SwiftData
import SwiftUI

struct PlateauRollScreen: View {
    var body: some View {
        PlateauRollEditor()
            .inMemoryStore(for: MilkNote.self, Fruitiere.self)
    }
}

private struct PlateauRollEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var fruitiere: Fruitiere?

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 02",
            title: "Plateau roll",
            situation: "The same morning Lucien Morel posts two deliveries: 86 litres from Ferme Pellier and 74 from Ferme Gaillard in Le Fied. The roll is the to-many.",
            teaches: [
                "The fruitière's roll is a to-many.",
                "maximumModelCount stays 0, and the roll still holds both notes."
            ]
        ) {
            if let fruitiere {
                RollFields(fruitiere: fruitiere, schema: modelContext.container.schema)
            } else {
                Button("Post the roll") {
                    postRoll()
                }
            }
        }
    }

    private func postRoll() {
        let notedOn = GregorianDay.date(year: 2026, month: 9, day: 2, timeZoneIdentifier: "Europe/Paris")
        let fruitiere = Fruitiere(
            deskName: "Fruitière du Plateau de Plasne",
            cheesemakerName: "Lucien Morel"
        )
        let pellier = MilkNote(
            farmName: "Ferme Pellier, Plasne",
            farmerName: "Hélène Pellier",
            litres: 86,
            notedOn: notedOn
        )
        let gaillard = MilkNote(
            farmName: "Ferme Gaillard, Le Fied",
            farmerName: "Antoine Gaillard",
            litres: 74,
            notedOn: notedOn
        )
        modelContext.insert(fruitiere)
        modelContext.insert(pellier)
        modelContext.insert(gaillard)
        fruitiere.notes.append(pellier)
        fruitiere.notes.append(gaillard)
        self.fruitiere = fruitiere
    }
}

private struct RollFields: View {
    let fruitiere: Fruitiere
    let schema: Schema

    private var roll: Schema.Relationship? {
        StoredRelationship.named("notes", on: "Fruitiere", in: schema)
    }

    var body: some View {
        Section(fruitiere.deskName) {
            LabeledContent("Cheesemaker", value: fruitiere.cheesemakerName)
            LabeledContent("To one", value: roll?.isToOneRelationship == true ? "Yes" : "No")
            LabeledContent("Maximum", value: countText(roll?.maximumModelCount))
            LabeledContent("Notes on the roll", value: "\(fruitiere.notes.count)")
        }

        Section("Deliveries") {
            ForEach(fruitiere.notes, id: \.persistentModelID) { note in
                LabeledContent(note.farmName, value: "\(note.litres) litres, \(note.fruitiere?.deskName ?? "unlinked")")
            }
        }

        Section {
            Text("The member book keeps Pellier on the coop and Gaillard as this morning's guest.")
                .foregroundStyle(.secondary)
        }
    }

    private func countText(_ count: Int?) -> String {
        guard let count else { return "None" }
        return "\(count)"
    }
}
