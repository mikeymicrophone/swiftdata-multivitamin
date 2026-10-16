// Feature: @Transient
// Slot 09 — Counter reading
// Teaches:
// - A fetch in this context returns the same card, aside included.
// - A new context is a different card and reads the default aside.

import SwiftData
import SwiftUI

struct CounterReadingScreen: View {
    var body: some View {
        CounterReadingEditor()
            .inMemoryStore(for: BedestenCard.self)
    }
}

private struct CounterReadingEditor: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BedestenCard.pipeCode) private var cards: [BedestenCard]
    @State private var readAgain = false

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 09",
            title: "Counter reading",
            situation: "On 10 April Aylin Şahin writes that pipe EB-7 is wrapped in newspaper. She reads the open counter again, then a fresh copy of the book.",
            teaches: [
                "A fetch in this context returns the same card, aside included.",
                "A new context is a different card and reads the default aside."
            ]
        ) {
            if cards.isEmpty {
                Button("Open the counter card", action: open)
            } else {
                ForEach(cards) { card in
                    Section(card.pipeCode) {
                        LabeledContent("Seller", value: card.sellerName)
                        LabeledContent("Price", value: card.priceLira, format: .currency(code: "TRY"))
                        LabeledContent("Aside on this card", value: card.aside)
                    }
                }
                if readAgain {
                    FreshCopy(openCards: cards)
                } else {
                    Button("Read the card again") { readAgain = true }
                }
                Section {
                    Text("Kemal Aydın cuts a spare lump at Sepetçi.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func open() {
        modelContext.insert(BedestenCard(
            pipeCode: "EB-7",
            sellerName: "Aylin Şahin",
            priceLira: 4500,
            openedOn: GregorianDay.date(year: 2026, month: 4, day: 10, timeZoneIdentifier: "Europe/Istanbul"),
            aside: "Wrapped in newspaper"
        ))
        try? modelContext.save()
    }
}

/// The @Query above reads through this view's context, so its rows are the open
/// cards. The fresh copy below is fetched through a second context.
private struct FreshCopy: View {
    @Environment(\.modelContext) private var modelContext
    let openCards: [BedestenCard]

    var body: some View {
        let again = (try? modelContext.fetch(FetchDescriptor<BedestenCard>())) ?? []
        let fresh = (try? modelContext.freshFetch(FetchDescriptor<BedestenCard>(sortBy: [SortDescriptor(\.pipeCode)]))) ?? []
        Section("Read again") {
            ForEach(Array(zip(openCards, fresh)), id: \.0.persistentModelID) { live, copy in
                LabeledContent("This context, same object", value: again.contains { $0 === live } ? "Yes" : "No")
                LabeledContent("Aside from this context", value: live.aside)
                LabeledContent("New context, same object", value: live === copy ? "Yes" : "No")
                LabeledContent("Aside from a new context", value: copy.aside.isEmpty ? "Empty" : copy.aside)
            }
        }
    }
}
