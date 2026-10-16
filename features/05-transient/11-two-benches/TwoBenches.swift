// Feature: @Transient
// Slot 11 — Two benches
// Teaches:
// - Each model's transient property is omitted from that model.
// - The wax lot and the stem wood are filed.

import SwiftData
import SwiftUI

struct TwoBenchScreen: View {
    var body: some View {
        TwoBenchEditor()
            .inMemoryStore(for: WaxCook.self, StemFit.self)
    }
}

private struct TwoBenchEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var waxColumns = ""
    @State private var stemColumns = ""
    @State private var filedWax = ""
    @State private var filedWood = ""
    @State private var filedWhisper = ""
    @State private var filedNick = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Transient · 11",
            title: "Two benches",
            situation: "On 12 April the wax card WX-7 and the cherry stem card sit in one book. Yusuf's whisper and Halime's nick are each left off their own card.",
            teaches: [
                "Each model's transient property is omitted from that model.",
                "The wax lot and the stem wood are filed."
            ]
        ) {
            if waxColumns.isEmpty {
                Button("File both bench cards") {
                    fileBoth()
                }
            } else {
                BenchFields(
                    waxColumns: waxColumns,
                    stemColumns: stemColumns,
                    filedWax: filedWax,
                    filedWood: filedWood,
                    filedWhisper: filedWhisper,
                    filedNick: filedNick
                )
            }
        }
    }

    private func fileBoth() {
        let cook = WaxCook(
            lotCode: "WX-7",
            waxerName: "Yusuf Demir",
            cookedOn: GregorianDay.date(year: 2026, month: 4, day: 4, timeZoneIdentifier: "Europe/Istanbul"),
            whisper: "Cooler than yesterday"
        )
        let stem = StemFit(
            wood: "Cherry",
            fitterName: "Halime Öztürk",
            fittedOn: GregorianDay.date(year: 2026, month: 4, day: 5, timeZoneIdentifier: "Europe/Istanbul"),
            nick: "Tight on the tenon"
        )
        modelContext.insert(cook)
        modelContext.insert(stem)
        try? modelContext.save()
        let schema = modelContext.container.schema
        waxColumns = StoredAttribute.propertyNames(on: "WaxCook", in: schema).joined(separator: ", ")
        stemColumns = StoredAttribute.propertyNames(on: "StemFit", in: schema).joined(separator: ", ")
        let filed = ModelContext(modelContext.container)
        let wax = (try? filed.fetch(FetchDescriptor<WaxCook>()))?.first
        let fitted = (try? filed.fetch(FetchDescriptor<StemFit>()))?.first
        filedWax = wax?.lotCode ?? "Missing"
        filedWood = fitted?.wood ?? "Missing"
        filedWhisper = wax?.whisper ?? "Unspoken"
        filedNick = fitted?.nick ?? "Missing"
    }
}

private struct BenchFields: View {
    let waxColumns: String
    let stemColumns: String
    let filedWax: String
    let filedWood: String
    let filedWhisper: String
    let filedNick: String

    var body: some View {
        Section("Wax card") {
            LabeledContent("Columns", value: waxColumns)
            LabeledContent("Lot", value: filedWax)
            LabeledContent("Whisper", value: filedWhisper)
        }
        Section("Stem card") {
            LabeledContent("Columns", value: stemColumns)
            LabeledContent("Wood", value: filedWood)
            LabeledContent("Nick", value: filedNick)
        }
        Section {
            Text("Halime writes the hour she tried the tenon.")
                .foregroundStyle(.secondary)
        }
    }
}
