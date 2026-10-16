// Feature: @Model basics
// Slot 12 — Albertina bench slip
// Teaches:
// - insert registers the instance you already hold.
// - The slip on the bench and the registered model are the same object.

import SwiftData
import SwiftUI

@Model
final class BenchSlip {
    var roomName: String
    var conservatorName: String
    var impressionMark: String
    var benchNote: String

    init(roomName: String, conservatorName: String, impressionMark: String, benchNote: String) {
        self.roomName = roomName
        self.conservatorName = conservatorName
        self.impressionMark = impressionMark
        self.benchNote = benchNote
    }
}

struct BenchSlipScreen: View {
    private let container = MemoryStore.containerOrCrash(BenchSlip.self)

    var body: some View {
        BenchSlipEditor()
            .modelContainer(container)
    }
}

private struct BenchSlipEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var slip: BenchSlip?

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 12",
            title: "Albertina bench slip",
            situation: "Elif Berger receives impression AP 2/6 at the Albertina study room. She writes the slip in her hand, then registers that same slip.",
            teaches: [
                "insert registers the instance you already hold.",
                "The slip on the bench and the registered model are the same object."
            ]
        ) {
            if let slip {
                Section(slip.roomName) {
                    LabeledContent("Conservator", value: slip.conservatorName)
                    LabeledContent("Impression", value: slip.impressionMark)
                    LabeledContent("Bench note", value: slip.benchNote)
                    LabeledContent(
                        "Context",
                        value: modelContext.hasChanges ? "Registered, not yet saved" : "Registered"
                    )
                }
            } else {
                Button("Register the impression") {
                    registerImpression()
                }
            }
        }
        .onAppear {
            modelContext.autosaveEnabled = false
        }
    }

    private func registerImpression() {
        let slip = BenchSlip(
            roomName: "Albertina study room",
            conservatorName: "Elif Berger",
            impressionMark: "AP 2/6",
            benchNote: "Foxing check clear along the deckle"
        )
        modelContext.insert(slip)
        self.slip = slip
    }
}
