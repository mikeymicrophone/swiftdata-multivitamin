// Feature: @Model basics
// Slot 11 — Vera District shelf card
// Teaches:
// - A model is a class.
// - Assigning a property edits that record in place.

import SwiftData
import SwiftUI

@Model
final class ShelfCard {
    var shopName: String
    var sellerName: String
    var studyTitle: String
    var askingPriceLari: Int

    init(shopName: String, sellerName: String, studyTitle: String, askingPriceLari: Int) {
        self.shopName = shopName
        self.sellerName = sellerName
        self.studyTitle = studyTitle
        self.askingPriceLari = askingPriceLari
    }
}

struct ShelfCardScreen: View {
    private let container = MemoryStore.containerOrCrash(ShelfCard.self)

    var body: some View {
        ShelfCardEditor()
            .modelContainer(container)
    }
}

private struct ShelfCardEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var card: ShelfCard?

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 11",
            title: "Vera District shelf card",
            situation: "Luka Katsitadze puts an overrun impression on the counter at 85 lari. When the warmer black is confirmed, he changes that same card to 90.",
            teaches: [
                "A model is a class.",
                "Assigning a property edits that record in place."
            ]
        ) {
            if let card {
                ShelfFields(card: card)
            } else {
                Button("Put the card on the counter") {
                    putCardOnCounter()
                }
            }
        }
    }

    private func putCardOnCounter() {
        let card = ShelfCard(
            shopName: "Vera District Print Room",
            sellerName: "Luka Katsitadze",
            studyTitle: "Quince branch, Vera courtyard",
            askingPriceLari: 85
        )
        modelContext.insert(card)
        self.card = card
    }
}

private struct ShelfFields: View {
    @Bindable var card: ShelfCard

    var body: some View {
        Section(card.shopName) {
            LabeledContent("Seller", value: card.sellerName)
            LabeledContent("Study", value: card.studyTitle)
            Stepper(value: $card.askingPriceLari, in: 40...200) {
                Text("Asking price: \(card.askingPriceLari) lari")
            }
        }

        Section("Counter copy") {
            Text("The counter copy of \(card.studyTitle) says \(card.askingPriceLari) lari.")
        }
    }
}
