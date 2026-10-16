// Feature: @Transient
// Slot 05 — Lattice scratch
// Teaches:
// - A transient property can hold a struct that is not a column.
// - A new context reads the default scratch. The bowl name is filed.

import SwiftData
import SwiftUI

struct LatticeScratch {
    var openings: Int
    var note: String
}

@Model
final class LatticeBowl {
    var bowlName: String
    var carverName: String
    var carvedOn: Date
    @Transient var scratch: LatticeScratch = LatticeScratch(openings: 0, note: "")

    init(bowlName: String, carverName: String, carvedOn: Date, scratch: LatticeScratch = LatticeScratch(openings: 0, note: "")) {
        self.bowlName = bowlName
        self.carverName = carverName
        self.carvedOn = carvedOn
        self.scratch = scratch
    }
}

struct LatticeBowlScreen: View {
    private let container = MemoryStore.containerOrCrash(LatticeBowl.self)

    var body: some View {
        LatticeBowlEditor()
            .modelContainer(container)
    }
}

private struct LatticeBowlEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var bowl: LatticeBowl?
    @State private var liveScratch = ""
    @State private var filedName = ""
    @State private var filedScratch = ""
    @State private var columns = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 05",
            title: "Lattice scratch",
            situation: "On 6 April Nesrin Kaya keeps a scratch for the lattice egg: 14 openings, stop before the grey. The scratch is a small struct, not a column.",
            teaches: [
                "A transient property can hold a struct that is not a column.",
                "A new context reads the default scratch. The bowl name is filed."
            ]
        ) {
            if let bowl {
                ScratchFields(
                    bowl: bowl,
                    liveScratch: liveScratch,
                    filedName: filedName,
                    filedScratch: filedScratch,
                    columns: columns
                )
                if filedName.isEmpty {
                    Button("File the bowl card") {
                        file(bowl)
                    }
                }
            } else {
                Button("Open the scratch card") {
                    open()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func open() {
        let bowl = LatticeBowl(
            bowlName: "Lattice egg",
            carverName: "Nesrin Kaya",
            carvedOn: GregorianDay.date(year: 2026, month: 4, day: 6, timeZoneIdentifier: "Europe/Istanbul"),
            scratch: LatticeScratch(openings: 14, note: "Stop before the grey")
        )
        modelContext.insert(bowl)
        columns = StoredAttribute.propertyNames(on: "LatticeBowl", in: modelContext.container.schema).joined(separator: ", ")
        self.bowl = bowl
    }

    private func file(_ bowl: LatticeBowl) {
        try? modelContext.save()
        liveScratch = scratchLine(bowl.scratch)
        let filed = (try? ModelContext(modelContext.container).fetch(FetchDescriptor<LatticeBowl>()))?.first
        filedName = filed?.bowlName ?? "Missing"
        filedScratch = filed.map { scratchLine($0.scratch) } ?? "Missing"
    }

    private func scratchLine(_ scratch: LatticeScratch) -> String {
        let note = scratch.note.isEmpty ? "empty note" : scratch.note
        return "\(scratch.openings) openings, \(note)"
    }
}

private struct ScratchFields: View {
    let bowl: LatticeBowl
    let liveScratch: String
    let filedName: String
    let filedScratch: String
    let columns: String

    var body: some View {
        Section(bowl.bowlName) {
            LabeledContent("Carver", value: bowl.carverName)
            LabeledContent("Columns", value: columns)
            LabeledContent("Scratch on this card", value: liveScratch.isEmpty ? "\(bowl.scratch.openings) openings, \(bowl.scratch.note)" : liveScratch)
        }
        if !filedName.isEmpty {
            Section("Filed card") {
                LabeledContent("Bowl", value: filedName)
                LabeledContent("Scratch", value: filedScratch)
            }
        }
        Section {
            Text("Cemil Arslan cuts the oxhide case.")
                .foregroundStyle(.secondary)
        }
    }
}
