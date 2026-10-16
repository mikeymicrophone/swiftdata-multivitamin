// Feature: @Model basics
// Slot 09 — Barcelona two grinds
// Teaches:
// - Two instances of one class are two records.
// - Editing one instance leaves the other alone.

import SwiftData
import SwiftUI

@Model
final class GrindEntry {
    var batchCode: String
    var pigmentName: String
    var grindPasses: Int
    var millerName: String

    init(batchCode: String, pigmentName: String, grindPasses: Int, millerName: String) {
        self.batchCode = batchCode
        self.pigmentName = pigmentName
        self.grindPasses = grindPasses
        self.millerName = millerName
    }
}

struct GrindEntryScreen: View {
    private let container = MemoryStore.containerOrCrash(GrindEntry.self)

    var body: some View {
        GrindEntryEditor()
            .modelContainer(container)
    }
}

private struct GrindEntryEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var first: GrindEntry?
    @State private var second: GrindEntry?

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 09",
            title: "Barcelona two grinds",
            situation: "Nino asked for a warmer black after the briefing. Joana Puig logs two grind lines on 15 March. The first line stays the cool black.",
            teaches: [
                "Two instances of one class are two records.",
                "Editing one instance leaves the other alone."
            ]
        ) {
            if let first, let second {
                GrindFields(first: first, second: second)
            } else {
                Button("Log both grinds") {
                    logGrinds()
                }
            }
        }
    }

    private func logGrinds() {
        let first = GrindEntry(
            batchCode: "BP-19-A",
            pigmentName: "bone black",
            grindPasses: 4,
            millerName: "Joana Puig"
        )
        let second = GrindEntry(
            batchCode: "BP-19-B",
            pigmentName: "bone black with burnt sienna",
            grindPasses: 2,
            millerName: "Joana Puig"
        )
        modelContext.insert(first)
        modelContext.insert(second)
        self.first = first
        self.second = second
    }
}

private struct GrindFields: View {
    let first: GrindEntry
    @Bindable var second: GrindEntry

    var body: some View {
        Section(first.batchCode) {
            LabeledContent("Pigment", value: first.pigmentName)
            LabeledContent("Passes", value: "\(first.grindPasses)")
            LabeledContent("Miller", value: first.millerName)
        }

        Section(second.batchCode) {
            LabeledContent("Pigment", value: second.pigmentName)
            Stepper(value: $second.grindPasses, in: 1...12) {
                Text("Passes: \(second.grindPasses)")
            }
            LabeledContent("Miller", value: second.millerName)
        }

        Section {
            Text("The \(first.batchCode) line still reads \(first.grindPasses) passes of \(first.pigmentName).")
                .foregroundStyle(.secondary)
        }
    }
}
