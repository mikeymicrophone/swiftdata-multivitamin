// Feature: Codable and enums
// Slot 09 — Oaxaca label proof
// Teaches:
// - CodingKeys translates an external label document before insertion.
// - The decoded Codable value is stored directly; its wire keys are a JSON concern.

import Foundation
import SwiftData
import SwiftUI

struct BottleLabel: Codable, Equatable {
    var lotCode: String
    var alcoholPercent: Double
    var bottleMillilitres: Int

    enum CodingKeys: String, CodingKey {
        case lotCode = "lote"
        case alcoholPercent = "alc_vol"
        case bottleMillilitres = "contenido_ml"
    }
}

@Model
final class LabelProof {
    var printerName: String
    var label: BottleLabel

    init(printerName: String, label: BottleLabel) {
        self.printerName = printerName
        self.label = label
    }

    static func importProof(_ document: Data, printerName: String) throws -> LabelProof {
        let label = try JSONDecoder().decode(BottleLabel.self, from: document)
        return LabelProof(printerName: printerName, label: label)
    }
}

struct LabelProofScreen: View {
    var body: some View {
        LabelProofDesk().inMemoryStore(for: LabelProof.self)
    }
}

private struct LabelProofDesk: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LabelProof.printerName) private var proofs: [LabelProof]
    @State private var receipt = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("On 21 March Imprenta del Nopal in Oaxaca de Juárez sends Elena a Spanish-keyed proof for SC-26: 47% ABV, 700 ml.")
                .foregroundStyle(.secondary)
            Table(proofs) {
                TableColumn("Printer", value: \.printerName)
                TableColumn("Lot") { Text($0.label.lotCode) }
                TableColumn("ABV") { Text($0.label.alcoholPercent, format: .number) }
                TableColumn("Millilitres") { Text("\($0.label.bottleMillilitres)") }
            }
            Button("Read the Nopal proof") {
                guard proofs.isEmpty else { return }
                let document = Data(#"{"lote":"SC-26","alc_vol":47,"contenido_ml":700}"#.utf8)
                do {
                    let proof = try LabelProof.importProof(document, printerName: "Imprenta del Nopal")
                    modelContext.insert(proof)
                    try modelContext.save()
                    receipt = try modelContext.freshFirst(LabelProof.self)?.label.lotCode ?? "No proof"
                } catch { receipt = error.localizedDescription }
            }
            Text(receipt)
            Text("Teaches: CodingKeys at import; a decoded Codable value stored directly on the proof.")
                .font(.callout).foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Oaxaca label proof")
    }
}
