import SwiftUI

struct CatalogView: View {
    @State private var selectedFeatureID: String? = Catalog.features.first?.id
    @State private var selectedScenarioID: String? = Catalog.features.first?.scenarios.first?.id

    var body: some View {
        NavigationSplitView {
            List(Catalog.features, selection: $selectedFeatureID) { feature in
                VStack(alignment: .leading, spacing: 2) {
                    Text(feature.title)
                    Text(bottledLabel(for: feature))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .tag(feature.id)
                .padding(.vertical, 2)
            }
            .navigationTitle("SwiftData")
            .navigationSplitViewColumnWidth(min: 240, ideal: 280)
        } content: {
            scenarioColumn
                .navigationSplitViewColumnWidth(min: 240, ideal: 300)
        } detail: {
            detailColumn
        }
        .onChange(of: selectedFeatureID) { _, featureID in
            selectedScenarioID = Catalog.feature(featureID)?.scenarios.first?.id
        }
    }

    @ViewBuilder
    private var scenarioColumn: some View {
        if let feature = Catalog.feature(selectedFeatureID) {
            if feature.scenarios.isEmpty {
                List {
                    Text("No scenarios bottled yet.")
                        .foregroundStyle(.secondary)
                }
                .navigationTitle(feature.title)
            } else {
                List(feature.scenarios, selection: $selectedScenarioID) { scenario in
                    Text(scenario.title)
                        .tag(scenario.id)
                }
                .navigationTitle(feature.title)
            }
        } else {
            Text("Choose a feature")
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var detailColumn: some View {
        if let feature = Catalog.feature(selectedFeatureID) {
            if feature.scenarios.isEmpty {
                PlannedFeature(feature: feature)
            } else if let scenario = feature.scenarios.first(where: { $0.id == selectedScenarioID }) {
                scenarioScreen(scenarioID: scenario.id)
            } else {
                Text("Choose a scenario")
                    .foregroundStyle(.secondary)
            }
        } else {
            Text("Choose a feature")
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func scenarioScreen(scenarioID: String) -> some View {
        switch scenarioID {
        case "01-tbilisi-quince-commission":
            QuinceCommissionScreen()
        case "02-legnica-copper-blank":
            CopperBlankTicketScreen()
        case "03-haarlem-bite-note":
            BiteNoteScreen()
        case "04-barcelona-bone-black":
            BoneBlackBatchScreen()
        case "05-fabriano-damp-pack":
            RagDampSlipScreen()
        case "06-verona-crate-and-waybill":
            VeronaDepartureScreen()
        case "07-tbilisi-desk-briefing":
            DeskBriefingScreen()
        case "08-tbilisi-plate-receipt":
            PlateJobScreen()
        case "09-barcelona-two-grinds":
            GrindEntryScreen()
        case "10-fabriano-mill-schema":
            FioravantiMillBookScreen()
        case "11-vera-district-shelf-card":
            ShelfCardScreen()
        case "12-albertina-bench-slip":
            BenchSlipScreen()
        case "13-morning-handover-folder":
            MorningHandoverScreen()
        default:
            Text("That scenario is not bottled.")
                .foregroundStyle(.secondary)
        }
    }

    private func bottledLabel(for feature: CatalogFeature) -> String {
        "\(feature.scenarios.count) of 13 bottled"
    }
}

private struct PlannedFeature: View {
    let feature: CatalogFeature

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(feature.title)
                .font(.title2.weight(.semibold))
            Text("0 of 13 bottled.")
            Text(feature.summary)
                .foregroundStyle(.secondary)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle(feature.title)
    }
}
