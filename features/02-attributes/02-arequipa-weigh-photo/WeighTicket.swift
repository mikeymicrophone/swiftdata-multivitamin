// Feature: Attributes
// Slot 02 — Arequipa weigh photo
// Teaches:
// - @Attribute(.externalStorage) marks a Data value to be kept outside the row.
// - The bytes still come back on the model after a save.

import SwiftData
import SwiftUI

enum ScaleFace {
    static let bytes = Data("AQ-10 scale face, 1.25 kg, Lucanas fleece".utf8)
}

@Model
final class WeighTicket {
    var lotCode: String
    var millerName: String
    var kilos: Double
    @Attribute(.externalStorage) var weighPhoto: Data
    var weighedOn: Date

    init(lotCode: String, millerName: String, kilos: Double, weighPhoto: Data, weighedOn: Date) {
        self.lotCode = lotCode
        self.millerName = millerName
        self.kilos = kilos
        self.weighPhoto = weighPhoto
        self.weighedOn = weighedOn
    }
}

struct WeighTicketScreen: View {
    private let container = MemoryStore.containerOrCrash(WeighTicket.self)

    var body: some View {
        WeighTicketEditor()
            .modelContainer(container)
    }
}

private struct WeighTicketEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var ticket: WeighTicket?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 02",
            title: "Arequipa weigh photo",
            situation: "On 10 June Raúl Mamani weighs the Lucanas fleece at Lavadero Mamani. The scale-face bytes are marked to live outside the row.",
            teaches: [
                "@Attribute(.externalStorage) marks a Data value to be kept outside the row.",
                "The bytes still come back on the model after a save."
            ]
        ) {
            if let ticket {
                TicketFields(ticket: ticket, schema: modelContext.container.schema)
            } else {
                Button("Keep the scale face") {
                    keepScaleFace()
                }
            }
        }
    }

    private func keepScaleFace() {
        let ticket = WeighTicket(
            lotCode: "AQ-10",
            millerName: "Raúl Mamani",
            kilos: 1.25,
            weighPhoto: ScaleFace.bytes,
            weighedOn: GregorianDay.date(year: 2026, month: 6, day: 10, timeZoneIdentifier: "America/Lima")
        )
        modelContext.insert(ticket)
        self.ticket = ticket
    }
}

private struct TicketFields: View {
    let ticket: WeighTicket
    let schema: Schema

    private var external: Bool {
        StoredAttribute.named("weighPhoto", on: "WeighTicket", in: schema)?.options.contains(.externalStorage) == true
    }

    var body: some View {
        Section("Lavadero Mamani") {
            LabeledContent("Miller", value: ticket.millerName)
            LabeledContent("Lot", value: ticket.lotCode)
            LabeledContent("Kilos", value: ticket.kilos.formatted(.number.precision(.fractionLength(2))))
            LabeledContent("Scale face", value: "\(ticket.weighPhoto.count) bytes")
            LabeledContent("Storage", value: external ? "Outside the row" : "In the row")
        }

        Section {
            Text("Soledad Condori's road desk in Puno will carry this bale toward Sucre.")
                .foregroundStyle(.secondary)
        }
    }
}
