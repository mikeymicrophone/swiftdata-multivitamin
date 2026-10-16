// Feature: Attributes
// Slot 07 — Arequipa ledger reprint
// Teaches:
// - hashModifier is stored on the attribute.
// - A property with no hash modifier leaves that field nil.

import SwiftData
import SwiftUI

@Model
final class SeasonReprint {
    @Attribute(hashModifier: "mill-ledger-2026") var seasonName: String
    var deskNote: String
    var millName: String
    var reprintedOn: Date

    init(seasonName: String, deskNote: String, millName: String, reprintedOn: Date) {
        self.seasonName = seasonName
        self.deskNote = deskNote
        self.millName = millName
        self.reprintedOn = reprintedOn
    }
}

struct SeasonReprintScreen: View {
    private let container = MemoryStore.containerOrCrash(SeasonReprint.self)

    var body: some View {
        SeasonReprintEditor()
            .modelContainer(container)
    }
}

private struct SeasonReprintEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var reprint: SeasonReprint?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 07",
            title: "Arequipa ledger reprint",
            situation: "The same morning Raúl Mamani reprints the ledger in the mill office. The season column carries hash modifier mill-ledger-2026 so this card is not the old one.",
            teaches: [
                "hashModifier is stored on the attribute.",
                "A property with no hash modifier leaves that field nil."
            ]
        ) {
            if let reprint {
                ReprintFields(reprint: reprint, schema: modelContext.container.schema)
            } else {
                Button("Reprint the season") {
                    reprintSeason()
                }
            }
        }
    }

    private func reprintSeason() {
        let reprint = SeasonReprint(
            seasonName: "Chaccu 2026",
            deskNote: "Ledger reprinted in the mill office",
            millName: "Lavadero Mamani",
            reprintedOn: GregorianDay.date(year: 2026, month: 6, day: 11, timeZoneIdentifier: "America/Lima")
        )
        modelContext.insert(reprint)
        self.reprint = reprint
    }
}

private struct ReprintFields: View {
    let reprint: SeasonReprint
    let schema: Schema

    private var season: Schema.Attribute? {
        StoredAttribute.named("seasonName", on: "SeasonReprint", in: schema)
    }

    private var desk: Schema.Attribute? {
        StoredAttribute.named("deskNote", on: "SeasonReprint", in: schema)
    }

    var body: some View {
        Section(reprint.millName) {
            LabeledContent("Season", value: reprint.seasonName)
            LabeledContent("Desk note", value: reprint.deskNote)
            LabeledContent("Season hash", value: season?.hashModifier ?? "None")
            LabeledContent("Desk-note hash", value: desk?.hashModifier ?? "None")
        }
    }
}
