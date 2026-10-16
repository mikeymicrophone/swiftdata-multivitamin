// Feature: Codable and enums
// Slot 13 — Madrid morning folder
// Teaches:
// - One schema can hold enum, struct, collection, and raw-code cards together.
// - A Codable handover snapshot is assembled from fresh reads without model relationships.

import Foundation
import SwiftData
import SwiftUI

enum MezcalFolder {
    static let types: [any PersistentModel.Type] = [
        AgaveHarvest.self, RestingJar.self, DistributorAllocation.self, MezcalHandover.self
    ]

    static func file(in context: ModelContext) throws -> MezcalManifest {
        let harvest = AgaveHarvest(lotCode: "SC-26", growerName: "Inés Santiago")
        let jar = RestingJar(jarCode: "SC-26-A", checks: [RestingCheck(day: 19, sealIntact: true, note: "Clay aroma softened")])
        let allocation = DistributorAllocation(distributorName: "Mesa del Agave, Madrid", stageCode: "dispatched", cases: 6)
        context.insert(harvest)
        context.insert(jar)
        context.insert(allocation)
        try context.save()
        guard let filedHarvest = try context.freshFirst(AgaveHarvest.self),
              let filedJar = try context.freshFirst(RestingJar.self),
              let filedAllocation = try context.freshFirst(DistributorAllocation.self),
              let stage = filedAllocation.stage else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let manifest = MezcalManifest(
            lotCode: filedHarvest.lotCode,
            agaveName: filedHarvest.agave.rawValue,
            sealNotes: filedJar.checks.map(\.note),
            destination: filedAllocation.distributorName,
            stageName: stage.rawValue,
            cases: filedAllocation.cases
        )
        context.insert(MezcalHandover(manifest: manifest))
        try context.save()
        guard let handover = try context.freshFirst(MezcalHandover.self) else {
            throw CocoaError(.fileReadNoSuchFile)
        }
        return handover.manifest
    }
}

struct MezcalManifest: Codable, Equatable, Sendable {
    var lotCode: String
    var agaveName: String
    var sealNotes: [String]
    var destination: String
    var stageName: String
    var cases: Int
}

@Model
final class MezcalHandover {
    var manifest: MezcalManifest

    init(manifest: MezcalManifest) { self.manifest = manifest }
}

struct MezcalHandoverScreen: View {
    var body: some View {
        MezcalHandoverDesk().inMemoryStore(for: MezcalFolder.types)
    }
}

private struct MezcalHandoverDesk: View {
    @Environment(\.modelContext) private var modelContext
    @State private var manifest: MezcalManifest?
    @State private var failure: String?

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 13",
            title: "Madrid morning folder",
            situation: "On 25 March Rafael Vega opens six cases of SC-26 at Mesa del Agave in Madrid. Inés's agave, Mateo's seal note, and the distributor's dispatch code accompany Elena's revised tasting flight.",
            teaches: [
                "One schema can hold enum, struct, collection, and raw-code cards together.",
                "A Codable handover snapshot is assembled from fresh reads without model relationships."
            ]
        ) {
            if let manifest {
                Section("Palenque to tasting room") {
                    LabeledContent("Lot", value: manifest.lotCode)
                    LabeledContent("Agave", value: manifest.agaveName)
                    Text(manifest.sealNotes.joined(separator: "; "))
                }
                Section(manifest.destination) {
                    Text("\(manifest.cases) cases · \(manifest.stageName)")
                    Text("Rafael pours the first SC-26 flight this evening.")
                        .foregroundStyle(.secondary)
                }
            } else {
                Button("Lay out the Madrid folder") {
                    do { manifest = try MezcalFolder.file(in: modelContext) }
                    catch { failure = error.localizedDescription }
                }
            }
            if let failure { Text(failure).foregroundStyle(.red) }
        }
    }
}
