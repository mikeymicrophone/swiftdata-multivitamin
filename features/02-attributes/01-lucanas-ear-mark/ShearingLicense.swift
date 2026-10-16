// Feature: Attributes
// Slot 01 — Lucanas ear mark
// Teaches:
// - @Attribute(.unique) marks one stored property.
// - The entity's uniqueness constraints list that property.

import SwiftData
import SwiftUI

@Model
final class ShearingLicense {
    @Attribute(.unique) var earMark: String
    var communityName: String
    var clerkName: String
    var conditionNote: String
    var shornOn: Date

    init(
        earMark: String,
        communityName: String,
        clerkName: String,
        conditionNote: String,
        shornOn: Date
    ) {
        self.earMark = earMark
        self.communityName = communityName
        self.clerkName = clerkName
        self.conditionNote = conditionNote
        self.shornOn = shornOn
    }
}

struct ShearingLicenseScreen: View {
    private let container = MemoryStore.containerOrCrash(ShearingLicense.self)

    var body: some View {
        ShearingLicenseEditor()
            .modelContainer(container)
    }
}

private struct ShearingLicenseEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var license: ShearingLicense?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 01",
            title: "Lucanas ear mark",
            situation: "On 8 June 2026 Florentina Quispe opens the chaccu book at the Lucanas corral. Vicuña LQ-184 is the only animal that may carry that ear mark.",
            teaches: [
                "@Attribute(.unique) marks one stored property.",
                "The entity's uniqueness constraints list that property."
            ]
        ) {
            if let license {
                LicenseFields(license: license, schema: modelContext.container.schema)
            } else {
                Button("Open the license") {
                    openLicense()
                }
            }
        }
    }

    private func openLicense() {
        let license = ShearingLicense(
            earMark: "LQ-184",
            communityName: "Comunidad campesina de Lucanas",
            clerkName: "Florentina Quispe",
            conditionNote: "Clear coat, no cut",
            shornOn: GregorianDay.date(year: 2026, month: 6, day: 8, timeZoneIdentifier: "America/Lima")
        )
        modelContext.insert(license)
        self.license = license
    }
}

private struct LicenseFields: View {
    let license: ShearingLicense
    let schema: Schema

    private var constraint: String {
        let rows = schema.entities.first { $0.name == "ShearingLicense" }?.uniquenessConstraints ?? []
        return rows.map { $0.joined(separator: ", ") }.joined(separator: "; ")
    }

    var body: some View {
        Section(license.communityName) {
            LabeledContent("Clerk", value: license.clerkName)
            LabeledContent("Ear mark", value: license.earMark)
            LabeledContent("Condition", value: license.conditionNote)
            LabeledContent("Shorn", value: license.shornOn.formatted(date: .long, time: .omitted))
        }

        Section("The book") {
            Text("One row for \(constraint).")
        }

        Section {
            Text("The fleece from this animal goes to Raúl Mamani's scouring mill in Arequipa.")
                .foregroundStyle(.secondary)
        }
    }
}
