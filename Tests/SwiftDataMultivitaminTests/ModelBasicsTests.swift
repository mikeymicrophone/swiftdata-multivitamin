import SwiftData
import Testing
@testable import SwiftDataMultivitamin

@MainActor
struct ModelBasicsTests {
    @Test func quinceCommissionStoresTheFieldsYouPass() throws {
        let orderedOn = GregorianDay.date(year: 2026, month: 3, day: 3, timeZoneIdentifier: "Asia/Tbilisi")
        let commission = QuinceCommission(
            roomName: "Works on Paper, Georgian National Museum",
            curatorName: "Nino Beridze",
            studyTitle: "Quince branch, Vera courtyard",
            plateCount: 6,
            impressionCount: 40,
            orderedOn: orderedOn
        )
        let context = try MemoryStore.context(for: QuinceCommission.self)
        context.insert(commission)

        #expect(commission.curatorName == "Nino Beridze")
        #expect(commission.plateCount == 6)
        #expect(commission.impressionCount == 40)
        #expect(commission.orderedOn == orderedOn)
        #expect(context.hasChanges)
    }

    @Test func copperBlankTicketRefusesAnEmptySlip() {
        let milledOn = GregorianDay.date(year: 2026, month: 3, day: 5, timeZoneIdentifier: "Europe/Warsaw")
        let missing = CopperBlankTicket.ticket(
            lotCode: "  ",
            blankCount: 6,
            thicknessMillimetres: 0.8,
            alloy: "electrolytic copper",
            milledOn: milledOn
        )
        let written = CopperBlankTicket.ticket(
            lotCode: " LG-220 ",
            blankCount: 6,
            thicknessMillimetres: 0.8,
            alloy: "electrolytic copper",
            milledOn: milledOn
        )

        #expect(missing == nil)
        #expect(written?.lotCode == "LG-220")
        #expect(written?.blankCount == 6)
        #expect(written?.thicknessMillimetres == 0.8)
        #expect(written?.alloy == "electrolytic copper")
    }

    @Test func biteNoteCanLeaveTheOptionalLinesBlank() {
        let note = BiteNote(plateCode: "HV-6", groundName: "hard ground", minutesInBath: 18)

        #expect(note.foulBiteNote == nil)
        #expect(note.nextBathAt == nil)
        #expect(note.minutesInBath == 18)
    }

    @Test func boneBlackBatchStartsFromTheHouseFormula() {
        let openedOn = GregorianDay.date(year: 2026, month: 3, day: 8, timeZoneIdentifier: "Europe/Madrid")
        let batch = BoneBlackBatch(openedOn: openedOn)

        #expect(batch.pigmentName == "bone black")
        #expect(batch.grindPasses == 4)
        #expect(batch.approved == false)

        batch.grindPasses = 6
        batch.approved = true
        #expect(batch.grindPasses == 6)
        #expect(batch.approved == true)

        batch.restoreHouseFormula()
        #expect(batch.pigmentName == "bone black")
        #expect(batch.grindPasses == 4)
        #expect(batch.approved == false)
        #expect(batch.openedOn == openedOn)
    }

    @Test func ragDampSlipStoresThePlainValueTypes() {
        let dampedOn = GregorianDay.date(year: 2026, month: 3, day: 9, timeZoneIdentifier: "Europe/Rome")
        let slip = RagDampSlip(
            ragDescription: "Cotton offcuts from the Prato mills",
            sheetCount: 80,
            dampPercent: 42.5,
            sized: true,
            dampedOn: dampedOn
        )

        #expect(slip.ragDescription == "Cotton offcuts from the Prato mills")
        #expect(slip.sheetCount == 80)
        #expect(slip.dampPercent == 42.5)
        #expect(slip.sized == true)
        #expect(slip.dampedOn == dampedOn)
    }

    @Test func veronaSlipsStaySeparateRecords() throws {
        let context = try MemoryStore.context(for: PlateCrateLabel.self, PlateWaybill.self)
        let label = PlateCrateLabel(
            crateCode: "VR-14",
            contents: "Six bitten copper plates, waxed",
            handlingNote: "This side up"
        )
        let waybill = PlateWaybill(
            waybillCode: "BR-338",
            carrierDesk: "Brenner road desk",
            leavesOn: GregorianDay.date(year: 2026, month: 3, day: 11, timeZoneIdentifier: "Europe/Rome")
        )
        context.insert(label)
        context.insert(waybill)

        label.handlingNote = "Glass this side, waxed plates"

        let names = Set(context.container.schema.entities.map(\.name))
        #expect(names.contains("PlateCrateLabel"))
        #expect(names.contains("PlateWaybill"))
        #expect(names.count == 2)
        #expect(label.handlingNote == "Glass this side, waxed plates")
        #expect(waybill.carrierDesk == "Brenner road desk")
        #expect(waybill.waybillCode == "BR-338")
    }

    @Test func spokenSummaryIsNotAStoredProperty() throws {
        let briefing = DeskBriefing(
            curatorName: "Nino Beridze",
            roomName: "Works on Paper room",
            studyTitle: "Quince branch, Vera courtyard",
            plateCount: 6,
            impressionCount: 40,
            orderedOn: GregorianDay.date(year: 2026, month: 3, day: 3, timeZoneIdentifier: "Asia/Tbilisi")
        )
        let propertyNames = try storedPropertyNames(DeskBriefing.self)

        #expect(
            briefing.spokenSummary()
                == "Nino Beridze tells the Works on Paper room that Quince branch, Vera courtyard needs 6 plates and 40 impressions, ordered 3 March 2026."
        )
        #expect(!propertyNames.contains("spokenSummary"))
        #expect(propertyNames.contains("studyTitle"))
        #expect(propertyNames.contains("plateCount"))
    }

    @Test func plateJobIdentitySurvivesAStateChange() throws {
        let context = try MemoryStore.context(for: PlateJob.self)
        let job = PlateJob(
            jobCode: "HV-6",
            plateCode: "HV-6",
            state: "bitten",
            keeperName: "Mariam Gelashvili"
        )
        context.insert(job)
        let identityAtOpening = job.persistentModelID

        job.state = "in the Works on Paper room"

        #expect(job.persistentModelID == identityAtOpening)
        #expect(job.state == "in the Works on Paper room")
    }

    @Test func twoGrindEntriesStayIndependent() throws {
        let context = try MemoryStore.context(for: GrindEntry.self)
        let first = GrindEntry(
            batchCode: "BP-19-A",
            pigmentName: "bone black",
            grindPasses: 4,
            millerName: "Joana Puig"
        )
        let second = GrindEntry(
            batchCode: "BP-19-B",
            pigmentName: "bone black with burnt sienna",
            grindPasses: 2,
            millerName: "Joana Puig"
        )
        context.insert(first)
        context.insert(second)

        second.grindPasses = 6

        #expect(first.grindPasses == 4)
        #expect(first.pigmentName == "bone black")
        #expect(second.grindPasses == 6)
        #expect(first.persistentModelID != second.persistentModelID)
    }

    @Test func millSchemaOmitsTheTbilisiCommission() throws {
        let names = Set(FioravantiMillBook.schema.entities.map(\.name))
        let container = try MemoryStore.make([RagLot.self, DeckleProof.self])

        #expect(names == Set(container.schema.entities.map(\.name)))
        #expect(names.contains("RagLot"))
        #expect(names.contains("DeckleProof"))
        #expect(!names.contains("QuinceCommission"))
        #expect(names.count == 2)
    }

    @Test func shelfCardEditsInPlace() {
        let card = ShelfCard(
            shopName: "Vera District Print Room",
            sellerName: "Luka Katsitadze",
            studyTitle: "Quince branch, Vera courtyard",
            askingPriceLari: 85
        )

        card.askingPriceLari = 90

        #expect(card.askingPriceLari == 90)
        #expect(card.sellerName == "Luka Katsitadze")
    }

    @Test func benchSlipInsertRegistersTheSameInstance() throws {
        let context = try MemoryStore.context(for: BenchSlip.self)
        let slip = BenchSlip(
            roomName: "Albertina study room",
            conservatorName: "Elif Berger",
            impressionMark: "AP 2/6",
            benchNote: "Foxing check clear along the deckle"
        )

        #expect(!context.hasChanges)
        context.insert(slip)

        #expect(context.hasChanges)
        #expect(slip.impressionMark == "AP 2/6")
        #expect(slip.benchNote == "Foxing check clear along the deckle")
    }

    @Test func morningFolderHoldsFourUnlinkedModels() throws {
        let context = try MemoryStore.context(for: MorningFolder.types)
        let names = Set(context.container.schema.entities.map(\.name))

        #expect(names == ["PlateJob", "QuinceCommission", "RagDampSlip", "ShelfCard"])
        #expect(names.count == 4)
    }

    @Test func catalogBottlesTheFirstFourFeatures() {
        #expect(Catalog.features.count == 21)
        #expect(Catalog.features[0].scenarios.count == 13)
        #expect(Catalog.features[1].scenarios.count == 13)
        #expect(Catalog.features[2].scenarios.count == 13)
        #expect(Catalog.features[3].scenarios.count == 13)
        #expect(Catalog.features.dropFirst(4).allSatisfy { $0.scenarios.isEmpty })
    }

    private func storedPropertyNames(_ type: any PersistentModel.Type) throws -> Set<String> {
        let container = try MemoryStore.make([type])
        let names = container.schema.entities.flatMap { entity in
            entity.properties.map(\.name)
        }
        return Set(names)
    }
}
