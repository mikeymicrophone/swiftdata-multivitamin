import SwiftData
import Testing
@testable import SwiftDataMultivitamin

@MainActor
struct TransientTests {
    @Test func seamNoteIsAbsentFromTheSchema() throws {
        let context = try MemoryStore.context(for: SepetciLump.self)
        let lump = SepetciLump(
            lumpCode: "EB-7",
            cutterName: "Kemal Aydın",
            grams: 180,
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 2, timeZoneIdentifier: "Europe/Istanbul"),
            seamNote: "Avoid the grey seam"
        )
        context.insert(lump)
        try context.save()
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<SepetciLump>())

        #expect(StoredAttribute.propertyNames(on: "SepetciLump", in: context.container.schema) == ["cutOn", "cutterName", "grams", "lumpCode"])
        #expect(lump.seamNote == "Avoid the grey seam")
        #expect(filed.first?.lumpCode == "EB-7")
        #expect(filed.first?.seamNote == "")
    }

    @Test func openingCountStaysOnTheOpenCard() throws {
        let context = try MemoryStore.context(for: CarvedBowl.self)
        let bowl = CarvedBowl(
            bowlName: "Lattice egg",
            carverName: "Nesrin Kaya",
            carvedOn: GregorianDay.date(year: 2026, month: 4, day: 3, timeZoneIdentifier: "Europe/Istanbul"),
            openings: 14
        )
        context.insert(bowl)
        try context.save()
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<CarvedBowl>())

        #expect(bowl.openings == 14)
        #expect(filed.first?.bowlName == "Lattice egg")
        #expect(filed.first?.openings == 0)
    }

    @Test func whisperComesBackNil() throws {
        let context = try MemoryStore.context(for: WaxCook.self)
        let cook = WaxCook(
            lotCode: "WX-7",
            waxerName: "Yusuf Demir",
            cookedOn: GregorianDay.date(year: 2026, month: 4, day: 4, timeZoneIdentifier: "Europe/Istanbul"),
            whisper: "Cooler than yesterday"
        )
        context.insert(cook)
        try context.save()
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<WaxCook>())

        #expect(!StoredAttribute.propertyNames(on: "WaxCook", in: context.container.schema).contains("whisper"))
        #expect(cook.whisper == "Cooler than yesterday")
        #expect(filed.first?.lotCode == "WX-7")
        #expect(filed.first?.whisper == nil)
    }

    @Test func nickComesBackAsTheDefault() throws {
        let context = try MemoryStore.context(for: StemFit.self)
        let stem = StemFit(
            wood: "Cherry",
            fitterName: "Halime Öztürk",
            fittedOn: GregorianDay.date(year: 2026, month: 4, day: 5, timeZoneIdentifier: "Europe/Istanbul"),
            nick: "Tight on the tenon"
        )
        context.insert(stem)
        try context.save()
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<StemFit>())

        #expect(stem.nick == "Tight on the tenon")
        #expect(filed.first?.wood == "Cherry")
        #expect(filed.first?.nick == "Still in the cloth")
    }

    @Test func latticeScratchIsNotAColumn() throws {
        let context = try MemoryStore.context(for: LatticeBowl.self)
        let bowl = LatticeBowl(
            bowlName: "Lattice egg",
            carverName: "Nesrin Kaya",
            carvedOn: GregorianDay.date(year: 2026, month: 4, day: 6, timeZoneIdentifier: "Europe/Istanbul"),
            scratch: .marked(openings: 14, note: "Stop before the grey")
        )
        context.insert(bowl)
        try context.save()
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<LatticeBowl>())

        #expect(StoredAttribute.propertyNames(on: "LatticeBowl", in: context.container.schema) == ["bowlName", "carvedOn", "carverName"])
        #expect(bowl.scratch.openings == 14)
        #expect(bowl.scratch.note == "Stop before the grey")
        #expect(filed.first?.bowlName == "Lattice egg")
        #expect(filed.first?.scratch.openings == 0)
        #expect(filed.first?.scratch.note == "")
        #expect(filed.first?.scratch == .blank)
    }

    @Test func bothCaseNotesReset() throws {
        let context = try MemoryStore.context(for: HideCase.self)
        let hide = HideCase(
            grade: "Oxhide",
            makerName: "Cemil Arslan",
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 7, timeZoneIdentifier: "Europe/Istanbul"),
            stitchAside: "Stay proud of the seam",
            spareThongs: 3
        )
        context.insert(hide)
        try context.save()
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<HideCase>())
        let columns = StoredAttribute.propertyNames(on: "HideCase", in: context.container.schema)

        #expect(columns == ["cutOn", "grade", "makerName"])
        #expect(filed.first?.grade == "Oxhide")
        #expect(filed.first?.stitchAside == "")
        #expect(filed.first?.spareThongs == 0)
    }

    @Test func asideDoesNotMarkTheContext() throws {
        let context = try MemoryStore.context(for: BedestenCard.self)
        let card = BedestenCard(
            pipeCode: "EB-7",
            sellerName: "Aylin Şahin",
            priceLira: 4000,
            openedOn: GregorianDay.date(year: 2026, month: 4, day: 8, timeZoneIdentifier: "Europe/Istanbul")
        )
        context.insert(card)
        try context.save()
        card.aside = "Emre will collect at dusk"

        #expect(!context.hasChanges)
        try context.save()
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<BedestenCard>())

        #expect(card.aside == "Emre will collect at dusk")
        #expect(filed.first?.priceLira == 4000)
        #expect(filed.first?.aside == "")
    }

    @Test func priceIsFiledAndTheAsideIsNot() throws {
        let context = try MemoryStore.context(for: BedestenCard.self)
        let card = BedestenCard(
            pipeCode: "EB-7",
            sellerName: "Aylin Şahin",
            priceLira: 4000,
            openedOn: GregorianDay.date(year: 2026, month: 4, day: 9, timeZoneIdentifier: "Europe/Istanbul")
        )
        context.insert(card)
        try context.save()
        card.aside = "Hold it for Emre"
        card.priceLira = 4500
        try context.save()
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<BedestenCard>())

        #expect(card.aside == "Hold it for Emre")
        #expect(card.priceLira == 4500)
        #expect(filed.first?.priceLira == 4500)
        #expect(filed.first?.aside == "")
    }

    @Test func sameContextReturnsTheSameCard() throws {
        let context = try MemoryStore.context(for: BedestenCard.self)
        let card = BedestenCard(
            pipeCode: "EB-7",
            sellerName: "Aylin Şahin",
            priceLira: 4500,
            openedOn: GregorianDay.date(year: 2026, month: 4, day: 10, timeZoneIdentifier: "Europe/Istanbul"),
            aside: "Wrapped in newspaper"
        )
        context.insert(card)
        try context.save()
        let same = try context.fetch(FetchDescriptor<BedestenCard>())
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<BedestenCard>())

        #expect(same.first === card)
        #expect(same.first?.aside == "Wrapped in newspaper")
        #expect(filed.first !== card)
        #expect(filed.first?.aside == "")
    }

    @Test func eachLumpKeepsItsOwnNote() throws {
        let context = try MemoryStore.context(for: SepetciLump.self)
        let first = SepetciLump(
            lumpCode: "EB-7",
            cutterName: "Kemal Aydın",
            grams: 180,
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 2, timeZoneIdentifier: "Europe/Istanbul"),
            seamNote: "Avoid the grey seam"
        )
        let spare = SepetciLump(
            lumpCode: "EB-8",
            cutterName: "Kemal Aydın",
            grams: 210,
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 11, timeZoneIdentifier: "Europe/Istanbul"),
            seamNote: "Clear at the foot"
        )
        context.insert(first)
        context.insert(spare)
        try context.save()
        let open = try context.fetch(FetchDescriptor<SepetciLump>())
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<SepetciLump>())

        #expect(open.first { $0.lumpCode == "EB-7" }?.seamNote == "Avoid the grey seam")
        #expect(open.first { $0.lumpCode == "EB-8" }?.seamNote == "Clear at the foot")
        #expect(filed.first { $0.lumpCode == "EB-7" }?.seamNote == "")
        #expect(filed.first { $0.lumpCode == "EB-8" }?.seamNote == "")
        #expect(filed.map(\.grams).sorted() == [180, 210])
    }

    @Test func eachBenchOmitsItsAside() throws {
        let context = try MemoryStore.context(for: WaxCook.self, StemFit.self)
        let cook = WaxCook(
            lotCode: "WX-7",
            waxerName: "Yusuf Demir",
            cookedOn: GregorianDay.date(year: 2026, month: 4, day: 4, timeZoneIdentifier: "Europe/Istanbul"),
            whisper: "Cooler than yesterday"
        )
        let stem = StemFit(
            wood: "Cherry",
            fitterName: "Halime Öztürk",
            fittedOn: GregorianDay.date(year: 2026, month: 4, day: 5, timeZoneIdentifier: "Europe/Istanbul"),
            nick: "Tight on the tenon"
        )
        context.insert(cook)
        context.insert(stem)
        try context.save()
        let filed = ModelContext(context.container)

        #expect(StoredAttribute.propertyNames(on: "WaxCook", in: context.container.schema) == ["cookedOn", "lotCode", "waxerName"])
        #expect(StoredAttribute.propertyNames(on: "StemFit", in: context.container.schema) == ["fittedOn", "fitterName", "wood"])
        #expect(try filed.fetch(FetchDescriptor<WaxCook>()).first?.lotCode == "WX-7")
        #expect(try filed.fetch(FetchDescriptor<WaxCook>()).first?.whisper == nil)
        #expect(try filed.fetch(FetchDescriptor<StemFit>()).first?.wood == "Cherry")
        #expect(try filed.fetch(FetchDescriptor<StemFit>()).first?.nick == "Still in the cloth")
    }

    @Test func trialHourComesBackAsTheOpening() throws {
        let context = try MemoryStore.context(for: TrialFit.self)
        let opening = BenchClock.date(year: 2026, month: 4, day: 13, hour: 8)
        let trial = BenchClock.date(year: 2026, month: 4, day: 13, hour: 16)
        let stem = TrialFit(
            wood: "Cherry",
            fitterName: "Halime Öztürk",
            fittedOn: GregorianDay.date(year: 2026, month: 4, day: 13, timeZoneIdentifier: "Europe/Istanbul"),
            triedAt: trial
        )
        context.insert(stem)
        try context.save()
        let filed = try ModelContext(context.container).fetch(FetchDescriptor<TrialFit>())

        #expect(!StoredAttribute.propertyNames(on: "TrialFit", in: context.container.schema).contains("triedAt"))
        #expect(stem.triedAt == trial)
        #expect(filed.first?.wood == "Cherry")
        #expect(filed.first?.triedAt == opening)
        #expect(stem.hoursAfterOpening == 8)
        #expect(filed.first?.hoursAfterOpening == 0)
    }

    @Test func morningFolderDefaultsEveryAside() throws {
        let context = try MemoryStore.context(for: PipeFolder.types)
        let lump = SepetciLump(
            lumpCode: "EB-7",
            cutterName: "Kemal Aydın",
            grams: 180,
            cutOn: GregorianDay.date(year: 2026, month: 4, day: 2, timeZoneIdentifier: "Europe/Istanbul"),
            seamNote: "Avoid the grey seam"
        )
        let bowl = CarvedBowl(
            bowlName: "Lattice egg",
            carverName: "Nesrin Kaya",
            carvedOn: GregorianDay.date(year: 2026, month: 4, day: 3, timeZoneIdentifier: "Europe/Istanbul"),
            openings: 14
        )
        let cook = WaxCook(
            lotCode: "WX-7",
            waxerName: "Yusuf Demir",
            cookedOn: GregorianDay.date(year: 2026, month: 4, day: 4, timeZoneIdentifier: "Europe/Istanbul"),
            whisper: "Cooler than yesterday"
        )
        let stem = StemFit(
            wood: "Cherry",
            fitterName: "Halime Öztürk",
            fittedOn: GregorianDay.date(year: 2026, month: 4, day: 5, timeZoneIdentifier: "Europe/Istanbul"),
            nick: "Tight on the tenon"
        )
        context.insert(lump)
        context.insert(bowl)
        context.insert(cook)
        context.insert(stem)
        try context.save()
        let filed = ModelContext(context.container)
        let names = Set(context.container.schema.entities.map(\.name))

        #expect(names == ["CarvedBowl", "SepetciLump", "StemFit", "WaxCook"])
        #expect(!StoredAttribute.propertyNames(on: "SepetciLump", in: context.container.schema).contains("seamNote"))
        #expect(!StoredAttribute.propertyNames(on: "CarvedBowl", in: context.container.schema).contains("openings"))
        #expect(!StoredAttribute.propertyNames(on: "WaxCook", in: context.container.schema).contains("whisper"))
        #expect(!StoredAttribute.propertyNames(on: "StemFit", in: context.container.schema).contains("nick"))
        #expect(try filed.fetch(FetchDescriptor<SepetciLump>()).first?.lumpCode == "EB-7")
        #expect(try filed.fetch(FetchDescriptor<SepetciLump>()).first?.seamNote == "")
        #expect(try filed.fetch(FetchDescriptor<CarvedBowl>()).first?.openings == 0)
        #expect(try filed.fetch(FetchDescriptor<WaxCook>()).first?.whisper == nil)
        #expect(try filed.fetch(FetchDescriptor<StemFit>()).first?.nick == "Still in the cloth")
        #expect(lump.seamNote == "Avoid the grey seam")
        #expect(bowl.openings == 14)
        #expect(cook.whisper == "Cooler than yesterday")
        #expect(stem.nick == "Tight on the tenon")
    }
}
