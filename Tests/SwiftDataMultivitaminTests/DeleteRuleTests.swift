import SwiftData
import Testing
@testable import SwiftDataMultivitamin

@MainActor
struct DeleteRuleTests {
    @Test func terraceBookNullifiesTheTicket() throws {
        let context = try MemoryStore.context(for: HarvestBook.self, RoseTicket.self)
        let rule = try storedRelationship(context, "HarvestBook", "tickets")
        let book = HarvestBook(deskName: "Upper terrace, Qamsar", clerkName: "Leila Amini")
        let ticket = RoseTicket(
            terraceName: "Upper terrace, Qamsar",
            growerName: "Leila Amini",
            baskets: 4,
            cutOn: GregorianDay.date(year: 2026, month: 5, day: 12, timeZoneIdentifier: "Asia/Tehran")
        )
        context.insert(book)
        context.insert(ticket)
        book.tickets.append(ticket)
        try context.save()
        context.delete(book)
        try context.save()
        let filed = ModelContext(context.container)
        let tickets = try filed.fetch(FetchDescriptor<RoseTicket>())
        let books = try filed.fetch(FetchDescriptor<HarvestBook>())

        #expect(rule.deleteRule == .nullify)
        #expect(books.isEmpty)
        #expect(tickets.count == 1)
        #expect(tickets.first?.baskets == 4)
        #expect(tickets.first?.book == nil)
    }

    @Test func filledJarKeepsItsLitres() throws {
        let context = try MemoryStore.context(for: DistillLot.self, FilledJar.self)
        let rule = try storedRelationship(context, "DistillLot", "jars")
        let lot = DistillLot(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let jar = FilledJar(jarCode: "J-1", litres: 18)
        context.insert(lot)
        context.insert(jar)
        lot.jars.append(jar)
        try context.save()
        context.delete(lot)
        try context.save()
        let jars = try ModelContext(context.container).fetch(FetchDescriptor<FilledJar>())
        let lots = try ModelContext(context.container).fetch(FetchDescriptor<DistillLot>())

        #expect(rule.deleteRule == .nullify)
        #expect(lots.isEmpty)
        #expect(jars.count == 1)
        #expect(jars.first?.litres == 18)
        #expect(jars.first?.lot == nil)
    }

    @Test func voidingTheCookDeletesTheSlips() throws {
        let context = try MemoryStore.context(for: CookBatch.self, TasteSlip.self)
        let cook = CookBatch(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let clear = TasteSlip(line: "Clear")
        let rose = TasteSlip(line: "Long rose")
        context.insert(cook)
        context.insert(clear)
        context.insert(rose)
        cook.slips.append(clear)
        cook.slips.append(rose)
        try context.save()
        context.delete(cook)
        try context.save()
        let filed = ModelContext(context.container)

        #expect(try storedRelationship(context, "CookBatch", "slips").deleteRule == .cascade)
        #expect(try filed.fetch(FetchDescriptor<CookBatch>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<TasteSlip>()).isEmpty)
    }

    @Test func tearingTheSlipLeavesTheCook() throws {
        let context = try MemoryStore.context(for: CookBatch.self, TasteSlip.self)
        let cook = CookBatch(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let clear = TasteSlip(line: "Clear")
        let rose = TasteSlip(line: "Long rose")
        context.insert(cook)
        context.insert(clear)
        context.insert(rose)
        cook.slips.append(clear)
        cook.slips.append(rose)
        try context.save()
        context.delete(clear)
        try context.save()
        let filed = ModelContext(context.container)
        let cooks = try filed.fetch(FetchDescriptor<CookBatch>())
        let slips = try filed.fetch(FetchDescriptor<TasteSlip>())

        #expect(try storedRelationship(context, "CookBatch", "slips").deleteRule == .cascade)
        #expect(try storedRelationship(context, "TasteSlip", "cook").deleteRule == .nullify)
        #expect(cooks.count == 1)
        #expect(cooks.first?.slips.map(\.line) == ["Long rose"])
        #expect(slips.map(\.line) == ["Long rose"])
    }

    @Test func voidingTheSealChitDeletesTheCook() throws {
        let context = try MemoryStore.context(for: SealChit.self, WarrantCook.self)
        let chit = SealChit(smithName: "Farhad Golshan", shopName: "Kashan bazaar, copper row")
        let cook = WarrantCook(lotCode: "QS-22")
        context.insert(chit)
        context.insert(cook)
        chit.cook = cook
        try context.save()
        context.delete(chit)
        try context.save()
        let filed = ModelContext(context.container)

        #expect(try storedRelationship(context, "SealChit", "cook").deleteRule == .cascade)
        #expect(try filed.fetch(FetchDescriptor<SealChit>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<WarrantCook>()).isEmpty)
    }

    @Test func denyStillSavesAndKeepsTheCook() throws {
        let context = try MemoryStore.context(for: CopperStill.self, ChargedCook.self)
        let still = CopperStill(stillName: "Still 2", smithName: "Farhad Golshan")
        let cook = ChargedCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        context.insert(still)
        context.insert(cook)
        still.cooks.append(cook)
        try context.save()
        context.delete(still)
        try context.save()
        let filed = ModelContext(context.container)
        let stills = try filed.fetch(FetchDescriptor<CopperStill>())
        let cooks = try filed.fetch(FetchDescriptor<ChargedCook>())

        #expect(try storedRelationship(context, "CopperStill", "cooks").deleteRule == .deny)
        #expect(stills.isEmpty)
        #expect(cooks.count == 1)
        #expect(cooks.first?.lotCode == "QS-22")
        #expect(cooks.first?.still == nil)
    }

    @Test func noActionLeavesTheMarkWithAnEmptyTally() throws {
        let context = try MemoryStore.context(for: WallTally.self, ChalkMark.self)
        let tally = WallTally(wallName: "Still-house wall, Qamsar", distillerName: "Hossein Nazeri")
        let mark = ChalkMark(lotCode: "QS-22")
        context.insert(tally)
        context.insert(mark)
        tally.marks.append(mark)
        try context.save()
        context.delete(tally)
        try context.save()
        let filed = ModelContext(context.container)
        let marks = try filed.fetch(FetchDescriptor<ChalkMark>())

        #expect(try storedRelationship(context, "WallTally", "marks").deleteRule == .noAction)
        #expect(try filed.fetch(FetchDescriptor<WallTally>()).isEmpty)
        #expect(marks.count == 1)
        #expect(marks.first?.lotCode == "QS-22")
        #expect(marks.first?.tally == nil)
    }

    @Test func voidingTheCookCascadesSlipsAndNullifiesTheStill() throws {
        let context = try MemoryStore.context(for: VoidCook.self, VoidSlip.self, BenchStill.self)
        let still = BenchStill(stillName: "Still 2")
        let cook = VoidCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let clear = VoidSlip(line: "Clear")
        let rose = VoidSlip(line: "Long rose")
        context.insert(still)
        context.insert(cook)
        context.insert(clear)
        context.insert(rose)
        cook.still = still
        cook.slips.append(clear)
        cook.slips.append(rose)
        try context.save()
        context.delete(cook)
        try context.save()
        let filed = ModelContext(context.container)
        let stills = try filed.fetch(FetchDescriptor<BenchStill>())

        #expect(try storedRelationship(context, "VoidCook", "slips").deleteRule == .cascade)
        #expect(try storedRelationship(context, "VoidCook", "still").deleteRule == .nullify)
        #expect(try filed.fetch(FetchDescriptor<VoidCook>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<VoidSlip>()).isEmpty)
        #expect(stills.count == 1)
        #expect(stills.first?.stillName == "Still 2")
        #expect(stills.first?.cook == nil)
    }

    @Test func voidingTheCookRemovesCorrections() throws {
        let context = try MemoryStore.context(for: LineCook.self, TasteLine.self, CorrectionNote.self)
        let cook = LineCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let clear = TasteLine(line: "Clear")
        let bright = CorrectionNote(line: "Bright")
        context.insert(cook)
        context.insert(clear)
        context.insert(bright)
        cook.lines.append(clear)
        clear.correction = bright
        try context.save()
        context.delete(cook)
        try context.save()
        let filed = ModelContext(context.container)

        #expect(try storedRelationship(context, "LineCook", "lines").deleteRule == .cascade)
        #expect(try storedRelationship(context, "TasteLine", "correction").deleteRule == .cascade)
        #expect(try filed.fetch(FetchDescriptor<LineCook>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<TasteLine>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<CorrectionNote>()).isEmpty)
    }

    @Test func voidingTheTrayKeepsTheLot() throws {
        let context = try MemoryStore.context(for: WeddingTray.self, PlaceCard.self, QamsarLot.self)
        let tray = WeddingTray(supperName: "Farahi supper, 20 May", hostName: "Maryam Farahi")
        let lot = QamsarLot(lotCode: "QS-22", litres: 18)
        let maryam = PlaceCard(seatName: "Maryam Farahi")
        let soraya = PlaceCard(seatName: "Soraya Dehghan")
        context.insert(tray)
        context.insert(lot)
        context.insert(maryam)
        context.insert(soraya)
        tray.cards.append(maryam)
        tray.cards.append(soraya)
        maryam.lot = lot
        soraya.lot = lot
        try context.save()
        context.delete(tray)
        try context.save()
        let filed = ModelContext(context.container)
        let lots = try filed.fetch(FetchDescriptor<QamsarLot>())

        #expect(try storedRelationship(context, "WeddingTray", "cards").deleteRule == .cascade)
        #expect(try storedRelationship(context, "PlaceCard", "lot").deleteRule == .nullify)
        #expect(try filed.fetch(FetchDescriptor<WeddingTray>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<PlaceCard>()).isEmpty)
        #expect(lots.count == 1)
        #expect(lots.first?.litres == 18)
        #expect(lots.first?.cards.isEmpty == true)
    }

    @Test func strikingOneJarLeavesTheSister() throws {
        let context = try MemoryStore.context(for: JarLot.self, RoseJar.self)
        let lot = JarLot(lotCode: "QS-22", litres: 18)
        let first = RoseJar(jarCode: "J-1")
        let second = RoseJar(jarCode: "J-2")
        context.insert(lot)
        context.insert(first)
        context.insert(second)
        first.lot = lot
        second.lot = lot
        try context.save()
        context.delete(first)
        try context.save()
        let filed = ModelContext(context.container)
        let jars = try filed.fetch(FetchDescriptor<RoseJar>())
        let lots = try filed.fetch(FetchDescriptor<JarLot>())

        #expect(try storedRelationship(context, "RoseJar", "lot").deleteRule == .nullify)
        #expect(lots.count == 1)
        #expect(lots.first?.litres == 18)
        #expect(jars.map(\.jarCode) == ["J-2"])
        #expect(jars.first?.lot?.lotCode == "QS-22")
    }

    @Test func blankCardStillDeletes() throws {
        let context = try MemoryStore.context(for: BlankCook.self, BlankSlip.self)
        let cook = BlankCook(lotCode: "QS-23", distillerName: "Hossein Nazeri")
        context.insert(cook)
        try context.save()
        context.delete(cook)
        try context.save()
        let filed = ModelContext(context.container)

        #expect(try storedRelationship(context, "BlankCook", "slips").deleteRule == .cascade)
        #expect(cook.slips.isEmpty)
        #expect(try filed.fetch(FetchDescriptor<BlankCook>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<BlankSlip>()).isEmpty)
    }

    @Test func morningFolderKeepsEachOutcome() throws {
        let context = try MemoryStore.context(for: RosewaterFolder.types)
        let cook = CookBatch(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let clear = TasteSlip(line: "Clear")
        let rose = TasteSlip(line: "Long rose")
        let lot = DistillLot(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let jar = FilledJar(jarCode: "J-1", litres: 18)
        let still = CopperStill(stillName: "Still 2", smithName: "Farhad Golshan")
        let charged = ChargedCook(lotCode: "QS-22", distillerName: "Hossein Nazeri")
        let tally = WallTally(wallName: "Still-house wall, Qamsar", distillerName: "Hossein Nazeri")
        let mark = ChalkMark(lotCode: "QS-22")
        context.insert(cook)
        context.insert(clear)
        context.insert(rose)
        context.insert(lot)
        context.insert(jar)
        context.insert(still)
        context.insert(charged)
        context.insert(tally)
        context.insert(mark)
        cook.slips.append(clear)
        cook.slips.append(rose)
        lot.jars.append(jar)
        still.cooks.append(charged)
        tally.marks.append(mark)
        try context.save()
        context.delete(cook)
        context.delete(lot)
        context.delete(still)
        context.delete(tally)
        try context.save()
        let filed = ModelContext(context.container)
        let jars = try filed.fetch(FetchDescriptor<FilledJar>())
        let cooks = try filed.fetch(FetchDescriptor<ChargedCook>())
        let marks = try filed.fetch(FetchDescriptor<ChalkMark>())

        #expect(try filed.fetch(FetchDescriptor<TasteSlip>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<CookBatch>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<DistillLot>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<CopperStill>()).isEmpty)
        #expect(try filed.fetch(FetchDescriptor<WallTally>()).isEmpty)
        #expect(jars.first?.litres == 18)
        #expect(jars.first?.lot == nil)
        #expect(cooks.first?.lotCode == "QS-22")
        #expect(cooks.first?.still == nil)
        #expect(marks.first?.lotCode == "QS-22")
        #expect(marks.first?.tally == nil)
    }

    private func storedRelationship(
        _ context: ModelContext,
        _ typeName: String,
        _ name: String
    ) throws -> Schema.Relationship {
        let entity = try #require(context.container.schema.entities.first { $0.name == typeName })
        return try #require(entity.relationshipsByName[name])
    }
}
