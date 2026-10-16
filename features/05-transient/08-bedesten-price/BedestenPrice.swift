// Feature: @Transient
// Slot 08 — Bedesten price
// Teaches:
// - A stored edit is filed. The aside is not.
// - This card keeps the aside after the save.

import SwiftData
import SwiftUI

struct BedestenPriceScreen: View {
    private let container = MemoryStore.containerOrCrash(BedestenCard.self)

    var body: some View {
        BedestenPriceEditor()
            .modelContainer(container)
    }
}

private struct BedestenPriceEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var card: BedestenCard?
    @State private var liveAside = ""
    @State private var filedPrice = ""
    @State private var filedAside = ""

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
                PriceFields(card: card, liveAside: liveAside, filedPrice: filedPrice, filedAside: filedAside)
                if filedPrice.isEmpty {
                    Button("Rewrite the price") {
                        rewrite(card)
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
            openedOn: GregorianDay.date(year: 2026, month: 4, day: 9, timeZoneIdentifier: "Europe/Istanbul")
        )
        modelContext.insert(card)
        try? modelContext.save()
        self.card = card
    }

    private func rewrite(_ card: BedestenCard) {
        card.aside = "Hold it for Emre"
        card.priceLira = 4500
        try? modelContext.save()
        liveAside = card.aside
        let filed = (try? ModelContext(modelContext.container).fetch(FetchDescriptor<BedestenCard>()))?.first
        filedPrice = filed.map { "\($0.priceLira) lira" } ?? "Missing"
        filedAside = filed?.aside.isEmpty == false ? (filed?.aside ?? "Missing") : "Empty"
    }
}

private struct PriceFields: View {
    let card: BedestenCard
    let liveAside: String
    let filedPrice: String
    let filedAside: String

    var body: some View {
        Section(card.pipeCode) {
            LabeledContent("Seller", value: card.sellerName)
            LabeledContent("Price on this card", value: "\(card.priceLira) lira")
            if !liveAside.isEmpty {
                LabeledContent("Aside on this card", value: liveAside)
            }
        }
        if !filedPrice.isEmpty {
            Section("Filed card") {
                LabeledContent("Price", value: filedPrice)
                LabeledContent("Aside", value: filedAside)
            }
        }
        Section {
            Text("She reads the open card again before Emre arrives.")
                .foregroundStyle(.secondary)
        }
    }
}
