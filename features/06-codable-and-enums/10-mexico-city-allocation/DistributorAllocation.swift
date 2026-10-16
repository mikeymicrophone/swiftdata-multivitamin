// Feature: Codable and enums
// Slot 10 — Mexico City allocation
// Teaches:
// - A raw String column supports a predicate while a computed enum guides the desk.
// - Unknown distributor codes stay intact instead of silently becoming a known case.

import SwiftData
import SwiftUI

enum AllocationStage: String, Codable, CaseIterable {
    case reserved
    case packed
    case dispatched
}

@Model
final class DistributorAllocation {
    var distributorName: String
    var stageCode: String
    var cases: Int

    init(distributorName: String, stageCode: String, cases: Int) {
        self.distributorName = distributorName
        self.stageCode = stageCode
        self.cases = cases
    }

    var stage: AllocationStage? {
        get { AllocationStage(rawValue: stageCode) }
        set { if let newValue { stageCode = newValue.rawValue } }
    }

    static func packedQueue() -> FetchDescriptor<DistributorAllocation> {
        var queue = FetchDescriptor<DistributorAllocation>(
            predicate: #Predicate { $0.stageCode == "packed" },
            sortBy: [SortDescriptor(\DistributorAllocation.distributorName)]
        )
        queue.fetchLimit = 5
        return queue
    }
}

struct DistributorAllocationScreen: View {
    var body: some View {
        AllocationDesk().inMemoryStore(for: DistributorAllocation.self)
    }
}

private struct AllocationDesk: View {
    @Environment(\.modelContext) private var modelContext
    @State private var queue: [DistributorAllocation] = []
    @State private var unrecognized: [String] = []
    @State private var failure: String?

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 10",
            title: "Mexico City allocation",
            situation: "On 22 March Distribuidora del Sur in Mexico City packs eight cases of SC-26. Its Paris partner sends the unfamiliar code quai; the desk keeps that spelling for review.",
            teaches: [
                "A raw String column supports a predicate while a computed enum guides the desk.",
                "Unknown distributor codes stay intact instead of silently becoming a known case."
            ]
        ) {
            ForEach(queue) { allocation in
                LabeledContent(allocation.distributorName, value: "\(allocation.cases) packed cases")
            }
            ForEach(unrecognized, id: \.self) { Text("Review code: \($0)").foregroundStyle(.orange) }
            if let failure { Text(failure).foregroundStyle(.red) }
            Button("Read the packed queue") { readQueue() }
                .disabled(!queue.isEmpty)
        }
    }

    private func readQueue() {
        do {
            if try modelContext.fetchCount(FetchDescriptor<DistributorAllocation>()) == 0 {
                modelContext.insert(DistributorAllocation(distributorName: "Distribuidora del Sur", stageCode: "packed", cases: 8))
                modelContext.insert(DistributorAllocation(distributorName: "Cave des Terres, Paris", stageCode: "quai", cases: 4))
                try modelContext.save()
            }
            queue = try modelContext.freshFetch(DistributorAllocation.packedQueue())
            let allocations = try modelContext.freshFetch(FetchDescriptor<DistributorAllocation>())
            unrecognized = allocations.compactMap { $0.stage == nil ? $0.stageCode : nil }
        } catch { failure = error.localizedDescription }
    }
}
