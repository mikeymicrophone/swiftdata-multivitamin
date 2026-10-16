// Feature: Relationships
// Slot 12 — Rousses aged cave
// Teaches:
// - Pointing the wheel at the aged cave takes it off the young rack.
// - The wheel keeps its identity.

import SwiftData
import SwiftUI

struct AgedCaveScreen: View {
    var body: some View {
        AgedCaveEditor()
            .inMemoryStore(for: CaveWheel.self, AgingCave.self)
    }
}

private struct AgedCaveEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var young: AgingCave?
    @State private var aged: AgingCave?
    @State private var wheel: CaveWheel?
    @State private var identity = ""
    @State private var moved = false

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 12",
            title: "Rousses aged cave",
            situation: "On 12 September Claire Roux moves PL-19 from the young cave to the aging cave. It is the same wheel.",
            teaches: [
                "Pointing the wheel at the aged cave takes it off the young rack.",
                "The wheel keeps its identity."
            ]
        ) {
            if let young, let aged, let wheel {
                MoveFields(young: young, aged: aged, wheel: wheel, identity: identity, moved: moved)
                if !moved {
                    Button("Move PL-19 to the aged cave") {
                        wheel.cave = aged
                        moved = true
                    }
                }
            } else {
                Button("Rack PL-19 in the young cave") {
                    rackYoung()
                }
            }
        }
    }

    private func rackYoung() {
        let young = AgingCave(caveName: "Cave jeune, Les Rousses", affineurName: "Claire Roux")
        let aged = AgingCave(caveName: "Cave d'affinage, Les Rousses", affineurName: "Claire Roux")
        let wheel = CaveWheel(code: "PL-19")
        modelContext.insert(young)
        modelContext.insert(aged)
        modelContext.insert(wheel)
        young.wheels.append(wheel)
        try? modelContext.save()
        identity = String(describing: wheel.persistentModelID)
        self.young = young
        self.aged = aged
        self.wheel = wheel
    }
}

private struct MoveFields: View {
    let young: AgingCave
    let aged: AgingCave
    let wheel: CaveWheel
    let identity: String
    let moved: Bool

    private var sameWheel: Bool {
        String(describing: wheel.persistentModelID) == identity
    }

    var body: some View {
        Section(wheel.code) {
            LabeledContent("Cave", value: wheel.cave?.caveName ?? "None")
            LabeledContent("Identity", value: sameWheel ? "Same wheel" : "Different wheel")
        }

        Section(young.caveName) {
            Text(young.wheels.map(\.code).joined(separator: ", ").isEmpty ? "Empty" : young.wheels.map(\.code).joined(separator: ", "))
        }

        if moved {
            Section(aged.caveName) {
                Text(aged.wheels.map(\.code).joined(separator: ", "))
            }
        }

        Section {
            Text("On 14 September Chantal Vercel lays these slips on the Besançon counter.")
                .foregroundStyle(.secondary)
        }
    }
}
