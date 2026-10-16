// Feature: Delete rules
// Slot 11 — Yazd sister jar
// Teaches:
// - .nullify on the jar clears that jar's line on the lot.
// - The lot and the sister jar stay, and the sister jar still names QS-22.

import SwiftData
import SwiftUI

@Model
final class JarLot {
    var lotCode: String
    var litres: Int
    var jars: [RoseJar] = []

    init(lotCode: String, litres: Int) {
        self.lotCode = lotCode
        self.litres = litres
    }
}

@Model
final class RoseJar {
    var jarCode: String
    @Relationship(deleteRule: .nullify, inverse: \JarLot.jars)
    var lot: JarLot?

    init(jarCode: String) {
        self.jarCode = jarCode
    }
}

struct SisterJarScreen: View {
    private let container = MemoryStore.containerOrCrash(JarLot.self, RoseJar.self)

    var body: some View {
        SisterJarEditor()
            .modelContainer(container)
    }
}

private struct SisterJarEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cracked: RoseJar?
    @State private var lotLine = ""
    @State private var jarLine = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 11",
            title: "Yazd sister jar",
            situation: "On 19 May at Shirini Farahi, jar J-1 cracks. Jar J-2 is the same lot, QS-22, 18 litres.",
            teaches: [
                ".nullify on the jar clears that jar's line on the lot.",
                "The lot and the sister jar stay, and the sister jar still names QS-22."
            ]
        ) {
            if let cracked {
                SisterFields(cracked: cracked, lotLine: lotLine, jarLine: jarLine)
                if lotLine.isEmpty {
                    Button("Strike jar J-1") {
                        strike(cracked)
                    }
                }
            } else {
                Button("Set both jars on the lot") {
                    setJars()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func setJars() {
        let lot = JarLot(lotCode: "QS-22", litres: 18)
        let first = RoseJar(jarCode: "J-1")
        let second = RoseJar(jarCode: "J-2")
        modelContext.insert(lot)
        modelContext.insert(first)
        modelContext.insert(second)
        first.lot = lot
        second.lot = lot
        try? modelContext.save()
        cracked = first
    }

    private func strike(_ jar: RoseJar) {
        modelContext.delete(jar)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        let lots = (try? filed.fetch(FetchDescriptor<JarLot>())) ?? []
        let jars = (try? filed.fetch(FetchDescriptor<RoseJar>())) ?? []
        lotLine = lots.first.map { "\($0.lotCode), \($0.litres) litres" } ?? "No lot"
        jarLine = jars.map { "\($0.jarCode) → \($0.lot?.lotCode ?? "empty")" }.sorted().joined(separator: ", ")
    }
}

private struct SisterFields: View {
    let cracked: RoseJar
    let lotLine: String
    let jarLine: String

    var body: some View {
        Section(cracked.jarCode) {
            LabeledContent("Lot", value: cracked.lot?.lotCode ?? "None")
            LabeledContent("Litres on the lot", value: "\(cracked.lot?.litres ?? 0)")
        }
        if !lotLine.isEmpty {
            Section("Filed book") {
                Text(lotLine)
                Text(jarLine)
            }
        }
        Section {
            Text("A blank cook card, with no slips yet, is voided back in Qamsar.")
                .foregroundStyle(.secondary)
        }
    }
}
