// Feature: @Transient
// Slot 05 — Lattice scratch
// Teaches:
// - A transient property can hold an enum with associated values that is not a column.
// - A new context reads the default scratch. The bowl name is filed.

import SwiftData
import SwiftUI

enum LatticeScratch: Equatable {
    case blank
    case marked(openings: Int, note: String)
    case stopped(atOpening: Int, reason: String)

    var openings: Int {
        switch self {
        case .blank: 0
        case .marked(let openings, _): openings
        case .stopped(let opening, _): opening
        }
    }

    var note: String {
        switch self {
        case .blank: ""
        case let .marked(_, note), let .stopped(_, note): note
        }
    }
}

@Model
final class LatticeBowl {
    var bowlName: String
    var carverName: String
    var carvedOn: Date
    @Transient var scratch: LatticeScratch = .blank

    init(bowlName: String, carverName: String, carvedOn: Date, scratch: LatticeScratch = .blank) {
        self.bowlName = bowlName
        self.carverName = carverName
        self.carvedOn = carvedOn
        self.scratch = scratch
    }
}

struct LatticeBowlScreen: View {
    var body: some View {
        LatticeBowlEditor()
            .inMemoryStore(for: LatticeBowl.self)
    }
}

private struct LatticeBowlEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var bowl: LatticeBowl?
    @State private var filed: (bowlName: String, scratch: LatticeScratch)?

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 05",
            title: "Lattice scratch",
            situation: "On 6 April Nesrin Kaya keeps a scratch for the lattice egg: 14 openings, stop before the grey. The scratch is an enum on the card, not a column.",
            teaches: [
                "A transient property can hold an enum with associated values that is not a column.",
                "A new context reads the default scratch. The bowl name is filed."
            ]
        ) {
            if let bowl {
                Section(bowl.bowlName) {
                    LabeledContent("Carver", value: bowl.carverName)
                    LabeledContent("Columns") {
                        Text(StoredAttribute.propertyNames(on: "LatticeBowl", in: modelContext.container.schema), format: .list(type: .and))
                    }
                    ScratchRow(title: "Scratch on this card", scratch: bowl.scratch)
                }
                if let filed {
                    Section("Filed card") {
                        LabeledContent("Bowl", value: filed.bowlName)
                        ScratchRow(title: "Scratch", scratch: filed.scratch)
                    }
                } else {
                    Button("File the bowl card") {
                        try? modelContext.save()
                        filed = (try? modelContext.freshFirst(LatticeBowl.self)).map { (bowlName: $0.bowlName, scratch: $0.scratch) }
                    }
                }
                Section {
                    Text("Cemil Arslan cuts the oxhide case.")
                        .foregroundStyle(.secondary)
                }
            } else {
                Button("Open the scratch card") {
                    let bowl = LatticeBowl(
                        bowlName: "Lattice egg",
                        carverName: "Nesrin Kaya",
                        carvedOn: GregorianDay.date(year: 2026, month: 4, day: 6, timeZoneIdentifier: "Europe/Istanbul"),
                        scratch: .marked(openings: 14, note: "Stop before the grey")
                    )
                    modelContext.insert(bowl)
                    self.bowl = bowl
                }
            }
        }
    }
}

private struct ScratchRow: View {
    let title: String
    let scratch: LatticeScratch

    var body: some View {
        LabeledContent(title) {
            switch scratch {
            case .blank:
                Text("Blank")
                    .foregroundStyle(.secondary)
            case .marked(let openings, let note) where note.isEmpty:
                Text("\(openings) openings")
            case let .marked(openings, note):
                Text("\(openings) openings, \(note)")
            case let .stopped(opening, reason):
                Label("Stopped at \(opening): \(reason)", systemImage: "hand.raised")
            }
        }
    }
}
