// Feature: @Transient
// Slot 09 — Counter reading
// Teaches:
// - A fetch in this context returns the same card, aside included.
// - A new context is a different card and reads the default aside.

import SwiftData
import SwiftUI

struct CounterReadingScreen: View {
    private let container = MemoryStore.containerOrCrash(BedestenCard.self)

    var body: some View {
        CounterReadingEditor()
            .modelContainer(container)
    }
}

private struct CounterReadingEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var card: BedestenCard?
    @State private var sameCard = ""
    @State private var sameAside = ""
    @State private var filedAside = ""

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
            if let card {
                ReadingFields(card: card, sameCard: sameCard, sameAside: sameAside, filedAside: filedAside)
                if sameCard.isEmpty {
                    Button("Read the card again") {
                        readAgain(card)
                    }
                }
            } else {
                Button("Open the counter card") {
                    open()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func open() {
        let card = BedestenCard(
            pipeCode: "EB-7",
            sellerName: "Aylin Şahin",
            priceLira: 4500,
            openedOn: GregorianDay.date(year: 2026, month: 4, day: 10, timeZoneIdentifier: "Europe/Istanbul"),
            aside: "Wrapped in newspaper"
        )
        modelContext.insert(card)
        try? modelContext.save()
        self.card = card
    }

    private func readAgain(_ card: BedestenCard) {
        let same = (try? modelContext.fetch(FetchDescriptor<BedestenCard>()))?.first
        sameCard = same === card ? "Yes" : "No"
        sameAside = same?.aside ?? "Missing"
        let filed = (try? ModelContext(modelContext.container).fetch(FetchDescriptor<BedestenCard>()))?.first
        filedAside = filed?.aside.isEmpty == false ? (filed?.aside ?? "Missing") : "Empty"
    }
}

private struct ReadingFields: View {
    let card: BedestenCard
    let sameCard: String
    let sameAside: String
    let filedAside: String

    var body: some View {
        Section(card.pipeCode) {
            LabeledContent("Seller", value: card.sellerName)
            LabeledContent("Price", value: "\(card.priceLira) lira")
            LabeledContent("Aside on this card", value: card.aside)
        }
        if !sameCard.isEmpty {
            Section("Read again") {
                LabeledContent("Same card", value: sameCard)
                LabeledContent("Aside from this context", value: sameAside)
                LabeledContent("Aside from a new context", value: filedAside)
            }
        }
        Section {
            Text("Kemal Aydın cuts a spare lump at Sepetçi.")
                .foregroundStyle(.secondary)
        }
    }
}
