// Feature: @Transient
// Slot 13 — Bedesten morning folder
// Teaches:
// - One schema holds the four cards, and each aside is omitted.
// - A new context files the four desk facts and reads each default aside.

import SwiftData
import SwiftUI

enum PipeFolder {
    static let types: [any PersistentModel.Type] = [
        SepetciLump.self,
        CarvedBowl.self,
        WaxCook.self,
        StemFit.self
    ]
}

struct PipeHandoverScreen: View {
    private let container: ModelContainer

    init() {
        do {
            container = try MemoryStore.make(PipeFolder.types)
        } catch {
            fatalError("In-memory store failed: \(error)")
        }
    }

    var body: some View {
        PipeHandoverEditor()
            .modelContainer(container)
    }
}

private struct PipeHandoverEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var columns = ""
    @State private var liveLines = ""
    @State private var filedLines = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 13",
            title: "Bedesten morning folder",
            situation: "On 14 April, before Emre Yılmaz collects pipe EB-7, Aylin Şahin lays out the lump, the bowl, the wax lot, and the stem. Each aside is still on the open card.",
            teaches: [
                "One schema holds the four cards, and each aside is omitted.",
                "A new context files the four desk facts and reads each default aside."
            ]
        ) {
            if columns.isEmpty {
                Button("Lay out the four cards") {
                    layOut()
                }
            } else {
                FolderFields(columns: columns, liveLines: liveLines, filedLines: filedLines)
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func layOut() {
        let lump = SepetciLump(
            lumpCode: "EB-7",
            cutterName: "Kemal Aydın",
            grams: 180,
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 2, timeZoneIdentifier: "Europe/Istanbul"),
            seamNote: "Avoid the grey seam"
        )
        let bowl = CarvedBowl(
            bowlName: "Lattice egg",
            carverName: "Nesrin Kaya",
            carvedOn: GregorianDay.date(year: 2026, month: 4, day: 3, timeZoneIdentifier: "Europe/Istanbul"),
            openings: 14
        )
        let cook = WaxCook(
            lotCode: "WX-7",
            waxerName: "Yusuf Demir",
            cookedOn: GregorianDay.date(year: 2026, month: 4, day: 4, timeZoneIdentifier: "Europe/Istanbul"),
            whisper: "Cooler than yesterday"
        )
        let stem = StemFit(
            wood: "Cherry",
            fitterName: "Halime Öztürk",
            fittedOn: GregorianDay.date(year: 2026, month: 4, day: 5, timeZoneIdentifier: "Europe/Istanbul"),
            nick: "Tight on the tenon"
        )
        modelContext.insert(lump)
        modelContext.insert(bowl)
        modelContext.insert(cook)
        modelContext.insert(stem)
        try? modelContext.save()
        let schema = modelContext.container.schema
        columns = ["SepetciLump", "CarvedBowl", "WaxCook", "StemFit"]
            .map { name in
                "\(name): \(StoredAttribute.propertyNames(on: name, in: schema).joined(separator: ", "))"
            }
            .joined(separator: "\n")
        liveLines = [
            "\(lump.lumpCode), \(lump.seamNote)",
            "\(bowl.bowlName), \(bowl.openings) openings",
            "\(cook.lotCode), \(cook.whisper ?? "Unspoken")",
            "\(stem.wood), \(stem.nick)"
        ].joined(separator: "\n")
        let filed = ModelContext(modelContext.container)
        let filedLump = (try? filed.fetch(FetchDescriptor<SepetciLump>()))?.first
        let filedBowl = (try? filed.fetch(FetchDescriptor<CarvedBowl>()))?.first
        let filedCook = (try? filed.fetch(FetchDescriptor<WaxCook>()))?.first
        let filedStem = (try? filed.fetch(FetchDescriptor<StemFit>()))?.first
        filedLines = [
            "\(filedLump?.lumpCode ?? "Missing"), \(filedLump?.seamNote.isEmpty == false ? filedLump?.seamNote ?? "" : "empty note")",
            "\(filedBowl?.bowlName ?? "Missing"), \(filedBowl?.openings ?? -1) openings",
            "\(filedCook?.lotCode ?? "Missing"), \(filedCook?.whisper ?? "Unspoken")",
            "\(filedStem?.wood ?? "Missing"), \(filedStem?.nick ?? "Missing")"
        ].joined(separator: "\n")
    }
}

private struct FolderFields: View {
    let columns: String
    let liveLines: String
    let filedLines: String

    var body: some View {
        Section("Columns") {
            Text(columns)
        }
        Section("On the counter") {
            Text(liveLines)
        }
        Section("Read again") {
            Text(filedLines)
        }
        Section {
            Text("Emre Yılmaz collects pipe EB-7 that evening.")
                .foregroundStyle(.secondary)
        }
    }
}
