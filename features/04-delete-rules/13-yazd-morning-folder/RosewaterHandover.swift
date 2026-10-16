// Feature: Delete rules
// Slot 13 — Yazd morning folder
// Teaches:
// - One save deletes four source cards, each under its own rule.
// - A new context shows the slips gone, the jar kept, the charged cook kept, and the chalk mark kept.

import SwiftData
import SwiftUI

enum RosewaterFolder {
    static let types: [any PersistentModel.Type] = [
        CookBatch.self,
        TasteSlip.self,
        DistillLot.self,
        FilledJar.self,
        CopperStill.self,
        ChargedCook.self,
        WallTally.self,
        ChalkMark.self
    ]
}

struct RosewaterHandoverScreen: View {
    private let container: ModelContainer

    init() {
        do {
            container = try MemoryStore.make(RosewaterFolder.types)
        } catch {
            fatalError("In-memory store failed: \(error)")
        }
    }

    var body: some View {
        RosewaterHandoverEditor()
            .modelContainer(container)
    }
}

private struct RosewaterHandoverEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var slipLine = ""
    @State private var jarLine = ""
    @State private var cookLine = ""
    @State private var markLine = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 13",
            title: "Yazd morning folder",
            situation: "On 20 May, before the Farahi supper, Maryam Farahi pulls four cards: the cook, the lot, the still, and the wall tally. Each rule has already been written on its list.",
            teaches: [
                "One save deletes four source cards, each under its own rule.",
                "A new context shows the slips gone, the jar kept, the charged cook kept, and the chalk mark kept."
            ]
        ) {
            if slipLine.isEmpty {
                Button("Pull the four cards") {
                    pullCards()
                }
            } else {
                FolderFields(slipLine: slipLine, jarLine: jarLine, cookLine: cookLine, markLine: markLine)
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func pullCards() {
        let cook = CookBatch(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let clear = TasteSlip(line: "Clear")
        let rose = TasteSlip(line: "Long rose")
        let lot = DistillLot(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let jar = FilledJar(jarCode: "J-1", litres: 18)
        let still = CopperStill(stillName: "Still 2", smithName: "Farhad Golshan")
        let charged = ChargedCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let tally = WallTally(wallName: "Still-house wall, Qamsar", distillerName: "Hossein Nazeri")
        let mark = ChalkMark(lotCode: "QS-22")
        modelContext.insert(cook)
        modelContext.insert(clear)
        modelContext.insert(rose)
        modelContext.insert(lot)
        modelContext.insert(jar)
        modelContext.insert(still)
        modelContext.insert(charged)
        modelContext.insert(tally)
        modelContext.insert(mark)
        cook.slips.append(clear)
        cook.slips.append(rose)
        lot.jars.append(jar)
        still.cooks.append(charged)
        tally.marks.append(mark)
        try? modelContext.save()
        modelContext.delete(cook)
        modelContext.delete(lot)
        modelContext.delete(still)
        modelContext.delete(tally)
        try? modelContext.save()

        let filed = ModelContext(modelContext.container)
        let slips = (try? filed.fetch(FetchDescriptor<TasteSlip>())) ?? []
        let jars = (try? filed.fetch(FetchDescriptor<FilledJar>())) ?? []
        let cooks = (try? filed.fetch(FetchDescriptor<ChargedCook>())) ?? []
        let marks = (try? filed.fetch(FetchDescriptor<ChalkMark>())) ?? []
        slipLine = "Slips \(slips.count)"
        jarLine = jars.first.map { "\($0.jarCode), \($0.litres) litres, lot \($0.lot?.lotCode ?? "empty")" } ?? "No jar"
        cookLine = cooks.first.map { "\($0.lotCode), still \($0.still?.stillName ?? "empty")" } ?? "No cook"
        markLine = marks.first.map { "\($0.lotCode), tally \($0.tally?.wallName ?? "empty")" } ?? "No mark"
    }
}

private struct FolderFields: View {
    let slipLine: String
    let jarLine: String
    let cookLine: String
    let markLine: String

    var body: some View {
        Section("Cook slips") { Text(slipLine) }
        Section("Filled jar") { Text(jarLine) }
        Section("Charged cook") { Text(cookLine) }
        Section("Chalk mark") { Text(markLine) }
        Section {
            Text("The supper is this evening.")
                .foregroundStyle(.secondary)
        }
    }
}
