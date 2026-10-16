// Feature: @Model basics
// Slot 01 — Tbilisi quince commission
// Teaches:
// - A class marked @Model is the stored record.
// - Each stored property is a field on that record.

import SwiftData
import SwiftUI

@Model
final class QuinceCommission {
    var roomName: String
    var curatorName: String
    var studyTitle: String
    var plateCount: Int
    var impressionCount: Int
    var orderedOn: Date

    init(
        roomName: String,
        curatorName: String,
        studyTitle: String,
        plateCount: Int,
        impressionCount: Int,
        orderedOn: Date
    ) {
        self.roomName = roomName
        self.curatorName = curatorName
        self.studyTitle = studyTitle
        self.plateCount = plateCount
        self.impressionCount = impressionCount
        self.orderedOn = orderedOn
    }
}

struct QuinceCommissionScreen: View {
    var body: some View {
        QuinceCommissionEditor()
            .inMemoryStore(for: QuinceCommission.self)
    }
}

private struct QuinceCommissionEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var commission: QuinceCommission?

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 01",
            title: "Tbilisi quince commission",
            situation: "Nino Beridze opens the commission for a quince-branch study at the Georgian National Museum. The card is the record.",
            teaches: [
                "A class marked @Model is the stored record.",
                "Each stored property is a field on that record."
            ]
        ) {
            if let commission {
                CommissionFields(commission: commission)
            } else {
                Button("Open the commission") {
                    openCommission()
                }
            }
        }
    }

    private func openCommission() {
        let commission = QuinceCommission(
            roomName: "Works on Paper, Georgian National Museum",
            curatorName: "Nino Beridze",
            studyTitle: "Quince branch, Vera courtyard",
            plateCount: 6,
            impressionCount: 40,
            orderedOn: GregorianDay.date(year: 2026, month: 3, day: 3, timeZoneIdentifier: "Asia/Tbilisi")
        )
        modelContext.insert(commission)
        self.commission = commission
    }
}

private struct CommissionFields: View {
    @Bindable var commission: QuinceCommission

    var body: some View {
        Section(commission.roomName) {
            LabeledContent("Curator", value: commission.curatorName)
            TextField("Study title", text: $commission.studyTitle)
            Stepper(value: $commission.plateCount, in: 1...24) {
                Text("Plates: \(commission.plateCount)")
            }
            Stepper(value: $commission.impressionCount, in: 1...200) {
                Text("Impressions: \(commission.impressionCount)")
            }
            LabeledContent(
                "Ordered",
                value: commission.orderedOn.formatted(date: .long, time: .omitted)
            )
        }

        Section("The card") {
            Text("\(commission.curatorName) ordered \(commission.plateCount) plates and \(commission.impressionCount) impressions of \(commission.studyTitle).")
        }

        Section {
            Text("Oliwia Wróbel at the Legnica bench cuts the blanks from this count.")
                .foregroundStyle(.secondary)
        }
    }
}
