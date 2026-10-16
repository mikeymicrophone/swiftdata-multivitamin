// Feature: @Model basics
// Slot 04 — Barcelona bone black
// Teaches:
// - A default value is the stored starting value.
// - The caller can override a default without a second type.

import SwiftData
import SwiftUI

@Model
final class BoneBlackBatch {
    var pigmentName: String
    var grindPasses: Int
    var approved: Bool
    var openedOn: Date

    static let housePigmentName = "bone black"
    static let houseGrindPasses = 4
    static let houseApproved = false

    init(
        pigmentName: String = BoneBlackBatch.housePigmentName,
        grindPasses: Int = BoneBlackBatch.houseGrindPasses,
        approved: Bool = BoneBlackBatch.houseApproved,
        openedOn: Date
    ) {
        self.pigmentName = pigmentName
        self.grindPasses = grindPasses
        self.approved = approved
        self.openedOn = openedOn
    }

    func restoreHouseFormula() {
        pigmentName = Self.housePigmentName
        grindPasses = Self.houseGrindPasses
        approved = Self.houseApproved
    }
}

struct BoneBlackBatchScreen: View {
    var body: some View {
        BoneBlackBatchEditor()
            .inMemoryStore(for: BoneBlackBatch.self)
    }
}

private struct BoneBlackBatchEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var batch: BoneBlackBatch?

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 04",
            title: "Barcelona bone black",
            situation: "Joana Puig opens batch BP-19 at the Poblenou mill. An unordered batch starts as bone black, four passes, not yet approved.",
            teaches: [
                "A default value is the stored starting value.",
                "The caller can override a default without a second type."
            ]
        ) {
            if let batch {
                BatchFields(batch: batch)
            } else {
                Button("Open the house batch") {
                    openBatch()
                }
            }
        }
    }

    private func openBatch() {
        let batch = BoneBlackBatch(
            openedOn: GregorianDay.date(year: 2026, month: 3, day: 8, timeZoneIdentifier: "Europe/Madrid")
        )
        modelContext.insert(batch)
        self.batch = batch
    }
}

private struct BatchFields: View {
    @Bindable var batch: BoneBlackBatch

    var body: some View {
        Section("BP-19") {
            TextField("Pigment", text: $batch.pigmentName)
            Stepper(value: $batch.grindPasses, in: 1...12) {
                Text("Grind passes: \(batch.grindPasses)")
            }
            Toggle("Approved for the quince impressions", isOn: $batch.approved)
            LabeledContent("Opened", value: batch.openedOn.formatted(date: .long, time: .omitted))
            Button("Restore the house formula") {
                batch.restoreHouseFormula()
            }
        }

        Section("On the jar") {
            Text("\(batch.pigmentName), \(batch.grindPasses) passes, \(batch.approved ? "approved" : "not approved").")
        }

        Section {
            Text("This jar is for the quince impressions, once Fabriano's sheets are damp.")
                .foregroundStyle(.secondary)
        }
    }
}
