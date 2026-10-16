// Feature: Delete rules
// Slot 06 — Qamsar copper still
// Teaches:
// - .deny is stored on the still's cook list.
// - The save still removes the still. The charged cook remains, with an empty still line.

import SwiftData
import SwiftUI

@Model
final class ChargedCook {
    var lotCode: String
    var distillerName: String
    var still: CopperStill?

    init(lotCode: String, distillerName: String) {
        self.lotCode = lotCode
        self.distillerName = distillerName
    }
}

@Model
final class CopperStill {
    var stillName: String
    var smithName: String
    // The schema stores deny. Saving the deletion still removes the still.
    @Relationship(deleteRule: .deny, inverse: \ChargedCook.still)
    var cooks: [ChargedCook] = []

    init(stillName: String, smithName: String) {
        self.stillName = stillName
        self.smithName = smithName
    }
}

struct CopperStillScreen: View {
    var body: some View {
        CopperStillEditor()
            .inMemoryStore(for: CopperStill.self, ChargedCook.self)
    }
}

private struct PulledStill {
    let stillsLeft: Int
    let unchargedCooks: [String]
}

private struct CopperStillEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var still: CopperStill?
    @State private var pulled: Result<PulledStill, any Error>?
    @State private var warning: String?

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 06",
            title: "Qamsar copper still",
            situation: "On 16 May the card for Still 2 is pulled while cook QS-22 is charged on it. The rule on that list is deny.",
            teaches: [
                ".deny is stored on the still's cook list.",
                "The save still removes the still. The charged cook remains, with an empty still line."
            ]
        ) {
            if let still {
                StillFields(still: still, schema: modelContext.container.schema)
                if let warning {
                    Label(warning, systemImage: "exclamationmark.triangle")
                }
                switch pulled {
                case nil:
                    Button("Pull the still card") {
                        pulled = Result { try pullCard(still) }
                    }
                case .success(let book)?:
                    Section("Filed book") {
                        LabeledContent("Stills", value: book.stillsLeft, format: .number)
                        LabeledContent("Cooks with an empty still line", value: book.unchargedCooks.joined(separator: ", "))
                    }
                case .failure(let error)?:
                    Text("The book refused the pull: \(error.localizedDescription)")
                        .foregroundStyle(.red)
                }
            } else {
                Button("Charge Still 2") { chargeStill() }
            }
            Section {
                Text("The chalk tally on the still-house wall is wiped next.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func chargeStill() {
        let still = CopperStill(stillName: "Still 2", smithName: "Farhad Golshan")
        let cook = ChargedCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        modelContext.insert(still)
        modelContext.insert(cook)
        still.cooks.append(cook)
        try? modelContext.save()
        self.still = still
    }

    private func pullCard(_ still: CopperStill) throws -> PulledStill {
        // This store does not enforce deny, so the desk reads the list itself.
        if let charged = still.cooks.first {
            warning = "Deny is on the list and \(charged.lotCode) is still charged. The store pulls the card anyway."
        }
        modelContext.delete(still)
        try modelContext.save()

        var uncharged = FetchDescriptor<ChargedCook>(
            predicate: #Predicate<ChargedCook> { $0.still == nil },
            sortBy: [SortDescriptor(\.lotCode)]
        )
        uncharged.fetchLimit = 10
        return PulledStill(
            stillsLeft: try modelContext.freshCount(CopperStill.self),
            unchargedCooks: try modelContext.freshFetch(uncharged).map(\.lotCode)
        )
    }
}

private struct StillFields: View {
    let still: CopperStill
    let schema: Schema

    var body: some View {
        Section(still.stillName) {
            LabeledContent("Smith", value: still.smithName)
            LabeledContent("Rule", value: ruleTitle)
            LabeledContent("Charged", value: still.cooks.map(\.lotCode).joined(separator: ", "))
        }
    }

    private var ruleTitle: String {
        guard let rule = StoredRelationship.named("cooks", on: "CopperStill", in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
