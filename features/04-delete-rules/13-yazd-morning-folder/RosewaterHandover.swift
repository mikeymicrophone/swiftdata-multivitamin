// Feature: Delete rules
// Slot 13 — Yazd morning folder
// Teaches:
// - One save on a @ModelActor deletes four source cards, each under its own rule.
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

/// What the auditor hands back across the actor boundary. Model objects stay behind.
struct FolderAudit: Sendable {
    let slipCount: Int
    let jarLine: String
    let cookLine: String
    let markLine: String
}

@ModelActor
actor FolderAuditor {
    func pull(_ sourceIDs: [PersistentIdentifier]) throws -> FolderAudit {
        for id in sourceIDs {
            modelContext.delete(modelContext.model(for: id))
        }
        try modelContext.save()

        let jar = try modelContext.fetch(FetchDescriptor<FilledJar>()).first
        let cook = try modelContext.fetch(FetchDescriptor<ChargedCook>()).first
        let mark = try modelContext.fetch(FetchDescriptor<ChalkMark>()).first
        return FolderAudit(
            slipCount: try modelContext.fetchCount(FetchDescriptor<TasteSlip>()),
            jarLine: jar.map { "\($0.jarCode), \($0.litres) litres, lot \($0.lot?.lotCode ?? "empty")" } ?? "No jar",
            cookLine: cook.map { "\($0.lotCode), still \($0.still?.stillName ?? "empty")" } ?? "No cook",
            markLine: mark.map { "\($0.lotCode), tally \($0.tally?.wallName ?? "empty")" } ?? "No mark"
        )
    }
}

struct RosewaterHandoverScreen: View {
    var body: some View {
        RosewaterHandoverEditor()
            .inMemoryStore(for: RosewaterFolder.types)
    }
}

private struct RosewaterHandoverEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var sourceIDs: [PersistentIdentifier] = []
    @State private var audit: FolderAudit?
    @State private var failure: String?

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 13",
            title: "Yazd morning folder",
            situation: "On 20 May, before the Farahi supper, Maryam Farahi pulls four cards: the cook, the lot, the still, and the wall tally. Each rule has already been written on its list.",
            teaches: [
                "One save on a @ModelActor deletes four source cards, each under its own rule.",
                "A new context shows the slips gone, the jar kept, the charged cook kept, and the chalk mark kept."
            ]
        ) {
            if let audit {
                FolderFields(audit: audit)
            } else if let failure {
                Text(failure).foregroundStyle(.red)
            } else if sourceIDs.isEmpty {
                Button("Pull the four cards") {
                    sourceIDs = hangFolder()
                }
            } else {
                ProgressView("Pulling the four cards")
            }
        }
        .task(id: sourceIDs) {
            guard !sourceIDs.isEmpty else { return }
            let auditor = FolderAuditor(modelContainer: modelContext.container)
            do {
                audit = try await auditor.pull(sourceIDs)
            } catch {
                failure = "The folder was not pulled: \(error.localizedDescription)"
            }
        }
    }

    /// Files the whole graph on the main context and returns the four cards to pull.
    private func hangFolder() -> [PersistentIdentifier] {
        let cook = CookBatch(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let lot = DistillLot(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let still = CopperStill(stillName: "Still 2", smithName: "Farhad Golshan")
        let tally = WallTally(wallName: "Still-house wall, Qamsar", distillerName: "Hossein Nazeri")
        let sources: [any PersistentModel] = [cook, lot, still, tally]
        sources.forEach { modelContext.insert($0) }

        cook.slips = [TasteSlip(line: "Clear"), TasteSlip(line: "Long rose")]
        lot.jars = [FilledJar(jarCode: "J-1", litres: 18)]
        still.cooks = [ChargedCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")]
        tally.marks = [ChalkMark(lotCode: "QS-22")]
        try? modelContext.save()
        return sources.map { $0.persistentModelID }
    }
}

private struct FolderFields: View {
    let audit: FolderAudit

    var body: some View {
        Section("Cook slips") { Text("Slips \(audit.slipCount)") }
        Section("Filled jar") { Text(audit.jarLine) }
        Section("Charged cook") { Text(audit.cookLine) }
        Section("Chalk mark") { Text(audit.markLine) }
        Section {
            Text("The supper is this evening.")
                .foregroundStyle(.secondary)
        }
    }
}
