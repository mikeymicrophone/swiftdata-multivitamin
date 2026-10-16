// Feature: Codable and enums
// Slot 07 — Minas resting jars
// Teaches:
// - An array of Codable structs is a value collection on one model.
// - Appending through a copied array preserves the ordered inspection history.

import SwiftData
import SwiftUI

struct RestingCheck: Codable, Equatable {
    var day: Int
    var sealIntact: Bool
    var note: String
}

@Model
final class RestingJar {
    var jarCode: String
    var checks: [RestingCheck]

    init(jarCode: String, checks: [RestingCheck] = []) {
        self.jarCode = jarCode
        self.checks = checks
    }

    func append(_ check: RestingCheck) {
        checks = checks + [check]
    }

    var intactDays: Int { checks.lazy.filter(\.sealIntact).count }
}

struct RestingJarScreen: View {
    var body: some View {
        RestingJarBook().inMemoryStore(for: RestingJar.self)
    }
}

private struct RestingJarBook: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RestingJar.jarCode) private var jars: [RestingJar]
    @State private var receipt = ""

    var body: some View {
        ScenarioChrome(
            kicker: "Codable and enums · 07",
            title: "Minas resting jars",
            situation: "On 12 and 19 March Mateo checks jar SC-26-A in the Guayabo resting room. Both wax seals are intact; the second note says the clay aroma has softened.",
            teaches: [
                "An array of Codable structs is a value collection on one model.",
                "Appending through a copied array preserves the ordered inspection history."
            ]
        ) {
            ForEach(jars) { jar in
                Section(jar.jarCode) {
                    ForEach(Array(jar.checks.enumerated()), id: \.offset) { _, check in
                        Label("Day \(check.day): \(check.note)", systemImage: check.sealIntact ? "checkmark.seal" : "exclamationmark.triangle")
                    }
                    Text("\(jar.intactDays) intact inspections")
                }
            }
            Button("File both wax inspections") {
                guard jars.isEmpty else { return }
                let jar = RestingJar(jarCode: "SC-26-A")
                jar.append(RestingCheck(day: 12, sealIntact: true, note: "Fresh clay"))
                jar.append(RestingCheck(day: 19, sealIntact: true, note: "Clay aroma softened"))
                modelContext.insert(jar)
                do {
                    try modelContext.save()
                    let filed = try modelContext.freshFirst(RestingJar.self)
                    receipt = filed?.checks.map(\.note).joined(separator: " → ") ?? "No jar"
                } catch { receipt = error.localizedDescription }
            }
            Text(receipt).foregroundStyle(.secondary)
        }
    }
}
