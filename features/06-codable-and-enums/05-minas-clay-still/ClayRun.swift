// Feature: Codable and enums
// Slot 05 — Minas clay still
// Teaches:
// - An Int-backed Codable enum stores the distillation pass.
// - Query the primitive lot code, then match the enum in Swift.

import SwiftData
import SwiftUI

enum ClayPass: Int, Codable {
    case first = 1
    case second = 2

    var caption: String {
        switch self {
        case .first: "First pass · ordinario"
        case .second: "Second pass · finished spirit"
        }
    }
}

@Model
final class ClayRun {
    var lotCode: String
    var runNumber: Int
    var pass: ClayPass

    init(lotCode: String, runNumber: Int, pass: ClayPass) {
        self.lotCode = lotCode
        self.runNumber = runNumber
        self.pass = pass
    }
}

struct ClayRunScreen: View {
    var body: some View {
        ClayRunBook().inMemoryStore(for: ClayRun.self)
    }
}

private struct ClayRunBook: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<ClayRun> { $0.lotCode == "SC-26" },
        sort: [SortDescriptor(\ClayRun.runNumber)]
    ) private var runs: [ClayRun]
    @State private var receipt = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("On 10 March Lucía distills the dry Guayabo tina twice in clay pots. SC-26 keeps both pass cards.")
                .foregroundStyle(.secondary)
            List(runs) { run in
                LabeledContent("Run \(run.runNumber)", value: run.pass.caption)
            }
            Text("Finished runs: \(runs.filter { $0.pass == .second }.count)")
            Button("Hang both clay-pot cards") {
                guard runs.isEmpty else { return }
                [ClayPass.first, .second].enumerated().forEach { offset, pass in
                    modelContext.insert(ClayRun(lotCode: "SC-26", runNumber: offset + 1, pass: pass))
                }
                do {
                    try modelContext.save()
                    let filed = try modelContext.freshFetch(FetchDescriptor<ClayRun>(sortBy: [SortDescriptor(\ClayRun.runNumber)]))
                    receipt = filed.map { $0.pass.caption }.joined(separator: "; ")
                } catch { receipt = error.localizedDescription }
            }
            Text(receipt)
            Text("Teaches: Int-backed Codable enums; a primitive predicate followed by enum matching in Swift.")
                .font(.callout).foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Minas clay still")
    }
}
