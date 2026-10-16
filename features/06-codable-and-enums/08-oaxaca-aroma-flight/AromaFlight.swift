// Feature: Codable and enums
// Slot 08 — Oaxaca aroma flight
// Teaches:
// - A collection of Codable enum values keeps its tasting order.
// - A sheet edits the collection by assigning a replacement array.

import SwiftData
import SwiftUI

enum FlightAroma: String, Codable, CaseIterable {
    case roastedAgave = "Roasted agave"
    case citrusPeel = "Citrus peel"
    case wetClay = "Wet clay"
    case cacao = "Cacao"
}

@Model
final class AromaFlight {
    var roomName: String
    var aromas: [FlightAroma]

    init(roomName: String, aromas: [FlightAroma] = []) {
        self.roomName = roomName
        self.aromas = aromas
    }

    func toggle(_ aroma: FlightAroma) {
        aromas = aromas.contains(aroma) ? aromas.filter { $0 != aroma } : aromas + [aroma]
    }
}

struct AromaFlightScreen: View {
    var body: some View {
        AromaFlightEditor().inMemoryStore(for: AromaFlight.self)
    }
}

private struct AromaFlightEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var flight: AromaFlight?
    @State private var choosingAromas = false
    @State private var receipt = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 08",
            title: "Oaxaca aroma flight",
            situation: "On 20 March Elena Ruiz pours SC-26 at Sala del Tule in Oaxaca de Juárez. She records roasted agave before wet clay for the distributor's tasting flight.",
            teaches: [
                "A collection of Codable enum values keeps its tasting order.",
                "A sheet edits the collection by assigning a replacement array."
            ]
        ) {
            Button("Choose the flight aromas") {
                if flight == nil {
                    let flight = AromaFlight(roomName: "Sala del Tule", aromas: [.roastedAgave, .wetClay])
                    modelContext.insert(flight)
                    self.flight = flight
                }
                choosingAromas = true
            }
            if let flight { Text(flight.aromas.map(\.rawValue).joined(separator: " → ")) }
            Button("File the flight") {
                do {
                    try modelContext.save()
                    receipt = try modelContext.freshFirst(AromaFlight.self)?.aromas.map(\.rawValue).joined(separator: " → ") ?? "No flight"
                } catch { receipt = error.localizedDescription }
            }
            Text(receipt)
        }
        .sheet(isPresented: $choosingAromas) {
            if let flight {
                VStack {
                    Text(flight.roomName).font(.headline)
                    ForEach(FlightAroma.allCases, id: \.self) { aroma in
                        Toggle(aroma.rawValue, isOn: Binding(
                            get: { flight.aromas.contains(aroma) },
                            set: { selected in
                                if selected != flight.aromas.contains(aroma) { flight.toggle(aroma) }
                            }
                        ))
                    }
                    Button("Return to Elena's flight") { choosingAromas = false }
                }
                .padding().frame(width: 320)
            }
        }
    }
}
