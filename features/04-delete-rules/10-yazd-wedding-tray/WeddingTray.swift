// Feature: Delete rules
// Slot 10 — Yazd wedding tray
// Teaches:
// - The tray cascades to its place cards.
// - Each card's link to the lot is nullify, so the lot and its litres stay.

import SwiftData
import SwiftUI

@Model
final class QamsarLot {
    var lotCode: String
    var litres: Int
    var cards: [PlaceCard] = []

    init(lotCode: String, litres: Int) {
        self.lotCode = lotCode
        self.litres = litres
    }
}

@Model
final class PlaceCard {
    var seatName: String
    var tray: WeddingTray?
    @Relationship(deleteRule: .nullify, inverse: \QamsarLot.cards)
    var lot: QamsarLot?

    init(seatName: String) {
        self.seatName = seatName
    }
}

@Model
final class WeddingTray {
    var supperName: String
    var hostName: String
    @Relationship(deleteRule: .cascade, inverse: \PlaceCard.tray)
    var cards: [PlaceCard] = []

    init(supperName: String, hostName: String) {
        self.supperName = supperName
        self.hostName = hostName
    }
}

struct WeddingTrayScreen: View {
    var body: some View {
        WeddingTrayEditor()
            .inMemoryStore(for: WeddingTray.self, PlaceCard.self, QamsarLot.self)
    }
}

private struct WeddingTrayEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var tray: WeddingTray?
    @State private var trayCount = -1
    @State private var cardCount = -1
    @State private var lotLine = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 10",
            title: "Yazd wedding tray",
            situation: "On 19 May Maryam Farahi voids a duplicate tray for the Farahi supper. The place cards go with the tray. Lot QS-22, 18 litres, stays in the shop.",
            teaches: [
                "The tray cascades to its place cards.",
                "Each card's link to the lot is nullify, so the lot and its litres stay."
            ]
        ) {
            if let tray {
                TrayFields(tray: tray, trayCount: trayCount, cardCount: cardCount, lotLine: lotLine)
                if trayCount < 0 {
                    Button("Void the duplicate tray") {
                        voidTray(tray)
                    }
                }
            } else {
                Button("Lay the place cards") {
                    layCards()
                }
            }
        }
    }

    private func layCards() {
        let tray = WeddingTray(supperName: "Farahi supper, 20 May", hostName: "Maryam Farahi")
        let lot = QamsarLot(lotCode: "QS-22", litres: 18)
        let maryam = PlaceCard(seatName: "Maryam Farahi")
        let soraya = PlaceCard(seatName: "Soraya Dehghan")
        modelContext.insert(tray)
        modelContext.insert(lot)
        modelContext.insert(maryam)
        modelContext.insert(soraya)
        tray.cards.append(maryam)
        tray.cards.append(soraya)
        maryam.lot = lot
        soraya.lot = lot
        try? modelContext.save()
        self.tray = tray
    }

    private func voidTray(_ tray: WeddingTray) {
        modelContext.delete(tray)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        let trays = (try? filed.fetch(FetchDescriptor<WeddingTray>())) ?? []
        let cards = (try? filed.fetch(FetchDescriptor<PlaceCard>())) ?? []
        let lots = (try? filed.fetch(FetchDescriptor<QamsarLot>())) ?? []
        trayCount = trays.count
        cardCount = cards.count
        lotLine = lots.first.map { "\($0.lotCode), \($0.litres) litres, cards \($0.cards.count)" } ?? "No lot"
    }
}

private struct TrayFields: View {
    let tray: WeddingTray
    let trayCount: Int
    let cardCount: Int
    let lotLine: String

    var body: some View {
        Section("Shirini Farahi, Yazd") {
            LabeledContent("Host", value: tray.hostName)
            LabeledContent("Supper", value: tray.supperName)
            LabeledContent("Cards", value: tray.cards.map(\.seatName).joined(separator: ", "))
        }
        if trayCount >= 0 {
            Section("Filed book") {
                LabeledContent("Trays", value: "\(trayCount)")
                LabeledContent("Cards", value: "\(cardCount)")
                Text(lotLine)
            }
        }
        Section {
            Text("Jar J-1 cracks. Jar J-2 and the lot stay.")
                .foregroundStyle(.secondary)
        }
    }
}
