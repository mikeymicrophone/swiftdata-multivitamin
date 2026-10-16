// Feature: Attributes
// Slot 12 — Lucanas second card
// Teaches:
// - Saving a second model with the same unique value keeps one row.
// - That row keeps the first identity and takes the new values.

import SwiftData
import SwiftUI

struct SecondLicenseScreen: View {
    private let container = MemoryStore.containerOrCrash(ShearingLicense.self)

    var body: some View {
        SecondLicenseEditor()
            .modelContainer(container)
    }
}

private struct SecondLicenseEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var license: ShearingLicense?
    @State private var identityAtOpening = ""
    @State private var filedSecondCard = false

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
            if let license {
                Section(license.earMark) {
                    LabeledContent("Clerk", value: license.clerkName)
                    LabeledContent("Condition", value: license.conditionNote)
                    LabeledContent(
                        "Identity",
                        value: filedSecondCard && String(describing: license.persistentModelID) == identityAtOpening
                            ? "Same license on the nail"
                            : "First license"
                    )
                }
                if !filedSecondCard {
                    Button("File the second card") {
                        fileSecondCard()
                    }
                }
            } else {
                Button("File the first license") {
                    fileFirstLicense()
                }
            }
        }
        .onAppear {
            modelContext.autosaveEnabled = false
        }
    }

    private func fileFirstLicense() {
        let license = ShearingLicense(
            earMark: "LQ-184",
            communityName: "Comunidad campesina de Lucanas",
            clerkName: "Florentina Quispe",
            conditionNote: "Clear coat, no cut",
            shornOn: GregorianDay.date(year: 2026, month: 6, day: 8, timeZoneIdentifier: "America/Lima")
        )
        modelContext.insert(license)
        try? modelContext.save()
        identityAtOpening = String(describing: license.persistentModelID)
        self.license = license
    }

    private func fileSecondCard() {
        let second = ShearingLicense(
            earMark: "LQ-184",
            communityName: "Comunidad campesina de Lucanas",
            clerkName: "Florentina Quispe",
            conditionNote: "Cut on the left shoulder",
            shornOn: GregorianDay.date(year: 2026, month: 6, day: 8, timeZoneIdentifier: "America/Lima")
        )
        modelContext.insert(second)
        try? modelContext.save()
        filedSecondCard = true
    }
}
