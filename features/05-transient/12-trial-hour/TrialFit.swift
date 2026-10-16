// Feature: @Transient
// Slot 12 — Trial hour
// Teaches:
// - A transient date uses its default on a new context.
// - The stem wood is filed. A computed property built on the transient resets with it.

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

extension TrialFit {
    static let benchOpens = BenchClock.date(year: 2026, month: 4, day: 13, hour: 8)

    /// Computed, so the schema never sees it. It is only as good as the transient it reads.
    var hoursAfterOpening: Int {
        Calendar(identifier: .gregorian).dateComponents([.hour], from: Self.benchOpens, to: triedAt).hour ?? 0
    }
}

struct TrialFitScreen: View {
    var body: some View {
        TrialFitEditor()
            .inMemoryStore(for: TrialFit.self)
    }
}

private struct TrialFitEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var stem: TrialFit?
    @State private var trialHour = BenchClock.date(year: 2026, month: 4, day: 13, hour: 16)
    @State private var filedCard: (wood: String, hour: Date, hoursAfterOpening: Int)?

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 12",
            title: "Trial hour",
            situation: "On 13 April Halime Öztürk tries the cherry tenon at 16:00. The card's unmarked hour is 08:00, when the bench opened.",
            teaches: [
                "A transient date uses its default on a new context.",
                "The stem wood is filed. A computed property built on the transient resets with it."
            ]
        ) {
            Section("Cherry") {
                DatePicker("Tried at", selection: $trialHour, displayedComponents: .hourAndMinute)
                    .environment(\.timeZone, TimeZone(identifier: "Europe/Istanbul") ?? .current)
                    .disabled(stem != nil)
                if let stem {
                    LabeledContent("Fitter", value: stem.fitterName)
                    LabeledContent("Tried on this card", value: BenchClock.label(stem.triedAt))
                    LabeledContent("Hours after the bench opened", value: stem.hoursAfterOpening, format: .number)
                }
            }
            if let filedCard {
                Section("Filed card") {
                    LabeledContent("Wood", value: filedCard.wood)
                    LabeledContent("Hour", value: BenchClock.label(filedCard.hour))
                    LabeledContent("Hours after the bench opened", value: filedCard.hoursAfterOpening, format: .number)
                }
            } else if let stem {
                Button("File the trial card") { file(stem) }
            } else {
                Button("Open the trial card", action: open)
            }
            Section {
                Text("On 14 April the four cards sit on Aylin's counter.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func open() {
        let stem = TrialFit(
            wood: "Cherry",
            fitterName: "Halime Öztürk",
            fittedOn: GregorianDay.date(year: 2026, month: 4, day: 13, timeZoneIdentifier: "Europe/Istanbul"),
            triedAt: trialHour
        )
        modelContext.insert(stem)
        self.stem = stem
    }

    private func file(_ stem: TrialFit) {
        try? modelContext.save()
        if let filed = try? modelContext.freshFirst(TrialFit.self) {
            filedCard = (filed.wood, filed.triedAt, filed.hoursAfterOpening)
        }
    }
}
