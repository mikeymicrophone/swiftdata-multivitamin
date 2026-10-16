// Feature: Relationships
// Slot 01 — Plasne milk note
// Teaches:
// - An optional to-one can be absent.
// - Naming the fruitière puts this note on its roll.

import SwiftData
import SwiftUI

@Model
final class MilkNote {
    var farmName: String
    var farmerName: String
    var litres: Int
    var notedOn: Date
    var fruitiere: Fruitiere?

    init(
        farmName: String,
        farmerName: String,
        litres: Int,
        notedOn: Date,
        fruitiere: Fruitiere? = nil
    ) {
        self.farmName = farmName
        self.farmerName = farmerName
        self.litres = litres
        self.notedOn = notedOn
        self.fruitiere = fruitiere
    }
}

@Model
final class Fruitiere {
    var deskName: String
    var cheesemakerName: String
    // Omitting the counts stores maximumModelCount 0. The roll still accepts every note.
    @Relationship(inverse: \MilkNote.fruitiere)
    var notes: [MilkNote] = []

    init(deskName: String, cheesemakerName: String) {
        self.deskName = deskName
        self.cheesemakerName = cheesemakerName
    }
}

struct MilkNoteScreen: View {
    private let container = MemoryStore.containerOrCrash(MilkNote.self, Fruitiere.self)

    var body: some View {
        MilkNoteEditor()
            .modelContainer(container)
    }
}

private struct MilkNoteEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var note: MilkNote?
    @State private var fruitiere: Fruitiere?
    @State private var named = false

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 01",
            title: "Plasne milk note",
            situation: "On 2 September Hélène Pellier writes the morning milk at Ferme Pellier. The fruitière line is still blank. Lucien Morel's desk is open across the plateau.",
            teaches: [
                "An optional to-one can be absent.",
                "Naming the fruitière puts this note on its roll."
            ]
        ) {
            if let note {
                NoteFields(note: note, schema: modelContext.container.schema)
                if !named {
                    Button("Name the fruitière") {
                        note.fruitiere = fruitiere
                        named = true
                    }
                }
            } else {
                Button("Write the milk note") {
                    writeNote()
                }
            }
        }
    }

    private func writeNote() {
        let fruitiere = Fruitiere(
            deskName: "Fruitière du Plateau de Plasne",
            cheesemakerName: "Lucien Morel"
        )
        let note = MilkNote(
            farmName: "Ferme Pellier, Plasne",
            farmerName: "Hélène Pellier",
            litres: 86,
            notedOn: GregorianDay.date(year: 2026, month: 9, day: 2, timeZoneIdentifier: "Europe/Paris")
        )
        modelContext.insert(fruitiere)
        modelContext.insert(note)
        self.fruitiere = fruitiere
        self.note = note
    }
}

private struct NoteFields: View {
    let note: MilkNote
    let schema: Schema

    private var link: Schema.Relationship? {
        StoredRelationship.named("fruitiere", on: "MilkNote", in: schema)
    }

    var body: some View {
        Section(note.farmName) {
            LabeledContent("Farmer", value: note.farmerName)
            LabeledContent("Litres", value: "\(note.litres)")
            LabeledContent("Fruitière", value: note.fruitiere?.deskName ?? "Not named")
            LabeledContent("To one", value: link?.isToOneRelationship == true ? "Yes" : "No")
            LabeledContent("Destination", value: link?.destination ?? "Missing")
            LabeledContent("Inverse", value: link?.inverseName ?? "None")
        }

        if let fruitiere = note.fruitiere {
            Section(fruitiere.deskName) {
                Text("\(fruitiere.cheesemakerName) has \(fruitiere.notes.count) note on the roll.")
            }
        }

        Section {
            Text("Lucien posts Pellier and Gaillard together on the morning roll.")
                .foregroundStyle(.secondary)
        }
    }
}
