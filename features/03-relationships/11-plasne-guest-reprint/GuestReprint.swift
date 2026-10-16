// Feature: Relationships
// Slot 11 — Plasne guest reprint
// Teaches:
// - hashModifier is stored on the relationship that sets it.
// - The member list and the inverse visit leave it nil.

import SwiftData
import SwiftUI

struct GuestReprintScreen: View {
    private let container = MemoryStore.containerOrCrash(CoopRoll.self, CoopHand.self)

    var body: some View {
        GuestReprintEditor()
            .modelContainer(container)
    }
}

private struct GuestReprintEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var roll: CoopRoll?

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 11",
            title: "Plasne guest reprint",
            situation: "On 11 September Lucien Morel reprints the guest book. Gaillard is still the guest. The reprint marks the guest list and leaves the member list alone.",
            teaches: [
                "hashModifier is stored on the relationship that sets it.",
                "The member list and the inverse visit leave it nil."
            ]
        ) {
            if let roll {
                ReprintFields(roll: roll, schema: modelContext.container.schema)
            } else {
                Button("Reprint the guest book") {
                    reprint()
                }
            }
        }
    }

    private func reprint() {
        let roll = CoopRoll(deskName: "Fruitière du Plateau de Plasne")
        let member = CoopHand(handName: "Hélène Pellier", farmName: "Ferme Pellier, Plasne")
        let guest = CoopHand(handName: "Antoine Gaillard", farmName: "Ferme Gaillard, Le Fied")
        modelContext.insert(roll)
        modelContext.insert(member)
        modelContext.insert(guest)
        roll.members.append(member)
        roll.guests.append(guest)
        self.roll = roll
    }
}

private struct ReprintFields: View {
    let roll: CoopRoll
    let schema: Schema

    var body: some View {
        Section(roll.deskName) {
            LabeledContent("Guest hash", value: hashText("guests", on: "CoopRoll"))
            LabeledContent("Member hash", value: hashText("members", on: "CoopRoll"))
            LabeledContent("Visit hash", value: hashText("visit", on: "CoopHand"))
            LabeledContent("Guests", value: roll.guests.map(\.handName).joined(separator: ", "))
        }

        Section {
            Text("Claire moves PL-19 from the young cave to the aging cave.")
                .foregroundStyle(.secondary)
        }
    }

    private func hashText(_ name: String, on typeName: String) -> String {
        StoredRelationship.named(name, on: typeName, in: schema)?.hashModifier ?? "None"
    }
}
