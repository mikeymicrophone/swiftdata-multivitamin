// Feature: Codable and enums
// Slot 06 — Minas heart cut
// Teaches:
// - An associated-value Codable enum can be explicitly encoded into a Data attribute.
// - Decoding throws on damaged bytes; switch and if case recover the payload.

import Foundation
import SwiftData
import SwiftUI

enum CutVerdict: Codable, Equatable, Sendable {
    case waiting
    case hearts(abv: Double, litres: Int)
    case held(reason: String)

    var line: String {
        switch self {
        case .waiting: "Awaiting Lucía's cut"
        case let .hearts(abv, litres): "\(litres) litres at \(abv.formatted())% ABV"
        case .held(let reason): "Held: \(reason)"
        }
    }
}

@Model
final class HeartCut {
    var lotCode: String
    var verdictJSON: Data

    init(lotCode: String, verdict: CutVerdict) throws {
        self.lotCode = lotCode
        self.verdictJSON = try JSONEncoder().encode(verdict)
    }

    func readVerdict() throws -> CutVerdict {
        try JSONDecoder().decode(CutVerdict.self, from: verdictJSON)
    }

    func record(_ verdict: CutVerdict) throws {
        verdictJSON = try JSONEncoder().encode(verdict)
    }
}

struct HeartCutScreen: View {
    var body: some View {
        HeartCutEditor().inMemoryStore(for: HeartCut.self)
    }
}

private struct HeartCutEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cut: HeartCut?
    @State private var reading: Result<CutVerdict, Error>?

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 06",
            title: "Minas heart cut",
            situation: "On 11 March Lucía separates 96 litres of hearts at 47% ABV from SC-26. The decision carries different fields when a cut is held instead.",
            teaches: [
                "An associated-value Codable enum can be explicitly encoded into a Data attribute.",
                "Decoding throws on damaged bytes; switch and if case recover the payload."
            ]
        ) {
            Button("File Lucía's hearts decision") {
                reading = Result {
                    let decisionCard: HeartCut
                    if let cut {
                        decisionCard = cut
                    } else {
                        decisionCard = try HeartCut(lotCode: "SC-26", verdict: .waiting)
                        modelContext.insert(decisionCard)
                        cut = decisionCard
                    }
                    try decisionCard.record(.hearts(abv: 47, litres: 96))
                    try modelContext.save()
                    guard let filed = try modelContext.freshFirst(HeartCut.self) else {
                        throw CocoaError(.fileReadNoSuchFile)
                    }
                    return try filed.readVerdict()
                }
            }
            switch reading {
            case .success(let verdict):
                Text(verdict.line)
                if case let .hearts(_, litres) = verdict {
                    Text("\(litres) litres go to the resting room")
                }
            case .failure(let error): Text(error.localizedDescription).foregroundStyle(.red)
            case nil: Text("The cut has not been filed")
            }
        }
    }
}
