// Feature: Relationships
// Slot 13 — Besançon morning folder
// Teaches:
// - One schema holds the pairs from the route.
// - After a save, each inverse still names the other side.

import SwiftData
import SwiftUI

enum ComteFolder {
    static let types: [any PersistentModel.Type] = [
        MilkNote.self,
        Fruitiere.self,
        VatWheel.self,
        MorningVat.self,
        CaveWheel.self,
        AgingCave.self,
        BoardWheel.self,
        SpruceBoard.self
    ]
}

struct ComteHandoverScreen: View {
    private let container: ModelContainer

    init() {
        do {
            container = try MemoryStore.make(ComteFolder.types)
        } catch {
            fatalError("In-memory store failed: \(error)")
        }
    }

    var body: some View {
        ComteHandoverEditor()
            .modelContainer(container)
    }
}

private struct ComteHandoverEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var laidOut = false
    @State private var fruitiereLine = ""
    @State private var vatLine = ""
    @State private var caveLine = ""
    @State private var boardLine = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 13",
            title: "Besançon morning folder",
            situation: "On 14 September Chantal Vercel lays the route on the counter at Fromagerie Vercel. Odile Marchand's supper is six days away. Each slip still points at the desk that holds it.",
            teaches: [
                "One schema holds the pairs from the route.",
                "After a save, each inverse still names the other side."
            ]
        ) {
            if laidOut {
                FolderFields(
                    fruitiereLine: fruitiereLine,
                    vatLine: vatLine,
                    caveLine: caveLine,
                    boardLine: boardLine
                )
            } else {
                Button("Lay out the folder") {
                    layOut()
                }
            }
        }
        .onAppear {
            modelContext.autosaveEnabled = false
        }
    }

    private func layOut() {
        let notedOn = GregorianDay.date(year: 2026, month: 9, day: 2, timeZoneIdentifier: "Europe/Paris")
        let fruitiere = Fruitiere(
            deskName: "Fruitière du Plateau de Plasne",
            cheesemakerName: "Lucien Morel"
        )
        let note = MilkNote(
            farmName: "Ferme Pellier, Plasne",
            farmerName: "Hélène Pellier",
            litres: 86,
            notedOn: notedOn
        )
        let vat = MorningVat(vatName: "Cuve du matin", cheesemakerName: "Lucien Morel")
        let vatWheel = VatWheel(code: "PL-19")
        let cave = AgingCave(caveName: "Cave d'affinage, Les Rousses", affineurName: "Claire Roux")
        let caveWheel = CaveWheel(code: "PL-19")
        let board = SpruceBoard(boardCode: "SP-2", millerName: "Marc Bouvet")
        let boardWheel = BoardWheel(code: "PL-19")

        modelContext.insert(fruitiere)
        modelContext.insert(note)
        modelContext.insert(vat)
        modelContext.insert(vatWheel)
        modelContext.insert(cave)
        modelContext.insert(caveWheel)
        modelContext.insert(board)
        modelContext.insert(boardWheel)
        note.fruitiere = fruitiere
        vatWheel.vat = vat
        cave.wheels.append(caveWheel)
        board.wheel = boardWheel
        try? modelContext.save()

        let filed = ModelContext(modelContext.container)
        let notes = (try? filed.fetch(FetchDescriptor<MilkNote>())) ?? []
        let wheels = (try? filed.fetch(FetchDescriptor<VatWheel>())) ?? []
        let caveWheels = (try? filed.fetch(FetchDescriptor<CaveWheel>())) ?? []
        let boards = (try? filed.fetch(FetchDescriptor<SpruceBoard>())) ?? []
        fruitiereLine = notes.first?.fruitiere?.deskName ?? "Unlinked"
        vatLine = wheels.first?.vat?.vatName ?? "Unlinked"
        caveLine = caveWheels.first?.cave?.caveName ?? "Unlinked"
        boardLine = boards.first.map { "\($0.boardCode) carries \($0.wheel?.code ?? "nothing")" } ?? "Unlinked"
        laidOut = true
    }
}

private struct FolderFields: View {
    let fruitiereLine: String
    let vatLine: String
    let caveLine: String
    let boardLine: String

    var body: some View {
        Section("Milk note") {
            Text(fruitiereLine)
        }
        Section("Morning vat") {
            Text(vatLine)
        }
        Section("Aged cave") {
            Text(caveLine)
        }
        Section("Spruce board") {
            Text(boardLine)
        }

        Section {
            Text("The supper is 20 September.")
                .foregroundStyle(.secondary)
        }
    }
}
