// Feature: Codable and enums
// Slot 04 — Minas tina
// Teaches:
// - An optional Codable reading distinguishes no sample from a measured zero.
// - Assigning a reading and clearing it are both saved states.

import SwiftData
import SwiftUI

struct FermentReading: Codable, Equatable {
    var brix: Double
    var celsius: Double
}

@Model
final class FermentCard {
    var tinaName: String
    var reading: FermentReading?

    init(tinaName: String, reading: FermentReading? = nil) {
        self.tinaName = tinaName
        self.reading = reading
    }
}

struct FermentCardScreen: View {
    var body: some View {
        FermentCardEditor().inMemoryStore(for: FermentCard.self)
    }
}

private struct FermentCardEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var tina: FermentCard?
    @State private var receipt = "No reading filed yet"

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 04",
            title: "Minas tina",
            situation: "On 9 March Mateo Cruz samples SC-26 in the Guayabo tina. A blank line means he has not sampled; zero Brix means the sugar reading reached zero.",
            teaches: [
                "An optional Codable reading distinguishes no sample from a measured zero.",
                "Assigning a reading and clearing it are both saved states."
            ]
        ) {
            if let tina {
                if let reading = tina.reading {
                    LabeledContent("Sugar", value: "\(reading.brix.formatted()) °Bx")
                    LabeledContent("Temperature", value: "\(reading.celsius.formatted()) °C")
                } else { Text("No sample on the card") }
                HStack {
                    Button("Record the dry tina") {
                        tina.reading = FermentReading(brix: 0, celsius: 29)
                        file()
                    }
                    Button("Withdraw the sample") { tina.reading = nil; file() }
                }
            } else {
                Button("Open the Guayabo tina") {
                    let tina = FermentCard(tinaName: "Guayabo · SC-26")
                    modelContext.insert(tina)
                    self.tina = tina
                    file()
                }
            }
            Text(receipt)
        }
    }

    private func file() {
        do {
            try modelContext.save()
            guard let filed = try modelContext.freshFirst(FermentCard.self) else {
                receipt = "The tina card is missing"
                return
            }
            receipt = filed.reading.map { "Filed: \($0.brix.formatted()) °Bx at \($0.celsius.formatted()) °C" } ?? "Filed: no sample"
        } catch { receipt = error.localizedDescription }
    }
}
