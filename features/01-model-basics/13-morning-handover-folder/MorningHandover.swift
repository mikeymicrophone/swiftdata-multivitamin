// Feature: @Model basics
// Slot 13 — Morning handover folder
// Teaches:
// - A schema can hold several model classes at once.
// - The screen joins them. The models still do not point at each other.

import SwiftData
import SwiftUI

enum MorningFolder {
    static let types: [any PersistentModel.Type] = [
        QuinceCommission.self,
        RagDampSlip.self,
        PlateJob.self,
        ShelfCard.self
    ]
}

struct MorningHandoverScreen: View {
    private let container: ModelContainer

    init() {
        do {
            container = try MemoryStore.make(MorningFolder.types)
        } catch {
            fatalError("In-memory store failed: \(error)")
        }
    }

    var body: some View {
        MorningHandoverEditor()
            .modelContainer(container)
    }
}

private struct MorningHandoverEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var commission: QuinceCommission?
    @State private var dampSlip: RagDampSlip?
    @State private var plateJob: PlateJob?
    @State private var shelfCard: ShelfCard?

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 13",
            title: "Morning handover folder",
            situation: "On 21 March, Nino Beridze lays four slips on the desk before the study day. Each slip is its own model. The folder is the screen.",
            teaches: [
                "A schema can hold several model classes at once.",
                "The screen joins them. The models still do not point at each other."
            ]
        ) {
            if let commission, let dampSlip, let plateJob, let shelfCard {
                Section("Commission") {
                    Text("\(commission.curatorName): \(commission.plateCount) plates, \(commission.impressionCount) impressions of \(commission.studyTitle).")
                }

                Section("Damp pack") {
                    Text("\(dampSlip.sheetCount) sheets, \(dampSlip.dampPercent.formatted(.number.precision(.fractionLength(1))))% damp, \(dampSlip.ragDescription).")
                }

                Section("Plate job") {
                    Text("\(plateJob.jobCode) is \(plateJob.state), kept by \(plateJob.keeperName).")
                }

                Section("Shelf card") {
                    Text("\(shelfCard.sellerName) asks \(shelfCard.askingPriceLari) lari at the \(shelfCard.shopName).")
                }

                Section("Across the desk") {
                    Text("\(commission.studyTitle) — \(plateJob.state), \(dampSlip.sheetCount) sheets damp, \(shelfCard.askingPriceLari) lari on the overrun.")
                }
            } else {
                Button("Lay out the morning folder") {
                    layOutFolder()
                }
            }
        }
    }

    private func layOutFolder() {
        let commission = QuinceCommission(
            roomName: "Works on Paper, Georgian National Museum",
            curatorName: "Nino Beridze",
            studyTitle: "Quince branch, Vera courtyard",
            plateCount: 6,
            impressionCount: 40,
            orderedOn: GregorianDay.date(year: 2026, month: 3, day: 3, timeZoneIdentifier: "Asia/Tbilisi")
        )
        let dampSlip = RagDampSlip(
            ragDescription: "Cotton offcuts from the Prato mills",
            sheetCount: 80,
            dampPercent: 42.5,
            sized: true,
            dampedOn: GregorianDay.date(year: 2026, month: 3, day: 9, timeZoneIdentifier: "Europe/Rome")
        )
        let plateJob = PlateJob(
            jobCode: "HV-6",
            plateCode: "HV-6",
            state: "in the Works on Paper room",
            keeperName: "Mariam Gelashvili"
        )
        let shelfCard = ShelfCard(
            shopName: "Vera District Print Room",
            sellerName: "Luka Katsitadze",
            studyTitle: "Quince branch, Vera courtyard",
            askingPriceLari: 90
        )
        modelContext.insert(commission)
        modelContext.insert(dampSlip)
        modelContext.insert(plateJob)
        modelContext.insert(shelfCard)
        self.commission = commission
        self.dampSlip = dampSlip
        self.plateJob = plateJob
        self.shelfCard = shelfCard
    }
}
