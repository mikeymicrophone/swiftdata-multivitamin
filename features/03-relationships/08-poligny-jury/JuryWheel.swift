// Feature: Relationships
// Slot 08 — Poligny jury
// Teaches:
// - A taster and a wheel are a many-to-many.
// - Linking from either side fills the other side.

import SwiftData
import SwiftUI

@Model
final class JuryWheel {
    var code: String
    var tasters: [JuryTaster] = []

    init(code: String) {
        self.code = code
    }
}

@Model
final class JuryTaster {
    var tasterName: String
    @Relationship(inverse: \JuryWheel.tasters)
    var wheels: [JuryWheel] = []

    init(tasterName: String) {
        self.tasterName = tasterName
    }
}

struct JuryWheelScreen: View {
    private let container = MemoryStore.containerOrCrash(JuryWheel.self, JuryTaster.self)

    var body: some View {
        JuryWheelEditor()
            .modelContainer(container)
    }
}

private struct JuryWheelEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var wheel: JuryWheel?
    @State private var ines: JuryTaster?
    @State private var paul: JuryTaster?

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 08",
            title: "Poligny jury",
            situation: "On 8 September Inès Garnier and Paul Besnard taste wheel PL-19 at the Maison du Comté in Poligny. Each taster has many wheels. Each wheel has many tasters.",
            teaches: [
                "A taster and a wheel are a many-to-many.",
                "Linking from either side fills the other side."
            ]
        ) {
            if let wheel, let ines, let paul {
                JuryFields(wheel: wheel, ines: ines, paul: paul, schema: modelContext.container.schema)
            } else {
                Button("Seat the jury") {
                    seatJury()
                }
            }
        }
    }

    private func seatJury() {
        let wheel = JuryWheel(code: "PL-19")
        let ines = JuryTaster(tasterName: "Inès Garnier")
        let paul = JuryTaster(tasterName: "Paul Besnard")
        modelContext.insert(wheel)
        modelContext.insert(ines)
        modelContext.insert(paul)
        wheel.tasters.append(ines)
        paul.wheels.append(wheel)
        self.wheel = wheel
        self.ines = ines
        self.paul = paul
    }
}

private struct JuryFields: View {
    let wheel: JuryWheel
    let ines: JuryTaster
    let paul: JuryTaster
    let schema: Schema

    private var wheelsLink: Schema.Relationship? {
        StoredRelationship.named("wheels", on: "JuryTaster", in: schema)
    }

    private var tastersLink: Schema.Relationship? {
        StoredRelationship.named("tasters", on: "JuryWheel", in: schema)
    }

    var body: some View {
        Section("Maison du Comté, Poligny") {
            LabeledContent("Tasters to one", value: tastersLink?.isToOneRelationship == true ? "Yes" : "No")
            LabeledContent("Wheels to one", value: wheelsLink?.isToOneRelationship == true ? "Yes" : "No")
        }

        Section(wheel.code) {
            Text(wheel.tasters.map(\.tasterName).sorted().joined(separator: ", "))
        }

        Section(ines.tasterName) {
            Text(ines.wheels.map(\.code).joined(separator: ", "))
        }

        Section(paul.tasterName) {
            Text(paul.wheels.map(\.code).joined(separator: ", "))
        }

        Section {
            Text("Inès writes the tasting slip the next morning.")
                .foregroundStyle(.secondary)
        }
    }
}
