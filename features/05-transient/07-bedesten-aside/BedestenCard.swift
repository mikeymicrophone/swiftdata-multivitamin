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
    var body: some View {
        BedestenAsideEditor()
            .inMemoryStore(for: BedestenCard.self)
    }
}

private struct BedestenAsideEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var card: BedestenCard?
    @State private var filed: (priceLira: Int, aside: String)?

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
                AsideFields(card: card)
                if let filed {
                    Section("Filed card") {
                        LabeledContent("Price", value: "\(filed.priceLira) lira")
                        LabeledContent("Aside", value: filed.aside.isEmpty ? "Empty" : filed.aside)
                    }
                } else {
                    Button("Save and read the filed card") {
                        try? modelContext.save()
                        filed = (try? modelContext.freshFirst(BedestenCard.self)).map { (priceLira: $0.priceLira, aside: $0.aside) }
                    }
                }
            } else {
                Button("Open the counter card") {
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
            }
        }
    }
}

private struct AsideFields: View {
    @Environment(\.modelContext) private var modelContext
    let card: BedestenCard
    @State private var contextChanged: Bool?

    var body: some View {
        Section(card.pipeCode) {
            LabeledContent("Seller", value: card.sellerName)
            LabeledContent("Price", value: "\(card.priceLira) lira")
            TextField("Aside", text: aside, prompt: Text("Emre will collect at dusk"))
            if let contextChanged {
                LabeledContent("Context changed", value: contextChanged ? "Yes" : "No")
            }
        }
        Section {
            Text("Aylin changes the price on the card.")
                .foregroundStyle(.secondary)
        }
    }

    // A hand-built binding, so each keystroke also reads hasChanges right after the write.
    private var aside: Binding<String> {
        Binding(
            get: { card.aside },
            set: { newAside in
                card.aside = newAside
                contextChanged = modelContext.hasChanges
            }
        )
    }
}
