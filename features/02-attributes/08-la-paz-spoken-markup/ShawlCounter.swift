// Feature: Attributes
// Slot 08 — La Paz spoken markup
// Teaches:
// - @Attribute(.ephemeral) is omitted from the filed row.
// - The attribute is not reported as transient.

import SwiftData
import SwiftUI

@Model
final class ShawlCounter {
    var shopName: String
    var sellerName: String
    var askingBolivianos: Int
    @Attribute(.ephemeral) var spokenMarkup: String = ""
    var openedOn: Date

    init(shopName: String, sellerName: String, askingBolivianos: Int, spokenMarkup: String = "", openedOn: Date) {
        self.shopName = shopName
        self.sellerName = sellerName
        self.askingBolivianos = askingBolivianos
        self.spokenMarkup = spokenMarkup
        self.openedOn = openedOn
    }
}

struct ShawlCounterScreen: View {
    var body: some View {
        ShawlCounterEditor()
            .inMemoryStore(for: ShawlCounter.self)
    }
}

private struct ShawlCounterEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var card: ShawlCounter?
    @State private var filedPrice: Int?
    @State private var filedMarkup = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 08",
            title: "La Paz spoken markup",
            situation: "On 18 June Mariela Rojas puts the shawl on the counter at Casa Rojas. She says to add forty bolivianos. That sentence is ephemeral. The asking price is the filed number.",
            teaches: [
                "@Attribute(.ephemeral) is omitted from the filed row.",
                "The attribute is not reported as transient."
            ]
        ) {
            if let card {
                CounterFields(
                    card: card,
                    schema: modelContext.container.schema,
                    filedPrice: filedPrice,
                    filedMarkup: filedMarkup
                )
                if filedPrice == nil {
                    Button("File the card") {
                        fileCard()
                    }
                }
            } else {
                Button("Open the counter card") {
                    openCard()
                }
            }
        }
    }

    private func openCard() {
        let card = ShawlCounter(
            shopName: "Casa Rojas, Calle Linares",
            sellerName: "Mariela Rojas",
            askingBolivianos: 920,
            spokenMarkup: "Add forty bolivianos",
            openedOn: GregorianDay.date(year: 2026, month: 6, day: 18, timeZoneIdentifier: "America/La_Paz")
        )
        modelContext.insert(card)
        self.card = card
    }

    private func fileCard() {
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        let cards = (try? filed.fetch(FetchDescriptor<ShawlCounter>())) ?? []
        filedPrice = cards.first?.askingBolivianos
        filedMarkup = cards.first?.spokenMarkup ?? ""
    }
}

private struct CounterFields: View {
    let card: ShawlCounter
    let schema: Schema
    let filedPrice: Int?
    let filedMarkup: String

    private var attribute: Schema.Attribute? {
        StoredAttribute.named("spokenMarkup", on: "ShawlCounter", in: schema)
    }

    var body: some View {
        Section(card.shopName) {
            LabeledContent("Seller", value: card.sellerName)
            LabeledContent("Asking price", value: "\(card.askingBolivianos) bolivianos")
            LabeledContent("Spoken at the counter", value: card.spokenMarkup)
            LabeledContent("Transient", value: attribute?.isTransient == true ? "Yes" : "No")
        }

        if let filedPrice {
            Section("Filed book") {
                LabeledContent("Asking price", value: "\(filedPrice) bolivianos")
                LabeledContent("Spoken markup", value: filedMarkup.isEmpty ? "Empty" : filedMarkup)
            }
        }
    }
}
