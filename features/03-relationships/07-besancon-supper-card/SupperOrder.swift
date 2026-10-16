// Feature: Relationships
// Slot 07 — Besançon supper card
// Teaches:
// - minimumModelCount records that the card should name a buyer.
// - The buyer has no inverse, and a save with no buyer still files the card.

import SwiftData
import SwiftUI

@Model
final class SupperBuyer {
    var buyerName: String
    var street: String

    init(buyerName: String, street: String) {
        self.buyerName = buyerName
        self.street = street
    }
}

@Model
final class SupperOrder {
    var supperName: String
    var shopName: String
    var clerkName: String
    var bookedOn: Date
    // The minimum is stored as 1. Filing the card with no buyer still succeeds.
    @Relationship(minimumModelCount: 1)
    var buyer: SupperBuyer?

    init(supperName: String, shopName: String, clerkName: String, bookedOn: Date) {
        self.supperName = supperName
        self.shopName = shopName
        self.clerkName = clerkName
        self.bookedOn = bookedOn
    }
}

struct SupperOrderScreen: View {
    var body: some View {
        SupperOrderEditor()
            .inMemoryStore(for: SupperOrder.self, SupperBuyer.self)
    }
}

private struct SupperOrderEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var order: SupperOrder?
    @State private var filed = false
    @State private var filedBuyer = "Not filed"

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 07",
            title: "Besançon supper card",
            situation: "On 7 September Chantal Vercel opens a card at Fromagerie Vercel for Odile Marchand's supper on 20 September. The buyer line is still empty.",
            teaches: [
                "minimumModelCount records that the card should name a buyer.",
                "The buyer has no inverse, and a save with no buyer still files the card."
            ]
        ) {
            if let order {
                OrderFields(
                    order: order,
                    schema: modelContext.container.schema,
                    filed: filed,
                    filedBuyer: filedBuyer
                )
                if !filed {
                    Button("File the card") {
                        fileCard()
                    }
                }
            } else {
                Button("Open the supper card") {
                    openCard()
                }
            }
        }
    }

    private func openCard() {
        let order = SupperOrder(
            supperName: "Odile Marchand supper, 20 September",
            shopName: "Fromagerie Vercel, Grande Rue",
            clerkName: "Chantal Vercel",
            bookedOn: GregorianDay.date(year: 2026, month: 9, day: 7, timeZoneIdentifier: "Europe/Paris")
        )
        modelContext.insert(order)
        self.order = order
    }

    private func fileCard() {
        try? modelContext.save()
        let filedContext = ModelContext(modelContext.container)
        let cards = (try? filedContext.fetch(FetchDescriptor<SupperOrder>())) ?? []
        filedBuyer = cards.first?.buyer?.buyerName ?? "None"
        filed = true
    }
}

private struct OrderFields: View {
    let order: SupperOrder
    let schema: Schema
    let filed: Bool
    let filedBuyer: String

    private var link: Schema.Relationship? {
        StoredRelationship.named("buyer", on: "SupperOrder", in: schema)
    }

    var body: some View {
        Section(order.shopName) {
            LabeledContent("Clerk", value: order.clerkName)
            LabeledContent("Supper", value: order.supperName)
            LabeledContent("Minimum", value: minimumText)
            LabeledContent("Inverse", value: link?.inverseName ?? "None")
            LabeledContent("Buyer", value: order.buyer?.buyerName ?? "None")
        }

        if filed {
            Section("Filed book") {
                LabeledContent("Buyer", value: filedBuyer)
            }
        }

        Section {
            Text("The jury at the Maison du Comté in Poligny tastes PL-19.")
                .foregroundStyle(.secondary)
        }
    }

    private var minimumText: String {
        guard let minimum = link?.minimumModelCount else { return "None" }
        return "\(minimum)"
    }
}
