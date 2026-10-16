// Feature: @Transient
// Slot 07 — Bedesten aside
// Teaches:
// - Writing the aside leaves the context unchanged.
// - The filed price stays 4000 lira.

import SwiftData
import SwiftUI

@Model
final class BedestenCard {
    var pipeCode: String
    var sellerName: String
    var priceLira: Int
    var openedOn: Date
    @Transient var aside: String = ""

    init(pipeCode: String, sellerName: String, priceLira: Int, openedOn: Date, aside: String = "") {
        self.pipeCode = pipeCode
        self.sellerName = sellerName
        self.priceLira = priceLira
        self.openedOn = openedOn
        self.aside = aside
    }
}

struct BedestenAsideScreen: View {
    private let container = MemoryStore.containerOrCrash(BedestenCard.self)

    var body: some View {
        BedestenAsideEditor()
            .modelContainer(container)
    }
}

private struct BedestenAsideEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var card: BedestenCard?
    @State private var changedLine = ""
    @State private var filedPrice = ""
    @State private var filedAside = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 07",
            title: "Bedesten aside",
            situation: "On 8 April Aylin Şahin files pipe EB-7 at 4000 lira in the Eskişehir bedesten. She then writes that Emre will collect at dusk. The book does not become dirty.",
            teaches: [
                "Writing the aside leaves the context unchanged.",
                "The filed price stays 4000 lira."
            ]
        ) {
            if let card {
                AsideFields(card: card, changedLine: changedLine, filedPrice: filedPrice, filedAside: filedAside)
                if changedLine.isEmpty {
                    Button("Write the aside") {
                        writeAside(card)
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
            priceLira: 4000,
            openedOn: GregorianDay.date(year: 2026, month: 4, day: 8, timeZoneIdentifier: "Europe/Istanbul")
        )
        modelContext.insert(card)
        try? modelContext.save()
        self.card = card
    }

    private func writeAside(_ card: BedestenCard) {
        card.aside = "Emre will collect at dusk"
        changedLine = modelContext.hasChanges ? "Yes" : "No"
        try? modelContext.save()
        let filed = (try? ModelContext(modelContext.container).fetch(FetchDescriptor<BedestenCard>()))?.first
        filedPrice = filed.map { "\($0.priceLira) lira" } ?? "Missing"
        filedAside = filed?.aside.isEmpty == false ? (filed?.aside ?? "Missing") : "Empty"
    }
}

private struct AsideFields: View {
    let card: BedestenCard
    let changedLine: String
    let filedPrice: String
    let filedAside: String

    var body: some View {
        Section(card.pipeCode) {
            LabeledContent("Seller", value: card.sellerName)
            LabeledContent("Price", value: "\(card.priceLira) lira")
            if !changedLine.isEmpty {
                LabeledContent("Aside on this card", value: card.aside)
                LabeledContent("Context changed", value: changedLine)
            }
        }
        if !filedPrice.isEmpty {
            Section("Filed card") {
                LabeledContent("Price", value: filedPrice)
                LabeledContent("Aside", value: filedAside)
            }
        }
        Section {
            Text("Aylin changes the price on the card.")
                .foregroundStyle(.secondary)
        }
    }
}
