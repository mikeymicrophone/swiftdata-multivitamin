// Feature: @Transient
// Slot 08 — Bedesten price
// Teaches:
// - A stored edit is filed. The aside is not.
// - This card keeps the aside after the save.

import SwiftData
import SwiftUI

struct BedestenPriceScreen: View {
    var body: some View {
        BedestenPriceEditor()
            .inMemoryStore(for: BedestenCard.self)
    }
}

/// One side of the comparison: what a card says when it is read.
private struct CardReading {
    let priceLira: Int
    let aside: String

    init(_ card: BedestenCard) {
        priceLira = card.priceLira
        aside = card.aside
    }
}

private enum Filing {
    case drafting
    case filed(open: CardReading, fresh: CardReading)
    case failed(String)
}

private struct BedestenPriceEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var card: BedestenCard?
    @State private var filing = Filing.drafting

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 08",
            title: "Bedesten price",
            situation: "On 9 April Aylin Şahin raises pipe EB-7 from 4000 lira to 4500 and writes to hold it for Emre. The price is the filed edit.",
            teaches: [
                "A stored edit is filed. The aside is not.",
                "This card keeps the aside after the save."
            ]
        ) {
            if let card {
                PriceFields(card: card)
                switch filing {
                case .drafting:
                    Button("Rewrite the price") { rewrite(card) }
                case let .filed(open, fresh):
                    ReadingGrid(open: open, fresh: fresh)
                case .failed(let reason):
                    Label(reason, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                }
                Section {
                    Text("She reads the open card again before Emre arrives.")
                        .foregroundStyle(.secondary)
                }
            } else {
                Button("Open the counter card") { open() }
            }
        }
    }

    private func open() {
        let card = BedestenCard(
            pipeCode: "EB-7",
            sellerName: "Aylin Şahin",
            priceLira: 4000,
            openedOn: GregorianDay.date(year: 2026, month: 4, day: 9, timeZoneIdentifier: "Europe/Istanbul")
        )
        modelContext.insert(card)
        try? modelContext.save()
        self.card = card
    }

    private func rewrite(_ card: BedestenCard) {
        card.aside = "Hold it for Emre"
        if card.priceLira == 4000 {
            card.priceLira = 4500
        }
        do {
            try modelContext.save()
            guard let fresh = try modelContext.freshFirst(BedestenCard.self) else {
                filing = .failed("The book has no card for \(card.pipeCode).")
                return
            }
            filing = .filed(open: CardReading(card), fresh: CardReading(fresh))
        } catch {
            filing = .failed(error.localizedDescription)
        }
    }
}

private struct PriceFields: View {
    @Bindable var card: BedestenCard

    var body: some View {
        Section(card.pipeCode) {
            LabeledContent("Seller", value: card.sellerName)
            Stepper(value: $card.priceLira, in: 3000...6000, step: 500) {
                LabeledContent("Price on this card", value: "\(card.priceLira) lira")
            }
        }
    }
}

private struct ReadingGrid: View {
    let open: CardReading
    let fresh: CardReading

    var body: some View {
        Section("Open card and filed card") {
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 6) {
                GridRow {
                    Text("")
                    Text("Price").bold()
                    Text("Aside").bold()
                }
                Divider()
                row("This card", open)
                row("New context", fresh)
            }
        }
    }

    @ViewBuilder
    private func row(_ title: String, _ reading: CardReading) -> some View {
        GridRow {
            Text(title).foregroundStyle(.secondary)
            Text("\(reading.priceLira) lira")
            Text(reading.aside.isEmpty ? "Empty" : reading.aside)
        }
    }
}
