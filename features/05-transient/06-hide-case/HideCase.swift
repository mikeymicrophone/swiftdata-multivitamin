// Feature: @Transient
// Slot 06 — Hide case
// Teaches:
// - Two transient properties are both omitted from the schema.
// - A new context resets both. The leather grade is filed.

import SwiftData
import SwiftUI

@Model
final class HideCase {
    var grade: String
    var makerName: String
    var cutOn: Date
    @Transient var stitchAside: String = ""
    @Transient var spareThongs: Int = 0

    init(grade: String, makerName: String, cutOn: Date, stitchAside: String = "", spareThongs: Int = 0) {
        self.grade = grade
        self.makerName = makerName
        self.cutOn = cutOn
        self.stitchAside = stitchAside
        self.spareThongs = spareThongs
    }
}

struct HideCaseScreen: View {
    private let container = MemoryStore.containerOrCrash(HideCase.self)

    var body: some View {
        HideCaseEditor()
            .modelContainer(container)
    }
}

private struct HideCaseEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var hide: HideCase?
    @State private var columns = ""
    @State private var liveLine = ""
    @State private var filedGrade = ""
    @State private var filedLine = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 06",
            title: "Hide case",
            situation: "On 7 April Cemil Arslan cuts an oxhide case for pipe EB-7. He sets aside three spare thongs and says the stitch should stay proud of the seam.",
            teaches: [
                "Two transient properties are both omitted from the schema.",
                "A new context resets both. The leather grade is filed."
            ]
        ) {
            if let hide {
                CaseFields(hide: hide, columns: columns, liveLine: liveLine, filedGrade: filedGrade, filedLine: filedLine)
                if filedGrade.isEmpty {
                    Button("File the case card") {
                        file(hide)
                    }
                }
            } else {
                Button("Open the case card") {
                    open()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func open() {
        let hide = HideCase(
            grade: "Oxhide",
            makerName: "Cemil Arslan",
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 7, timeZoneIdentifier: "Europe/Istanbul"),
            stitchAside: "Stay proud of the seam",
            spareThongs: 3
        )
        modelContext.insert(hide)
        columns = StoredAttribute.propertyNames(on: "HideCase", in: modelContext.container.schema).joined(separator: ", ")
        self.hide = hide
    }

    private func file(_ hide: HideCase) {
        try? modelContext.save()
        liveLine = "\(hide.spareThongs) thongs, \(hide.stitchAside)"
        let filed = (try? ModelContext(modelContext.container).fetch(FetchDescriptor<HideCase>()))?.first
        filedGrade = filed?.grade ?? "Missing"
        if let filed {
            let aside = filed.stitchAside.isEmpty ? "empty aside" : filed.stitchAside
            filedLine = "\(filed.spareThongs) thongs, \(aside)"
        }
    }
}

private struct CaseFields: View {
    let hide: HideCase
    let columns: String
    let liveLine: String
    let filedGrade: String
    let filedLine: String

    var body: some View {
        Section(hide.grade) {
            LabeledContent("Maker", value: hide.makerName)
            LabeledContent("Cut", value: hide.cutOn.formatted(date: .long, time: .omitted))
            LabeledContent("Columns", value: columns)
            LabeledContent("On this card", value: liveLine.isEmpty ? "\(hide.spareThongs) thongs, \(hide.stitchAside)" : liveLine)
        }
        if !filedGrade.isEmpty {
            Section("Filed card") {
                LabeledContent("Grade", value: filedGrade)
                LabeledContent("Scratch", value: filedLine)
            }
        }
        Section {
            Text("Aylin Şahin opens a counter card for pipe EB-7 in the bedesten.")
                .foregroundStyle(.secondary)
        }
    }
}
