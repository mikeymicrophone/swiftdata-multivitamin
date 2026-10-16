// Feature: Attributes
// Slot 11 — Puno seal and photo
// Teaches:
// - Two Data properties on one model can be stored differently.
// - The wax seal stays inline. The scale photo is external.

import SwiftData
import SwiftUI

enum BaleBytes {
    static let waxSeal = Data("PU-77".utf8)
    static let scalePhoto = Data("AQ-10 scale face, 1.25 kg, Lucanas fleece, copied onto the bale".utf8)
}

@Model
final class BalePack {
    var baleCode: String
    var waxSeal: Data
    @Attribute(.externalStorage) var scalePhoto: Data

    init(baleCode: String, waxSeal: Data, scalePhoto: Data) {
        self.baleCode = baleCode
        self.waxSeal = waxSeal
        self.scalePhoto = scalePhoto
    }
}

struct BalePackScreen: View {
    private let container = MemoryStore.containerOrCrash(BalePack.self)

    var body: some View {
        BalePackEditor()
            .modelContainer(container)
    }
}

private struct BalePackEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var pack: BalePack?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 11",
            title: "Puno seal and photo",
            situation: "Soledad Condori presses the wax seal into the row and keeps the copied scale photo outside it. Both travel with bale PU-77.",
            teaches: [
                "Two Data properties on one model can be stored differently.",
                "The wax seal stays inline. The scale photo is external."
            ]
        ) {
            if let pack {
                PackFields(pack: pack, schema: modelContext.container.schema)
            } else {
                Button("Pack the bale") {
                    packBale()
                }
            }
        }
    }

    private func packBale() {
        let pack = BalePack(
            baleCode: "PU-77",
            waxSeal: BaleBytes.waxSeal,
            scalePhoto: BaleBytes.scalePhoto
        )
        modelContext.insert(pack)
        self.pack = pack
    }
}

private struct PackFields: View {
    let pack: BalePack
    let schema: Schema

    private func external(_ name: String) -> Bool {
        StoredAttribute.named(name, on: "BalePack", in: schema)?.options.contains(.externalStorage) == true
    }

    var body: some View {
        Section("Bale \(pack.baleCode)") {
            LabeledContent("Wax seal", value: "\(pack.waxSeal.count) bytes, \(external("waxSeal") ? "outside the row" : "in the row")")
            LabeledContent("Scale photo", value: "\(pack.scalePhoto.count) bytes, \(external("scalePhoto") ? "outside the row" : "in the row")")
        }
    }
}
