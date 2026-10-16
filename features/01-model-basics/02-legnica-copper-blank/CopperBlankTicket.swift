// Feature: @Model basics
// Slot 02 — Legnica copper blank
// Teaches:
// - The initializer is the gate for a new record.
// - A non-optional stored property has to be supplied.

import SwiftData
import SwiftUI

@Model
final class CopperBlankTicket {
    var lotCode: String
    var blankCount: Int
    var thicknessMillimetres: Double
    var alloy: String
    var milledOn: Date

    init(lotCode: String, blankCount: Int, thicknessMillimetres: Double, alloy: String, milledOn: Date) {
        self.lotCode = lotCode
        self.blankCount = blankCount
        self.thicknessMillimetres = thicknessMillimetres
        self.alloy = alloy
        self.milledOn = milledOn
    }

    static func ticket(
        lotCode: String,
        blankCount: Int,
        thicknessMillimetres: Double,
        alloy: String,
        milledOn: Date
    ) -> CopperBlankTicket? {
        let trimmedLot = lotCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAlloy = alloy.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedLot.isEmpty, blankCount > 0, thicknessMillimetres > 0, !trimmedAlloy.isEmpty else {
            return nil
        }
        return CopperBlankTicket(
            lotCode: trimmedLot,
            blankCount: blankCount,
            thicknessMillimetres: thicknessMillimetres,
            alloy: trimmedAlloy,
            milledOn: milledOn
        )
    }
}

struct CopperBlankTicketScreen: View {
    var body: some View {
        CopperBlankTicketEditor()
            .inMemoryStore(for: CopperBlankTicket.self)
    }
}

private struct CopperBlankTicketEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var lotCode = ""
    @State private var blankCount = 6
    @State private var thicknessMillimetres = 0.0
    @State private var alloy = ""
    @State private var ticket: CopperBlankTicket?

    private var milledOn: Date {
        GregorianDay.date(year: 2026, month: 3, day: 5, timeZoneIdentifier: "Europe/Warsaw")
    }

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 02",
            title: "Legnica copper blank",
            situation: "Oliwia Wróbel will not open lot LG-220 until the count, the thickness, and the alloy are on the slip. The bench does not assume a house blank.",
            teaches: [
                "The initializer is the gate for a new record.",
                "A non-optional stored property has to be supplied."
            ]
        ) {
            if let ticket {
                TicketFields(ticket: ticket)
            } else {
                Section("Blank slip") {
                    TextField("Lot code", text: $lotCode)
                    Stepper(value: $blankCount, in: 0...24) {
                        Text("Blanks: \(blankCount)")
                    }
                    Stepper(value: $thicknessMillimetres, in: 0...2, step: 0.1) {
                        Text("Thickness: \(thicknessMillimetres.formatted(.number.precision(.fractionLength(1)))) mm")
                    }
                    TextField("Alloy", text: $alloy)
                    LabeledContent("Milled", value: milledOn.formatted(date: .long, time: .omitted))
                    Button("Write the ticket") {
                        writeTicket()
                    }
                    .disabled(
                        CopperBlankTicket.ticket(
                            lotCode: lotCode,
                            blankCount: blankCount,
                            thicknessMillimetres: thicknessMillimetres,
                            alloy: alloy,
                            milledOn: milledOn
                        ) == nil
                    )
                }
            }
        }
    }

    private func writeTicket() {
        guard let ticket = CopperBlankTicket.ticket(
            lotCode: lotCode,
            blankCount: blankCount,
            thicknessMillimetres: thicknessMillimetres,
            alloy: alloy,
            milledOn: milledOn
        ) else {
            return
        }
        modelContext.insert(ticket)
        self.ticket = ticket
    }
}

private struct TicketFields: View {
    let ticket: CopperBlankTicket

    var body: some View {
        Section(ticket.lotCode) {
            LabeledContent("Blanks", value: "\(ticket.blankCount)")
            LabeledContent(
                "Thickness",
                value: "\(ticket.thicknessMillimetres.formatted(.number.precision(.fractionLength(1)))) mm"
            )
            LabeledContent("Alloy", value: ticket.alloy)
            LabeledContent("Milled", value: ticket.milledOn.formatted(date: .long, time: .omitted))
        }

        Section {
            Text("The six blanks go to Bram Visser's etching loft in Haarlem.")
                .foregroundStyle(.secondary)
        }
    }
}
