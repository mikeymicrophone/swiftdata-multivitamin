// Feature: @Transient
// Slot 10 — Twin lumps
// Teaches:
// - Each open card keeps its own seam note.
// - A new context defaults both notes. Both lump codes are filed.

import SwiftData
import SwiftUI

struct TwinLumpScreen: View {
    var body: some View {
        TwinLumpEditor()
            .inMemoryStore(for: SepetciLump.self)
    }
}

private struct TwinLumpEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var liveLines = ""
    @State private var filedLines = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 10",
            title: "Twin lumps",
            situation: "On 11 April Kemal Aydın cuts spare lump EB-8, 210 grams, while EB-7 is already at the bedesten. Each card keeps the seam note he gave it.",
            teaches: [
                "Each open card keeps its own seam note.",
                "A new context defaults both notes. Both lump codes are filed."
            ]
        ) {
            if liveLines.isEmpty {
                Button("File both lump cards") {
                    fileBoth()
                }
            } else {
                TwinFields(liveLines: liveLines, filedLines: filedLines)
            }
        }
    }

    private func fileBoth() {
        let first = SepetciLump(
            lumpCode: "EB-7",
            cutterName: "Kemal Aydın",
            grams: 180,
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 2, timeZoneIdentifier: "Europe/Istanbul"),
            seamNote: "Avoid the grey seam"
        )
        let spare = SepetciLump(
            lumpCode: "EB-8",
            cutterName: "Kemal Aydın",
            grams: 210,
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 11, timeZoneIdentifier: "Europe/Istanbul"),
            seamNote: "Clear at the foot"
        )
        modelContext.insert(first)
        modelContext.insert(spare)
        try? modelContext.save()
        let open = (try? modelContext.fetch(FetchDescriptor<SepetciLump>())) ?? []
        liveLines = line(open)
        let filed = (try? ModelContext(modelContext.container).fetch(FetchDescriptor<SepetciLump>())) ?? []
        filedLines = line(filed)
    }

    private func line(_ lumps: [SepetciLump]) -> String {
        lumps
            .sorted { $0.lumpCode < $1.lumpCode }
            .map { lump in
                let note = lump.seamNote.isEmpty ? "empty note" : lump.seamNote
                return "\(lump.lumpCode), \(note)"
            }
            .joined(separator: "\n")
    }
}

private struct TwinFields: View {
    let liveLines: String
    let filedLines: String

    var body: some View {
        Section("On these cards") {
            Text(liveLines)
        }
        Section("Filed cards") {
            Text(filedLines)
        }
        Section {
            Text("Yusuf's wax card and Halime's stem card are read in one book.")
                .foregroundStyle(.secondary)
        }
    }
}
