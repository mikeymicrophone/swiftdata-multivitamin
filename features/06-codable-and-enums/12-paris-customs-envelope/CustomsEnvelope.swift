// Feature: Codable and enums
// Slot 12 — Paris customs envelope
// Teaches:
// - Explicit JSON date strategies define the customs document's wire format.
// - A ModelActor reads stored bytes and returns a Sendable Codable value, not a model.

import Foundation
import SwiftData
import SwiftUI

struct CustomsDeclaration: Codable, Equatable, Sendable {
    var lotCode: String
    var destination: String
    var sealedOn: Date
    var certificate: String?

    func encoded() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        return try encoder.encode(self)
    }

    static func decode(_ document: Data) throws -> CustomsDeclaration {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Self.self, from: document)
    }
}

@Model
final class CustomsEnvelope {
    var lotCode: String
    var declarationJSON: Data

    init(declaration: CustomsDeclaration) throws {
        self.lotCode = declaration.lotCode
        self.declarationJSON = try declaration.encoded()
    }
}

@ModelActor
actor CustomsReader {
    func declaration(for id: PersistentIdentifier) throws -> CustomsDeclaration {
        guard let envelope = modelContext.model(for: id) as? CustomsEnvelope else {
            throw CocoaError(.fileReadNoSuchFile)
        }
        return try CustomsDeclaration.decode(envelope.declarationJSON)
    }
}

struct CustomsEnvelopeScreen: View {
    var body: some View {
        CustomsEnvelopeDesk().inMemoryStore(for: CustomsEnvelope.self)
    }
}

private struct CustomsEnvelopeDesk: View {
    @Environment(\.modelContext) private var modelContext
    @State private var envelopeID: PersistentIdentifier?
    @State private var declaration: CustomsDeclaration?
    @State private var failure: String?

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 12",
            title: "Paris customs envelope",
            situation: "On 24 March Cave des Terres in Paris receives the SC-26 customs envelope from Distribuidora del Sur. Its seal date is written as ISO 8601, with certificate MX-SC-26.",
            teaches: [
                "Explicit JSON date strategies define the customs document's wire format.",
                "A ModelActor reads stored bytes and returns a Sendable Codable value, not a model."
            ]
        ) {
            if let declaration {
                LabeledContent("Destination", value: declaration.destination)
                LabeledContent("Lot", value: declaration.lotCode)
                Text(declaration.sealedOn, format: .dateTime.year().month().day())
                Text(declaration.certificate ?? "No certificate enclosed")
            } else if envelopeID != nil && failure == nil {
                ProgressView("Reading the customs envelope")
            }
            if let failure { Text(failure).foregroundStyle(.red) }
            Button("Send the sealed envelope to the reader") {
                do {
                    let declaration = CustomsDeclaration(
                        lotCode: "SC-26", destination: "Cave des Terres, Paris",
                        sealedOn: GregorianDay.date(year: 2026, month: 3, day: 24, timeZoneIdentifier: "America/Mexico_City"),
                        certificate: "MX-SC-26"
                    )
                    let envelope = try CustomsEnvelope(declaration: declaration)
                    modelContext.insert(envelope)
                    try modelContext.save()
                    envelopeID = envelope.persistentModelID
                } catch { failure = error.localizedDescription }
            }
            .disabled(envelopeID != nil)
        }
        .task(id: envelopeID) {
            guard let envelopeID else { return }
            let reader = CustomsReader(modelContainer: modelContext.container)
            do { declaration = try await reader.declaration(for: envelopeID) }
            catch { failure = error.localizedDescription }
        }
    }
}
