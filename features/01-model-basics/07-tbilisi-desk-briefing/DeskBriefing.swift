// Feature: @Model basics
// Slot 07 — Tbilisi desk briefing
// Teaches:
// - A method on the model is not a stored property.
// - The method reads the stored fields and returns a value.

import SwiftData
import SwiftUI

@Model
final class DeskBriefing {
    var curatorName: String
    var roomName: String
    var studyTitle: String
    var plateCount: Int
    var impressionCount: Int
    var orderedOn: Date

    init(
        curatorName: String,
        roomName: String,
        studyTitle: String,
        plateCount: Int,
        impressionCount: Int,
        orderedOn: Date
    ) {
        self.curatorName = curatorName
        self.roomName = roomName
        self.studyTitle = studyTitle
        self.plateCount = plateCount
        self.impressionCount = impressionCount
        self.orderedOn = orderedOn
    }

    func spokenSummary() -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_GB")
        calendar.timeZone = TimeZone(identifier: "Asia/Tbilisi") ?? TimeZone(secondsFromGMT: 0)!
        let day = calendar.component(.day, from: orderedOn)
        let monthIndex = calendar.component(.month, from: orderedOn) - 1
        let month = calendar.monthSymbols[monthIndex]
        let year = calendar.component(.year, from: orderedOn)
        return "\(curatorName) tells the \(roomName) that \(studyTitle) needs \(plateCount) plates and \(impressionCount) impressions, ordered \(day) \(month) \(year)."
    }
}

struct DeskBriefingScreen: View {
    private let container = MemoryStore.containerOrCrash(DeskBriefing.self)

    var body: some View {
        DeskBriefingEditor()
            .modelContainer(container)
    }
}

private struct DeskBriefingEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var briefing: DeskBriefing?
    @State private var spoken = ""

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 07",
            title: "Tbilisi desk briefing",
            situation: "On the evening of 11 March, Nino Beridze reads the commission back to the Works on Paper room. The sentence is a method. It is not another field.",
            teaches: [
                "A method on the model is not a stored property.",
                "The method reads the stored fields and returns a value."
            ]
        ) {
            if let briefing {
                Section("Stored fields") {
                    LabeledContent("Curator", value: briefing.curatorName)
                    LabeledContent("Room", value: briefing.roomName)
                    LabeledContent("Study", value: briefing.studyTitle)
                    LabeledContent("Plates", value: "\(briefing.plateCount)")
                    LabeledContent("Impressions", value: "\(briefing.impressionCount)")
                }

                Section("Aloud") {
                    Button("Read it to the room") {
                        spoken = briefing.spokenSummary()
                    }
                    if !spoken.isEmpty {
                        Text(spoken)
                    }
                }
            } else {
                Button("Open the briefing") {
                    openBriefing()
                }
            }
        }
    }

    private func openBriefing() {
        let briefing = DeskBriefing(
            curatorName: "Nino Beridze",
            roomName: "Works on Paper room",
            studyTitle: "Quince branch, Vera courtyard",
            plateCount: 6,
            impressionCount: 40,
            orderedOn: GregorianDay.date(year: 2026, month: 3, day: 3, timeZoneIdentifier: "Asia/Tbilisi")
        )
        modelContext.insert(briefing)
        self.briefing = briefing
    }
}
