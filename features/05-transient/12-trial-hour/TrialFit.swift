// Feature: @Transient
// Slot 12 — Trial hour
// Teaches:
// - A transient date uses its default on a new context.
// - The stem wood is filed.

import SwiftData
import SwiftUI

enum BenchClock {
    static func date(year: Int, month: Int, day: Int, hour: Int) -> Date {
        let timeZone = TimeZone(identifier: "Europe/Istanbul") ?? TimeZone(secondsFromGMT: 0)!
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let components = DateComponents(year: year, month: month, day: day, hour: hour)
        return calendar.date(from: components)!
    }

    static func label(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "Europe/Istanbul")
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

@Model
final class TrialFit {
    var wood: String
    var fitterName: String
    var fittedOn: Date
    @Transient var triedAt: Date = BenchClock.date(year: 2026, month: 4, day: 13, hour: 8)

    init(wood: String, fitterName: String, fittedOn: Date, triedAt: Date = BenchClock.date(year: 2026, month: 4, day: 13, hour: 8)) {
        self.wood = wood
        self.fitterName = fitterName
        self.fittedOn = fittedOn
        self.triedAt = triedAt
    }
}

struct TrialFitScreen: View {
    private let container = MemoryStore.containerOrCrash(TrialFit.self)

    var body: some View {
        TrialFitEditor()
            .modelContainer(container)
    }
}

private struct TrialFitEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var stem: TrialFit?
    @State private var liveHour = ""
    @State private var filedWood = ""
    @State private var filedHour = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 12",
            title: "Trial hour",
            situation: "On 13 April Halime Öztürk tries the cherry tenon at 16:00. The card's unmarked hour is 08:00, when the bench opened.",
            teaches: [
                "A transient date uses its default on a new context.",
                "The stem wood is filed."
            ]
        ) {
            if let stem {
                HourFields(stem: stem, liveHour: liveHour, filedWood: filedWood, filedHour: filedHour)
                if filedWood.isEmpty {
                    Button("File the trial card") {
                        file(stem)
                    }
                }
            } else {
                Button("Open the trial card") {
                    open()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func open() {
        let stem = TrialFit(
            wood: "Cherry",
            fitterName: "Halime Öztürk",
            fittedOn: GregorianDay.date(year: 2026, month: 4, day: 13, timeZoneIdentifier: "Europe/Istanbul"),
            triedAt: BenchClock.date(year: 2026, month: 4, day: 13, hour: 16)
        )
        modelContext.insert(stem)
        self.stem = stem
    }

    private func file(_ stem: TrialFit) {
        try? modelContext.save()
        liveHour = BenchClock.label(stem.triedAt)
        let filed = (try? ModelContext(modelContext.container).fetch(FetchDescriptor<TrialFit>()))?.first
        filedWood = filed?.wood ?? "Missing"
        filedHour = filed.map { BenchClock.label($0.triedAt) } ?? "Missing"
    }
}

private struct HourFields: View {
    let stem: TrialFit
    let liveHour: String
    let filedWood: String
    let filedHour: String

    var body: some View {
        Section(stem.wood) {
            LabeledContent("Fitter", value: stem.fitterName)
            LabeledContent("Tried on this card", value: liveHour.isEmpty ? BenchClock.label(stem.triedAt) : liveHour)
        }
        if !filedWood.isEmpty {
            Section("Filed card") {
                LabeledContent("Wood", value: filedWood)
                LabeledContent("Hour", value: filedHour)
            }
        }
        Section {
            Text("On 14 April the four cards sit on Aylin's counter.")
                .foregroundStyle(.secondary)
        }
    }
}
