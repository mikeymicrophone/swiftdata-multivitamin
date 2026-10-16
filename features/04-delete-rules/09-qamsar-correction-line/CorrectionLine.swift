// Feature: Delete rules
// Slot 09 — Qamsar correction line
// Teaches:
// - The cook cascades to its slips, and each slip cascades to its correction.
// - Voiding the cook removes the slips and the corrections.

import SwiftData
import SwiftUI

@Model
final class CorrectionNote {
    var line: String
    var slip: TasteLine?

    init(line: String) {
        self.line = line
    }
}

@Model
final class TasteLine {
    var line: String
    var cook: LineCook?
    @Relationship(deleteRule: .cascade, inverse: \CorrectionNote.slip)
    var correction: CorrectionNote?

    init(line: String) {
        self.line = line
    }
}

@Model
final class LineCook {
    var lotCode: String
    var distillerName: String
    @Relationship(deleteRule: .cascade, inverse: \TasteLine.cook)
    var lines: [TasteLine] = []

    init(lotCode: String, distillerName: String) {
        self.lotCode = lotCode
        self.distillerName = distillerName
    }
}

struct CorrectionLineScreen: View {
    var body: some View {
        CorrectionLineEditor()
            .inMemoryStore(for: LineCook.self, TasteLine.self, CorrectionNote.self)
    }
}

private struct CorrectionLineEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cook: LineCook?
    @State private var cookCount = -1
    @State private var lineCount = -1
    @State private var noteCount = -1

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 09",
            title: "Qamsar correction line",
            situation: "The same day each slip has a correction under it. Clear was corrected to 'bright'. Voiding QS-22 pulls the slips and those corrections.",
            teaches: [
                "The cook cascades to its slips, and each slip cascades to its correction.",
                "Voiding the cook removes the slips and the corrections."
            ]
        ) {
            if let cook {
                NoteFields(cook: cook, cookCount: cookCount, lineCount: lineCount, noteCount: noteCount)
                if cookCount < 0 {
                    Button("Void the cook card") {
                        voidCook(cook)
                    }
                }
            } else {
                Button("File the corrections") {
                    fileNotes()
                }
            }
        }
    }

    private func fileNotes() {
        let cook = LineCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let clear = TasteLine(line: "Clear")
        let rose = TasteLine(line: "Long rose")
        let bright = CorrectionNote(line: "Bright")
        let shorter = CorrectionNote(line: "Shorter rose")
        modelContext.insert(cook)
        modelContext.insert(clear)
        modelContext.insert(rose)
        modelContext.insert(bright)
        modelContext.insert(shorter)
        cook.lines.append(clear)
        cook.lines.append(rose)
        clear.correction = bright
        rose.correction = shorter
        try? modelContext.save()
        self.cook = cook
    }

    private func voidCook(_ cook: LineCook) {
        modelContext.delete(cook)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        cookCount = (try? filed.fetchCount(FetchDescriptor<LineCook>())) ?? 0
        lineCount = (try? filed.fetchCount(FetchDescriptor<TasteLine>())) ?? 0
        noteCount = (try? filed.fetchCount(FetchDescriptor<CorrectionNote>())) ?? 0
    }
}

private struct NoteFields: View {
    let cook: LineCook
    let cookCount: Int
    let lineCount: Int
    let noteCount: Int

    var body: some View {
        Section(cook.lotCode) {
            LabeledContent("Distiller", value: cook.distillerName)
            LabeledContent("Slips", value: cook.lines.map(\.line).joined(separator: ", "))
        }
        if cookCount >= 0 {
            Section("Filed book") {
                LabeledContent("Cooks", value: "\(cookCount)")
                LabeledContent("Slips", value: "\(lineCount)")
                LabeledContent("Corrections", value: "\(noteCount)")
            }
        }
        Section {
            Text("Maryam Farahi's tray in Yazd names this lot on its place cards.")
                .foregroundStyle(.secondary)
        }
    }
}
