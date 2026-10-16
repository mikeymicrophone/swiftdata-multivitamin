// Feature: @Model basics
// Slot 03 — Haarlem bite note
// Teaches:
// - An optional stored property can be absent.
// - Nil is a stored state, not a missing column.

import SwiftData
import SwiftUI

@Model
final class BiteNote {
    var plateCode: String
    var groundName: String
    var minutesInBath: Int
    var foulBiteNote: String?
    var nextBathAt: Date?

    init(
        plateCode: String,
        groundName: String,
        minutesInBath: Int,
        foulBiteNote: String? = nil,
        nextBathAt: Date? = nil
    ) {
        self.plateCode = plateCode
        self.groundName = groundName
        self.minutesInBath = minutesInBath
        self.foulBiteNote = foulBiteNote
        self.nextBathAt = nextBathAt
    }
}

struct BiteNoteScreen: View {
    var body: some View {
        BiteNoteEditor()
            .inMemoryStore(for: BiteNote.self)
    }
}

private struct BiteNoteEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var foulBiteObserved = false
    @State private var foulBiteNote = ""
    @State private var scheduleNextBath = false
    @State private var nextBathAt = GregorianDay.date(year: 2026, month: 3, day: 6, timeZoneIdentifier: "Europe/Amsterdam")
    @State private var note: BiteNote?

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 03",
            title: "Haarlem bite note",
            situation: "Bram Visser pulls plate HV-6 from the bath. The foul-bite line and the next bath can stay blank.",
            teaches: [
                "An optional stored property can be absent.",
                "Nil is a stored state, not a missing column."
            ]
        ) {
            if let note {
                BiteNoteFields(note: note)
            } else {
                Section("HV-6") {
                    LabeledContent("Ground", value: "hard ground")
                    LabeledContent("Minutes in the bath", value: "18")
                    Toggle("Foul bite observed", isOn: $foulBiteObserved)
                    if foulBiteObserved {
                        TextField("Foul-bite line", text: $foulBiteNote)
                    }
                    Toggle("Schedule the next bath", isOn: $scheduleNextBath)
                    if scheduleNextBath {
                        DatePicker("Next bath", selection: $nextBathAt, displayedComponents: [.date, .hourAndMinute])
                    }
                    Button("Write the bite note") {
                        writeNote()
                    }
                }
            }
        }
    }

    private func writeNote() {
        let trimmed = foulBiteNote.trimmingCharacters(in: .whitespacesAndNewlines)
        let note = BiteNote(
            plateCode: "HV-6",
            groundName: "hard ground",
            minutesInBath: 18,
            foulBiteNote: foulBiteObserved && !trimmed.isEmpty ? trimmed : nil,
            nextBathAt: scheduleNextBath ? nextBathAt : nil
        )
        modelContext.insert(note)
        self.note = note
    }
}

private struct BiteNoteFields: View {
    let note: BiteNote

    var body: some View {
        Section(note.plateCode) {
            LabeledContent("Ground", value: note.groundName)
            LabeledContent("Minutes in the bath", value: "\(note.minutesInBath)")
            LabeledContent("Foul-bite line", value: note.foulBiteNote ?? "Left blank")
            LabeledContent(
                "Next bath",
                value: note.nextBathAt?.formatted(date: .abbreviated, time: .shortened) ?? "Left blank"
            )
        }

        Section {
            Text("The foul-bite line can stay blank until the plate is out of the bath.")
                .foregroundStyle(.secondary)
        }
    }
}
