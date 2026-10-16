// Feature: @Transient
// Slot 02 — Odunpazarı bowl
// Teaches:
// - After save, this card still holds the opening count.
// - A new context reads 0, and the bowl name is filed.

import SwiftData
import SwiftUI

@Model
final class CarvedBowl {
    var bowlName: String
    var carverName: String
    var carvedOn: Date
    @Transient var openings: Int = 0

    init(bowlName: String, carverName: String, carvedOn: Date, openings: Int = 0) {
        self.bowlName = bowlName
        self.carverName = carverName
        self.carvedOn = carvedOn
        self.openings = openings
    }
}

struct CarvedBowlScreen: View {
    private let container = MemoryStore.containerOrCrash(CarvedBowl.self)

    var body: some View {
        CarvedBowlEditor()
            .modelContainer(container)
    }
}

private struct CarvedBowlEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var bowl: CarvedBowl?
    @State private var liveOpenings: Int?
    @State private var filedOpenings: Int?
    @State private var filedName = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 02",
            title: "Odunpazarı bowl",
            situation: "On 3 April Nesrin Kaya names the bowl lattice egg in the Odunpazarı carving room. She counts 14 openings on her fingers.",
            teaches: [
                "After save, this card still holds the opening count.",
                "A new context reads 0, and the bowl name is filed."
            ]
        ) {
            if let bowl {
                BowlFields(
                    bowl: bowl,
                    liveOpenings: liveOpenings,
                    filedOpenings: filedOpenings,
                    filedName: filedName
                )
                if filedName.isEmpty {
                    Button("File the bowl card") {
                        file(bowl)
                    }
                }
            } else {
                Button("Open the bowl card") {
                    open()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func open() {
        let bowl = CarvedBowl(
            bowlName: "Lattice egg",
            carverName: "Nesrin Kaya",
            carvedOn: GregorianDay.date(year: 2026, month: 4, day: 3, timeZoneIdentifier: "Europe/Istanbul"),
            openings: 14
        )
        modelContext.insert(bowl)
        self.bowl = bowl
    }

    private func file(_ bowl: CarvedBowl) {
        try? modelContext.save()
        liveOpenings = bowl.openings
        let filed = (try? ModelContext(modelContext.container).fetch(FetchDescriptor<CarvedBowl>()))?.first
        filedOpenings = filed?.openings
        filedName = filed?.bowlName ?? "Missing"
    }
}

private struct BowlFields: View {
    let bowl: CarvedBowl
    let liveOpenings: Int?
    let filedOpenings: Int?
    let filedName: String

    var body: some View {
        Section(bowl.bowlName) {
            LabeledContent("Carver", value: bowl.carverName)
            LabeledContent("Carved", value: bowl.carvedOn.formatted(date: .long, time: .omitted))
            LabeledContent("Openings on this card", value: "\(liveOpenings ?? bowl.openings)")
        }
        if !filedName.isEmpty {
            Section("Filed card") {
                LabeledContent("Bowl", value: filedName)
                LabeledContent("Openings", value: "\(filedOpenings ?? -1)")
            }
        }
        Section {
            Text("Yusuf Demir heats the wax behind the carving room.")
                .foregroundStyle(.secondary)
        }
    }
}
