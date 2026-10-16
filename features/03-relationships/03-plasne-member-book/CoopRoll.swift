// Feature: Relationships
// Slot 03 — Plasne member book
// Teaches:
// - Two relationships to one type need an explicit inverse each.
// - A member link and a guest link do not cross.

import SwiftData
import SwiftUI

@Model
final class CoopHand {
    var handName: String
    var farmName: String
    var membership: CoopRoll?
    var visit: CoopRoll?

    init(handName: String, farmName: String) {
        self.handName = handName
        self.farmName = farmName
    }
}

@Model
final class CoopRoll {
    var deskName: String
    @Relationship(inverse: \CoopHand.membership)
    var members: [CoopHand] = []
    // The guest-book hash is read on the reprint screen.
    @Relationship(inverse: \CoopHand.visit, hashModifier: "guest-book-2026")
    var guests: [CoopHand] = []

    init(deskName: String) {
        self.deskName = deskName
    }
}

struct CoopRollScreen: View {
    var body: some View {
        CoopRollEditor()
            .inMemoryStore(for: CoopRoll.self, CoopHand.self)
    }
}

private struct CoopRollEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var roll: CoopRoll?
    @State private var member: CoopHand?
    @State private var guest: CoopHand?

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 03",
            title: "Plasne member book",
            situation: "Lucien Morel opens the member book beside the milk roll. Hélène Pellier is a member of the fruitière. Antoine Gaillard is delivering as a guest.",
            teaches: [
                "Two relationships to one type need an explicit inverse each.",
                "A member link and a guest link do not cross."
            ]
        ) {
            if let roll, let member, let guest {
                MemberFields(roll: roll, member: member, guest: guest, schema: modelContext.container.schema)
            } else {
                Button("Enter the member book") {
                    enterBook()
                }
            }
        }
    }

    private func enterBook() {
        let roll = CoopRoll(deskName: "Fruitière du Plateau de Plasne")
        let member = CoopHand(handName: "Hélène Pellier", farmName: "Ferme Pellier, Plasne")
        let guest = CoopHand(handName: "Antoine Gaillard", farmName: "Ferme Gaillard, Le Fied")
        modelContext.insert(roll)
        modelContext.insert(member)
        modelContext.insert(guest)
        roll.members.append(member)
        roll.guests.append(guest)
        self.roll = roll
        self.member = member
        self.guest = guest
    }
}

private struct MemberFields: View {
    let roll: CoopRoll
    let member: CoopHand
    let guest: CoopHand
    let schema: Schema

    var body: some View {
        Section(roll.deskName) {
            LabeledContent("Members inverse", value: inverseName("members"))
            LabeledContent("Guests inverse", value: inverseName("guests"))
        }

        Section(member.handName) {
            LabeledContent("Membership", value: member.membership?.deskName ?? "None")
            LabeledContent("Visit", value: member.visit?.deskName ?? "None")
        }

        Section(guest.handName) {
            LabeledContent("Membership", value: guest.membership?.deskName ?? "None")
            LabeledContent("Visit", value: guest.visit?.deskName ?? "None")
        }

        Section {
            Text("The pooled milk goes into the morning vat as wheel PL-19.")
                .foregroundStyle(.secondary)
        }
    }

    private func inverseName(_ name: String) -> String {
        StoredRelationship.named(name, on: "CoopRoll", in: schema)?.inverseName ?? "None"
    }
}
