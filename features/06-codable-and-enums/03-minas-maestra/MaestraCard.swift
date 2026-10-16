// Feature: Codable and enums
// Slot 03 — Minas maestra
// Teaches:
// - Codable values can nest other Codable structs.
// - A sorted @Query reads the producer snapshot stored on each card.

import SwiftData
import SwiftUI

struct PalenqueAddress: Codable, Equatable {
    var village: String
    var district: String
}

struct MaestraSignature: Codable, Equatable {
    var fullName: String
    var palenqueName: String
    var address: PalenqueAddress
}

@Model
final class MaestraCard {
    var lotCode: String
    var signature: MaestraSignature

    init(lotCode: String, signature: MaestraSignature) {
        self.lotCode = lotCode
        self.signature = signature
    }
}

struct MaestraCardScreen: View {
    var body: some View {
        MaestraBook().inMemoryStore(for: MaestraCard.self)
    }
}

private struct MaestraBook: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\MaestraCard.lotCode)]) private var cards: [MaestraCard]
    @State private var receipt = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 03",
            title: "Minas maestra",
            situation: "On 6 March Lucía signs SC-26 before the roasted agave reaches the wooden fermentation tina. Her palenque address travels with the signature.",
            teaches: [
                "Codable values can nest other Codable structs.",
                "A sorted @Query reads the producer snapshot stored on each card."
            ]
        ) {
            ForEach(cards) { card in
                Section(card.lotCode) {
                    LabeledContent("Maestra", value: card.signature.fullName)
                    LabeledContent("Palenque", value: card.signature.palenqueName)
                    Text("\(card.signature.address.village), \(card.signature.address.district)")
                }
            }
            Button("Sign the fermentation book") {
                guard cards.isEmpty else { return }
                let address = PalenqueAddress(village: "Santa Catarina Minas", district: "Ocotlán")
                let signature = MaestraSignature(fullName: "Lucía Hernández", palenqueName: "Palenque del Guayabo", address: address)
                modelContext.insert(MaestraCard(lotCode: "SC-26", signature: signature))
                do {
                    try modelContext.save()
                    receipt = try modelContext.freshFirst(MaestraCard.self)?.signature.address.village ?? "No signature"
                } catch { receipt = error.localizedDescription }
            }
            Text(receipt).foregroundStyle(.secondary)
        }
    }
}
