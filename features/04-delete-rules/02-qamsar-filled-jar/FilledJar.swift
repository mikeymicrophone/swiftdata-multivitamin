// Feature: Delete rules
// Slot 02 — Qamsar filled jar
// Teaches:
// - .nullify clears the link and keeps the jar.
// - The jar's litres are still on the card after a new context reads it.

import SwiftData
import SwiftUI

@Model
final class FilledJar {
    var jarCode: String
    var litres: Int
    var lot: DistillLot?

    init(jarCode: String, litres: Int) {
        self.jarCode = jarCode
        self.litres = litres
    }
}

@Model
final class DistillLot {
    var lotCode: String
    var distillerName: String
    @Relationship(deleteRule: .nullify, inverse: \FilledJar.lot)
    var jars: [FilledJar] = []

    init(lotCode: String, distillerName: String) {
        self.lotCode = lotCode
        self.distillerName = distillerName
    }
}

struct FilledJarScreen: View {
    private let container = MemoryStore.containerOrCrash(DistillLot.self, FilledJar.self)

    var body: some View {
        FilledJarEditor()
            .modelContainer(container)
    }
}

private struct FilledJarEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var lot: DistillLot?
    @State private var jarLine = ""
    @State private var lotCount = -1

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 02",
            title: "Qamsar filled jar",
            situation: "On 13 May Hossein Nazeri fills jar J-1 with 18 litres from cook QS-22. The lot card is withdrawn. The jar card stays.",
            teaches: [
                ".nullify clears the link and keeps the jar.",
                "The jar's litres are still on the card after a new context reads it."
            ]
        ) {
            if let lot {
                JarFields(lot: lot, schema: modelContext.container.schema, jarLine: jarLine, lotCount: lotCount)
                if lotCount < 0 {
                    Button("Withdraw the lot card") {
                        withdraw(lot)
                    }
                }
            } else {
                Button("Fill jar J-1") {
                    fillJar()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func fillJar() {
        let lot = DistillLot(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let jar = FilledJar(jarCode: "J-1", litres: 18)
        modelContext.insert(lot)
        modelContext.insert(jar)
        lot.jars.append(jar)
        try? modelContext.save()
        self.lot = lot
    }

    private func withdraw(_ lot: DistillLot) {
        modelContext.delete(lot)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        let jars = (try? filed.fetch(FetchDescriptor<FilledJar>())) ?? []
        let lots = (try? filed.fetch(FetchDescriptor<DistillLot>())) ?? []
        jarLine = jars.first.map { "\($0.jarCode), \($0.litres) litres, lot \($0.lot?.lotCode ?? "empty")" } ?? "No jar"
        lotCount = lots.count
    }
}

private struct JarFields: View {
    let lot: DistillLot
    let schema: Schema
    let jarLine: String
    let lotCount: Int

    var body: some View {
        Section(lot.lotCode) {
            LabeledContent("Distiller", value: lot.distillerName)
            LabeledContent("Rule", value: ruleTitle)
        }
        if lotCount >= 0 {
            Section("Filed book") {
                LabeledContent("Lots", value: "\(lotCount)")
                Text(jarLine)
            }
        }
        Section {
            Text("The tasting slips for QS-22 hang on the cook card.")
                .foregroundStyle(.secondary)
        }
    }

    private var ruleTitle: String {
        guard let rule = StoredRelationship.named("jars", on: "DistillLot", in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
