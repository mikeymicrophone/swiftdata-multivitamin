// Feature: Attributes
// Slot 05 — Lucanas agreed price
// Teaches:
// - @Attribute(.preserveValueOnDeletion) marks a value to be kept if the row is deleted.
// - The mark is on the attribute.

import SwiftData
import SwiftUI

@Model
final class AgreedPrice {
    var payee: String
    var payer: String
    var clerkName: String
    @Attribute(.preserveValueOnDeletion) var agreedSoles: Int
    var agreedOn: Date

    init(payee: String, payer: String, clerkName: String, agreedSoles: Int, agreedOn: Date) {
        self.payee = payee
        self.payer = payer
        self.clerkName = clerkName
        self.agreedSoles = agreedSoles
        self.agreedOn = agreedOn
    }
}

struct AgreedPriceScreen: View {
    private let container = MemoryStore.containerOrCrash(AgreedPrice.self)

    var body: some View {
        AgreedPriceEditor()
            .modelContainer(container)
    }
}

private struct AgreedPriceEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var price: AgreedPrice?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 05",
            title: "Lucanas agreed price",
            situation: "The same morning as the chaccu, Nélida Apaza locks the community price at 480 soles. The soles are marked to be kept if the line is later struck.",
            teaches: [
                "@Attribute(.preserveValueOnDeletion) marks a value to be kept if the row is deleted.",
                "The mark is on the attribute."
            ]
        ) {
            if let price {
                PriceFields(price: price, schema: modelContext.container.schema)
            } else {
                Button("Lock the price") {
                    lockPrice()
                }
            }
        }
    }

    private func lockPrice() {
        let price = AgreedPrice(
            payee: "Comunidad de Lucanas",
            payer: "Casa Rojas, La Paz",
            clerkName: "Nélida Apaza",
            agreedSoles: 480,
            agreedOn: GregorianDay.date(year: 2026, month: 6, day: 8, timeZoneIdentifier: "America/Lima")
        )
        modelContext.insert(price)
        self.price = price
    }
}

private struct PriceFields: View {
    let price: AgreedPrice
    let schema: Schema

    private var marked: Bool {
        StoredAttribute.named("agreedSoles", on: "AgreedPrice", in: schema)?.options.contains(.preserveValueOnDeletion) == true
    }

    var body: some View {
        Section(price.payee) {
            LabeledContent("Clerk", value: price.clerkName)
            LabeledContent("Payer", value: price.payer)
            LabeledContent("Soles", value: "\(price.agreedSoles)")
            LabeledContent("If the line is struck", value: marked ? "Keep the soles" : "Unmarked")
        }
    }
}
