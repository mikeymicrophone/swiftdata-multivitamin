// Feature: @Transient
// Slot 13 — Bedesten morning folder
// Teaches:
// - One schema holds the four cards, and each aside is omitted.
// - A new context files the four desk facts and reads each default aside.

import SwiftData
import SwiftUI

enum PipeFolder {
    static let types: [any PersistentModel.Type] = [
        SepetciLump.self,
        CarvedBowl.self,
        WaxCook.self,
        StemFit.self
    ]
}

/// What every card on the counter can say, whatever its columns are.
protocol CounterCard: PersistentModel {
    var deskFact: String { get }
    var asideLine: String { get }
}

extension CounterCard {
    static var entityName: String { String(describing: Self.self) }
}

extension SepetciLump: CounterCard {
    var deskFact: String { lumpCode }
    var asideLine: String { seamNote.isEmpty ? "empty note" : seamNote }
}

extension CarvedBowl: CounterCard {
    var deskFact: String { bowlName }
    var asideLine: String { "\(openings) openings" }
}

extension WaxCook: CounterCard {
    var deskFact: String { lotCode }
    var asideLine: String { whisper ?? "Unspoken" }
}

extension StemFit: CounterCard {
    var deskFact: String { wood }
    var asideLine: String { nick }
}

private struct CardReading: Identifiable {
    let id: String
    let columns: [String]
    let onCounter: String
    let readAgain: String
}

struct PipeHandoverScreen: View {
    var body: some View {
        PipeHandoverEditor()
            .inMemoryStore(for: PipeFolder.types)
    }
}

private struct PipeHandoverEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var readings: [CardReading] = []

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 13",
            title: "Bedesten morning folder",
            situation: "On 14 April, before Emre Yılmaz collects pipe EB-7, Aylin Şahin lays out the lump, the bowl, the wax lot, and the stem. Each aside is still on the open card.",
            teaches: [
                "One schema holds the four cards, and each aside is omitted.",
                "A new context files the four desk facts and reads each default aside."
            ]
        ) {
            if readings.isEmpty {
                Button("Lay out the four cards", action: layOut)
            } else {
                ForEach(readings) { reading in
                    Section(reading.id) {
                        LabeledContent("Columns", value: reading.columns.joined(separator: ", "))
                        LabeledContent("On the counter", value: reading.onCounter)
                        LabeledContent("Read again", value: reading.readAgain)
                    }
                }
                Section {
                    Text("Emre Yılmaz collects pipe EB-7 that evening.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func layOut() {
        let cards: [any CounterCard] = [
            SepetciLump(
                lumpCode: "EB-7",
                cutterName: "Kemal Aydın",
                grams: 180,
                cutOn: GregorianDay.date(year: 2026, month: 4, day: 2, timeZoneIdentifier: "Europe/Istanbul"),
                seamNote: "Avoid the grey seam"
            ),
            CarvedBowl(
                bowlName: "Lattice egg",
                carverName: "Nesrin Kaya",
                carvedOn: GregorianDay.date(year: 2026, month: 4, day: 3, timeZoneIdentifier: "Europe/Istanbul"),
                openings: 14
            ),
            WaxCook(
                lotCode: "WX-7",
                waxerName: "Yusuf Demir",
                cookedOn: GregorianDay.date(year: 2026, month: 4, day: 4, timeZoneIdentifier: "Europe/Istanbul"),
                whisper: "Cooler than yesterday"
            ),
            StemFit(
                wood: "Cherry",
                fitterName: "Halime Öztürk",
                fittedOn: GregorianDay.date(year: 2026, month: 4, day: 5, timeZoneIdentifier: "Europe/Istanbul"),
                nick: "Tight on the tenon"
            )
        ]
        cards.forEach { modelContext.insert($0) }
        try? modelContext.save()
        readings = cards.map { reading(of: $0) }
    }

    // Each `any CounterCard` is opened into a concrete Card here, so the fetch is typed.
    private func reading<Card: CounterCard>(of card: Card) -> CardReading {
        let filed = try? modelContext.freshFirst(Card.self)
        return CardReading(
            id: Card.entityName,
            columns: StoredAttribute.propertyNames(on: Card.entityName, in: modelContext.container.schema),
            onCounter: "\(card.deskFact), \(card.asideLine)",
            readAgain: filed.map { "\($0.deskFact), \($0.asideLine)" } ?? "Missing"
        )
    }
}
