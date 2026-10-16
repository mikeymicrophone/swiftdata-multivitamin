// Feature: @Transient
// Slot 03 — Wax whisper
// Teaches:
// - An optional transient needs no default value.
// - A new context reads nil. The wax lot is filed.

import SwiftData
import SwiftUI

@Model
final class WaxCook {
    var lotCode: String
    var waxerName: String
    var cookedOn: Date
    @Transient var whisper: String?

    init(lotCode: String, waxerName: String, cookedOn: Date, whisper: String? = nil) {
        self.lotCode = lotCode
        self.waxerName = waxerName
        self.cookedOn = cookedOn
        self.whisper = whisper
    }
}

struct WaxCookScreen: View {
    var body: some View {
        WaxCookEditor()
            .inMemoryStore(for: WaxCook.self)
    }
}

private struct WaxCookEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cook: WaxCook?
    @State private var liveWhisper = ""
    @State private var filedLot = ""
    @State private var filedWhisper = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 03",
            title: "Wax whisper",
            situation: "On 4 April Yusuf Demir cooks wax lot WX-7 behind the carving room. He whispers that it should run cooler than yesterday. The whisper has no default.",
            teaches: [
                "An optional transient needs no default value.",
                "A new context reads nil. The wax lot is filed."
            ]
        ) {
            if let cook {
                CookFields(cook: cook, liveWhisper: liveWhisper, filedLot: filedLot, filedWhisper: filedWhisper)
                if filedLot.isEmpty {
                    Button("File the wax lot") {
                        file(cook)
                    }
                }
            } else {
                Button("Open the wax card") {
                    open()
                }
            }
        }
    }

    private func open() {
        let cook = WaxCook(
            lotCode: "WX-7",
            waxerName: "Yusuf Demir",
            cookedOn: GregorianDay.date(year: 2026, month: 4, day: 4, timeZoneIdentifier: "Europe/Istanbul"),
            whisper: "Cooler than yesterday"
        )
        modelContext.insert(cook)
        self.cook = cook
    }

    private func file(_ cook: WaxCook) {
        try? modelContext.save()
        liveWhisper = cook.whisper ?? "Unspoken"
        let filed = try? modelContext.freshFirst(WaxCook.self)
        filedLot = filed?.lotCode ?? "Missing"
        filedWhisper = filed?.whisper ?? "Unspoken"
    }
}

private struct CookFields: View {
    let cook: WaxCook
    let liveWhisper: String
    let filedLot: String
    let filedWhisper: String

    var body: some View {
        Section(cook.lotCode) {
            LabeledContent("Waxer", value: cook.waxerName)
            LabeledContent("Cooked", value: cook.cookedOn.formatted(date: .long, time: .omitted))
            LabeledContent("Whisper on this card", value: liveWhisper.isEmpty ? (cook.whisper ?? "Unspoken") : liveWhisper)
        }
        if !filedLot.isEmpty {
            Section("Filed card") {
                LabeledContent("Lot", value: filedLot)
                LabeledContent("Whisper", value: filedWhisper)
            }
        }
        Section {
            Text("Halime Öztürk fits a cherry stem.")
                .foregroundStyle(.secondary)
        }
    }
}
