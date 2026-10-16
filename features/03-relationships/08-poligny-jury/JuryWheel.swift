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
    // The inverse is declared here, on the wheel. The taster's list needs no macro.
    @Relationship(inverse: \JuryTaster.wheels)
    var tasters: [JuryTaster] = []

    init(code: String) {
        self.code = code
    }
}

@Model
final class JuryTaster {
    var tasterName: String
    var wheels: [JuryWheel] = []

    init(tasterName: String) {
        self.tasterName = tasterName
    }
}

struct JuryWheelScreen: View {
    var body: some View {
        JuryWheelEditor()
            .inMemoryStore(for: JuryWheel.self, JuryTaster.self)
    }
}

private struct JuryWheelEditor: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\JuryTaster.tasterName, comparator: .localizedStandard)])
    private var tasters: [JuryTaster]
    @State private var chosenTaster = ""

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
            if tasters.isEmpty {
                Button("Seat the jury", action: seatJury)
            } else {
                Section("Maison du Comté, Poligny") {
                    LabeledContent("Tasters to one", value: isToOne("tasters", on: "JuryWheel") ? "Yes" : "No")
                    LabeledContent("Wheels to one", value: isToOne("wheels", on: "JuryTaster") ? "Yes" : "No")
                    Picker("Taster", selection: $chosenTaster) {
                        ForEach(tasters) { taster in
                            Text(taster.tasterName).tag(taster.tasterName)
                        }
                    }
                }
                WheelsTasted(by: chosenTaster)
            }
            Section {
                Text("Inès writes the tasting slip the next morning.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func isToOne(_ name: String, on typeName: String) -> Bool {
        StoredRelationship.named(name, on: typeName, in: modelContext.container.schema)?.isToOneRelationship == true
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
        try? modelContext.save()
        chosenTaster = ines.tasterName
    }
}

/// A query built per taster: the predicate walks the to-many from the wheel's side.
private struct WheelsTasted: View {
    let tasterName: String
    @Query private var wheels: [JuryWheel]

    init(by tasterName: String) {
        self.tasterName = tasterName
        _wheels = Query(
            filter: #Predicate<JuryWheel> { wheel in
                wheel.tasters.contains { taster in taster.tasterName == tasterName }
            },
            sort: \.code
        )
    }

    var body: some View {
        Section("Wheels tasted by \(tasterName)") {
            ForEach(wheels) { wheel in
                LabeledContent(wheel.code) {
                    Text(wheel.tasters.map(\.tasterName).sorted(), format: .list(type: .and))
                }
            }
        }
    }
}
