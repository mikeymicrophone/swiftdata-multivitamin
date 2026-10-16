// Feature: @Transient
// Slot 01 — Sepetçi lump card
// Teaches:
// - The seam note is absent from the schema.
// - The lump code is a column.

import SwiftData
import SwiftUI

@Model
final class SepetciLump {
    var lumpCode: String
    var cutterName: String
    var grams: Int
    var cutOn: Date
    @Transient var seamNote: String = ""

    init(lumpCode: String, cutterName: String, grams: Int, cutOn: Date, seamNote: String = "") {
        self.lumpCode = lumpCode
        self.cutterName = cutterName
        self.grams = grams
        self.cutOn = cutOn
        self.seamNote = seamNote
    }
}

struct SepetciLumpScreen: View {
    var body: some View {
        SepetciLumpEditor()
            .inMemoryStore(for: SepetciLump.self)
    }
}

private struct SepetciLumpEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var lump: SepetciLump?
    @State private var filedCode = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 01",
            title: "Sepetçi lump card",
            situation: "On 2 April Kemal Aydın cuts lump EB-7 at the pit in Sepetçi, 180 grams. He says to avoid the grey seam. That sentence is not a column.",
            teaches: [
                "The seam note is absent from the schema.",
                "The lump code is a column."
            ]
        ) {
            if let lump {
                LumpFields(lump: lump, schema: modelContext.container.schema, filedCode: filedCode)
                if filedCode.isEmpty {
                    Button("File the lump card") {
                        file(lump)
                    }
                }
            } else {
                Button("Open the lump card") {
                    open()
                }
            }
        }
    }

    private func open() {
        let lump = SepetciLump(
            lumpCode: "EB-7",
            cutterName: "Kemal Aydın",
            grams: 180,
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 2, timeZoneIdentifier: "Europe/Istanbul"),
            seamNote: "Avoid the grey seam"
        )
        modelContext.insert(lump)
        self.lump = lump
    }

    private func file(_ lump: SepetciLump) {
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        filedCode = (try? filed.fetch(FetchDescriptor<SepetciLump>()))?.first?.lumpCode ?? "Missing"
    }
}

private struct LumpFields: View {
    let lump: SepetciLump
    let schema: Schema
    let filedCode: String

    var body: some View {
        Section(lump.lumpCode) {
            LabeledContent("Cutter", value: lump.cutterName)
            LabeledContent("Grams", value: "\(lump.grams)")
            LabeledContent("Cut", value: lump.cutOn.formatted(date: .long, time: .omitted))
            LabeledContent("Seam note", value: lump.seamNote)
            LabeledContent("Columns", value: columns)
            LabeledContent("Seam note column", value: seamColumn)
        }
        if !filedCode.isEmpty {
            Section("Filed card") {
                LabeledContent("Lump", value: filedCode)
            }
        }
        Section {
            Text("Nesrin Kaya starts the lattice egg in Odunpazarı.")
                .foregroundStyle(.secondary)
        }
    }

    private var columns: String {
        StoredAttribute.propertyNames(on: "SepetciLump", in: schema).joined(separator: ", ")
    }

    private var seamColumn: String {
        StoredAttribute.propertyNames(on: "SepetciLump", in: schema).contains("seamNote") ? "Column" : "Absent"
    }
}
