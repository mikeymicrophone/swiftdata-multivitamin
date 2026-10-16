// Feature: @Transient
// Slot 04 — Stem nick
// Teaches:
// - A non-optional transient needs a default.
// - A new context reads that default, not the nick Halime set.

import SwiftData
import SwiftUI

@Model
final class StemFit {
    var wood: String
    var fitterName: String
    var fittedOn: Date
    @Transient var nick: String = "Still in the cloth"

    init(wood: String, fitterName: String, fittedOn: Date, nick: String = "Still in the cloth") {
        self.wood = wood
        self.fitterName = fitterName
        self.fittedOn = fittedOn
        self.nick = nick
    }
}

struct StemFitScreen: View {
    var body: some View {
        StemFitEditor()
            .inMemoryStore(for: StemFit.self)
    }
}

private struct StemFitEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var stem: StemFit?
    @State private var liveNick = ""
    @State private var filedWood = ""
    @State private var filedNick = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 04",
            title: "Stem nick",
            situation: "On 5 April Halime Öztürk fits a cherry stem. The nick starts as still in the cloth. She sets it to tight on the tenon.",
            teaches: [
                "A non-optional transient needs a default.",
                "A new context reads that default, not the nick Halime set."
            ]
        ) {
            if let stem {
                StemFields(stem: stem, liveNick: liveNick, filedWood: filedWood, filedNick: filedNick)
                if filedWood.isEmpty {
                    Button("File the stem card") {
                        file(stem)
                    }
                }
            } else {
                Button("Open the stem card") {
                    open()
                }
            }
        }
    }

    private func open() {
        let stem = StemFit(
            wood: "Cherry",
            fitterName: "Halime Öztürk",
            fittedOn: GregorianDay.date(year: 2026, month: 4, day: 5, timeZoneIdentifier: "Europe/Istanbul"),
            nick: "Tight on the tenon"
        )
        modelContext.insert(stem)
        self.stem = stem
    }

    private func file(_ stem: StemFit) {
        try? modelContext.save()
        liveNick = stem.nick
        let filed = try? modelContext.freshFirst(StemFit.self)
        filedWood = filed?.wood ?? "Missing"
        filedNick = filed?.nick ?? "Missing"
    }
}

private struct StemFields: View {
    let stem: StemFit
    let liveNick: String
    let filedWood: String
    let filedNick: String

    var body: some View {
        Section(stem.wood) {
            LabeledContent("Fitter", value: stem.fitterName)
            LabeledContent("Fitted", value: stem.fittedOn.formatted(date: .long, time: .omitted))
            LabeledContent("Nick on this card", value: liveNick.isEmpty ? stem.nick : liveNick)
        }
        if !filedWood.isEmpty {
            Section("Filed card") {
                LabeledContent("Wood", value: filedWood)
                LabeledContent("Nick", value: filedNick)
            }
        }
        Section {
            Text("Nesrin marks the lattice on a scratch the book cannot hold.")
                .foregroundStyle(.secondary)
        }
    }
}
