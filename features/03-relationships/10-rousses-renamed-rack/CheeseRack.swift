// Feature: Relationships
// Slot 10 — Rousses renamed rack
// Teaches:
// - originalName on the relationship keeps the previous name.
// - The inverse stores its own name. A relationship that omits originalName stores an empty one.

import SwiftData
import SwiftUI

@Model
final class ShelfLabel {
    var line: String
    var wheel: RackWheel?

    init(line: String) {
        self.line = line
    }
}

@Model
final class RackWheel {
    var code: String
    // This inverse does not carry @Relationship, so its originalName is the property name.
    var rack: CheeseRack?
    @Relationship(inverse: \ShelfLabel.wheel)
    var label: ShelfLabel?

    init(code: String) {
        self.code = code
    }
}

@Model
final class CheeseRack {
    var rackName: String
    var affineurName: String
    @Relationship(originalName: "meules", inverse: \RackWheel.rack)
    var wheels: [RackWheel] = []

    init(rackName: String, affineurName: String) {
        self.rackName = rackName
        self.affineurName = affineurName
    }
}

struct CheeseRackScreen: View {
    var body: some View {
        CheeseRackEditor()
            .inMemoryStore(for: CheeseRack.self, RackWheel.self, ShelfLabel.self)
    }
}

private struct CheeseRackEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var rack: CheeseRack?

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 10",
            title: "Rousses renamed rack",
            situation: "On 10 September Claire Roux reprints the cave book. The rack list that was meules is now wheels. PL-19 still names its rack, and its shelf label has no previous name.",
            teaches: [
                "originalName on the relationship keeps the previous name.",
                "The inverse stores its own name. A relationship that omits originalName stores an empty one."
            ]
        ) {
            if let rack {
                RackFields(rack: rack, schema: modelContext.container.schema)
            } else {
                Button("Reprint the rack") {
                    reprint()
                }
            }
        }
    }

    private func reprint() {
        let rack = CheeseRack(rackName: "Cave jeune, Les Rousses", affineurName: "Claire Roux")
        let wheel = RackWheel(code: "PL-19")
        let label = ShelfLabel(line: "PL-19, young rack")
        modelContext.insert(rack)
        modelContext.insert(wheel)
        modelContext.insert(label)
        rack.wheels.append(wheel)
        wheel.label = label
        self.rack = rack
    }
}

private struct RackFields: View {
    let rack: CheeseRack
    let schema: Schema

    var body: some View {
        Section(rack.rackName) {
            LabeledContent("Affineur", value: rack.affineurName)
            LabeledContent("Wheels, previously", value: originalName("wheels", on: "CheeseRack"))
            LabeledContent("Wheel's rack name", value: originalName("rack", on: "RackWheel"))
            LabeledContent("Label's original name", value: originalName("label", on: "RackWheel"))
        }

        Section {
            Text("The fruitière reprints the guest book with a hash on the guest list.")
                .foregroundStyle(.secondary)
        }
    }

    private func originalName(_ name: String, on typeName: String) -> String {
        let original = StoredRelationship.named(name, on: typeName, in: schema)?.originalName ?? ""
        return original.isEmpty ? "Empty" : original
    }
}
