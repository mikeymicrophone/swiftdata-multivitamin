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
        case "01-lucanas-ear-mark":
            ShearingLicenseScreen()
        case "02-arequipa-weigh-photo":
            WeighTicketScreen()
        case "03-puno-lot-spotlight":
            RoadLotScreen()
        case "04-sucre-dye-note":
            DyeFormulaScreen()
        case "05-lucanas-agreed-price":
            AgreedPriceScreen()
        case "06-arequipa-renamed-kilos":
            ScouredWeightScreen()
        case "07-arequipa-ledger-reprint":
            SeasonReprintScreen()
        case "08-la-paz-spoken-markup":
            ShawlCounterScreen()
        case "09-tarabuco-micron-reading":
            FiberSampleScreen()
        case "10-puno-bale-code":
            BalePlateScreen()
        case "11-puno-seal-and-photo":
            BalePackScreen()
        case "12-lucanas-second-card":
            SecondLicenseScreen()
        case "13-la-paz-morning-folder":
            ShawlHandoverScreen()
        case "01-plasne-milk-note":
            MilkNoteScreen()
        case "02-plateau-roll":
            PlateauRollScreen()
        case "03-plasne-member-book":
            CoopRollScreen()
        case "04-plasne-morning-vat":
            MorningVatScreen()
        case "05-rousses-young-cave":
            YoungCaveScreen()
        case "06-champagnole-spruce-board":
            SpruceBoardScreen()
        case "07-besancon-supper-card":
            SupperOrderScreen()
        case "08-poligny-jury":
            JuryWheelScreen()
        case "09-poligny-tasting-slip":
            TastingSlipScreen()
        case "10-rousses-renamed-rack":
            CheeseRackScreen()
        case "11-plasne-guest-reprint":
            GuestReprintScreen()
        case "12-rousses-aged-cave":
            AgedCaveScreen()
        case "13-besancon-morning-folder":
            ComteHandoverScreen()
        case "01-qamsar-terrace-book":
            HarvestBookScreen()
        case "02-qamsar-filled-jar":
            FilledJarScreen()
        case "03-qamsar-cook-slips":
            CookBatchScreen()
        case "04-qamsar-torn-slip":
            TornSlipScreen()
        case "05-kashan-seal-chit":
            SealChitScreen()
        case "06-qamsar-copper-still":
            CopperStillScreen()
        case "07-qamsar-wall-tally":
            WallTallyScreen()
        case "08-qamsar-cook-and-still":
            CookAndStillScreen()
        case "09-qamsar-correction-line":
            CorrectionLineScreen()
        case "10-yazd-wedding-tray":
            WeddingTrayScreen()
        case "11-yazd-sister-jar":
            SisterJarScreen()
        case "12-qamsar-blank-card":
            BlankCardScreen()
        case "13-yazd-morning-folder":
            RosewaterHandoverScreen()
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
