// Feature: @Model basics
// Slot 10 — Fabriano mill schema
// Teaches:
// - @Model makes a class eligible for a store.
// - The schema lists the types that store actually holds.

import SwiftData
import SwiftUI

@Model
final class RagLot {
    var lotCode: String
    var ragDescription: String
    var sheetCount: Int

    init(lotCode: String, ragDescription: String, sheetCount: Int) {
        self.lotCode = lotCode
        self.ragDescription = ragDescription
        self.sheetCount = sheetCount
    }
}

@Model
final class DeckleProof {
    var proofCode: String
    var deckleNote: String

    init(proofCode: String, deckleNote: String) {
        self.proofCode = proofCode
        self.deckleNote = deckleNote
    }
}

enum FioravantiMillBook {
    static let schema = Schema([RagLot.self, DeckleProof.self])
}

struct FioravantiMillBookScreen: View {
    var body: some View {
        FioravantiMillBookEditor()
            .inMemoryStore(for: [RagLot.self, DeckleProof.self])
    }
}

private struct FioravantiMillBookEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var lot: RagLot?
    @State private var proof: DeckleProof?

    private var entityNames: [String] {
        modelContext.container.schema.entities.map(\.name).sorted()
    }

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 10",
            title: "Fabriano mill schema",
            situation: "Paolo Fioravanti opens the mill book on 16 March. It keeps rag lots and deckle proofs. Tbilisi's commission is a model class, and this book does not hold it.",
            teaches: [
                "@Model makes a class eligible for a store.",
                "The schema lists the types that store actually holds."
            ]
        ) {
            if let lot, let proof {
                Section(lot.lotCode) {
                    LabeledContent("Rag", value: lot.ragDescription)
                    LabeledContent("Sheets", value: "\(lot.sheetCount)")
                }

                Section(proof.proofCode) {
                    LabeledContent("Deckle", value: proof.deckleNote)
                }

                Section("Books in this store") {
                    ForEach(entityNames, id: \.self) { name in
                        Text(name)
                    }
                }
            } else {
                Button("Open the mill book") {
                    openBook()
                }
            }
        }
    }

    private func openBook() {
        let lot = RagLot(
            lotCode: "FA-80",
            ragDescription: "Cotton offcuts from the Prato mills",
            sheetCount: 80
        )
        let proof = DeckleProof(
            proofCode: "FA-80-D",
            deckleNote: "Feathered edge, four sides"
        )
        modelContext.insert(lot)
        modelContext.insert(proof)
        self.lot = lot
        self.proof = proof
    }
}
