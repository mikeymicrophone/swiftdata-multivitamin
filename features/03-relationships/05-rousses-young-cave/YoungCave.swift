// Feature: Relationships
// Slot 05 — Rousses young cave
// Teaches:
// - Appending the wheel sets its cave.
// - Taking a wheel off the rack clears that link and leaves the wheel in the store.

import SwiftData
import SwiftUI

@Model
final class CaveWheel {
    var code: String
    var cave: AgingCave?

    init(code: String, cave: AgingCave? = nil) {
        self.code = code
        self.cave = cave
    }
}

@Model
final class AgingCave {
    var caveName: String
    var affineurName: String
    @Relationship(inverse: \CaveWheel.cave)
    var wheels: [CaveWheel] = []

    init(caveName: String, affineurName: String) {
        self.caveName = caveName
        self.affineurName = affineurName
    }
}

struct YoungCaveScreen: View {
    private let container = MemoryStore.containerOrCrash(CaveWheel.self, AgingCave.self)

    var body: some View {
        YoungCaveEditor()
            .modelContainer(container)
    }
}

private struct YoungCaveEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cave: AgingCave?
    @State private var kept: CaveWheel?
    @State private var cracked: CaveWheel?

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 05",
            title: "Rousses young cave",
            situation: "On 4 September Claire Roux puts PL-19 on the young rack at Les Rousses and takes cracked PL-03 off it. PL-03 stays in the cave office.",
            teaches: [
                "Appending the wheel sets its cave.",
                "Taking a wheel off the rack clears that link and leaves the wheel in the store."
            ]
        ) {
            if let cave, let kept, let cracked {
                CaveFields(cave: cave, kept: kept, cracked: cracked)
            } else {
                Button("Set the young rack") {
                    setRack()
                }
            }
        }
    }

    private func setRack() {
        let cave = AgingCave(caveName: "Cave jeune, Les Rousses", affineurName: "Claire Roux")
        let kept = CaveWheel(code: "PL-19")
        let cracked = CaveWheel(code: "PL-03")
        modelContext.insert(cave)
        modelContext.insert(kept)
        modelContext.insert(cracked)
        cave.wheels.append(kept)
        cave.wheels.append(cracked)
        cave.wheels.removeAll { $0.code == "PL-03" }
        self.cave = cave
        self.kept = kept
        self.cracked = cracked
    }
}

private struct CaveFields: View {
    let cave: AgingCave
    let kept: CaveWheel
    let cracked: CaveWheel

    var body: some View {
        Section(cave.caveName) {
            LabeledContent("Affineur", value: cave.affineurName)
            LabeledContent("On the rack", value: cave.wheels.map(\.code).joined(separator: ", "))
        }

        Section(kept.code) {
            LabeledContent("Cave", value: kept.cave?.caveName ?? "None")
        }

        Section(cracked.code) {
            LabeledContent("Cave", value: cracked.cave?.caveName ?? "None")
            LabeledContent("Still in the office", value: cracked.code)
        }

        Section {
            Text("Marc Bouvet in Champagnole sends the spruce boards the wheel will rest on.")
                .foregroundStyle(.secondary)
        }
    }
}
