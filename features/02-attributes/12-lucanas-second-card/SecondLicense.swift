// Feature: Attributes
// Slot 12 — Lucanas second card
// Teaches:
// - Saving a second model with the same unique value keeps one row.
// - That row keeps the first identity and takes the new values.

import SwiftData
import SwiftUI

/// The clerk's card as plain values, so it can cross into the actor.
struct LicenseDraft: Sendable {
    var earMark = "LQ-184"
    var communityName = "Comunidad campesina de Lucanas"
    var clerkName = "Florentina Quispe"
    var conditionNote: String
    var shornOn = GregorianDay.date(year: 2026, month: 6, day: 8, timeZoneIdentifier: "America/Lima")
}

@ModelActor
actor LicenseClerk {
    func file(_ draft: LicenseDraft) throws -> PersistentIdentifier {
        let license = ShearingLicense(
            earMark: draft.earMark,
            communityName: draft.communityName,
            clerkName: draft.clerkName,
            conditionNote: draft.conditionNote,
            shornOn: draft.shornOn
        )
        modelContext.insert(license)
        try modelContext.save()
        return license.persistentModelID
    }
}

struct SecondLicenseScreen: View {
    var body: some View {
        SecondLicenseEditor()
            .inMemoryStore(for: ShearingLicense.self)
    }
}

private struct SecondLicenseEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var clerk: LicenseClerk?
    @State private var firstID: PersistentIdentifier?
    @State private var book: [ShearingLicense]?
    @State private var problem: String?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 12",
            title: "Lucanas second card",
            situation: "Later on 8 June a second card is offered for ear mark LQ-184, this one noting a cut on the left shoulder. The book keeps the first license and takes the new condition.",
            teaches: [
                "Saving a second model with the same unique value keeps one row.",
                "That row keeps the first identity and takes the new values."
            ]
        ) {
            switch (firstID, book) {
            case (nil, _):
                Button("File the first license") {
                    Task { await fileFirst() }
                }
            case (.some, nil):
                LabeledContent("First license", value: "Filed by the clerk")
                Button("File the second card") {
                    Task { await fileSecond() }
                }
            case let (.some(firstID), .some(rows)):
                Section("The book") {
                    LabeledContent("Rows for LQ-184", value: rows.count, format: .number)
                    ForEach(rows) { row in
                        LabeledContent("Condition", value: row.conditionNote)
                        LabeledContent("Identity", value: row.persistentModelID == firstID ? "Same license on the nail" : "A new license")
                    }
                }
            }
            if let problem {
                Text(problem).foregroundStyle(.red)
            }
        }
    }

    private func fileFirst() async {
        let clerk = LicenseClerk(modelContainer: modelContext.container)
        self.clerk = clerk
        do {
            firstID = try await clerk.file(LicenseDraft(conditionNote: "Clear coat, no cut"))
        } catch {
            problem = "The first license was not filed: \(error.localizedDescription)"
        }
    }

    private func fileSecond() async {
        guard let clerk else { return }
        do {
            _ = try await clerk.file(LicenseDraft(conditionNote: "Cut on the left shoulder"))
            book = try modelContext.fetch(FetchDescriptor<ShearingLicense>(predicate: #Predicate<ShearingLicense> { $0.earMark == "LQ-184" }))
        } catch {
            problem = "The second card was not filed: \(error.localizedDescription)"
        }
    }
}
