import SwiftData
import Testing
@testable import SwiftDataMultivitamin

@MainActor
struct RelationshipTests {
    @Test func milkNoteStartsBlankAndThenJoinsTheRoll() throws {
        let context = try MemoryStore.context(for: MilkNote.self, Fruitiere.self)
        let link = try storedRelationship(context, "MilkNote", "fruitiere")
        let fruitiere = Fruitiere(
            deskName: "Fruitière du Plateau de Plasne",
            cheesemakerName: "Lucien Morel"
        )
        let note = MilkNote(
            farmName: "Ferme Pellier, Plasne",
            farmerName: "Hélène Pellier",
            litres: 86,
            notedOn: GregorianDay.date(year: 2026, month: 9, day: 2, timeZoneIdentifier: "Europe/Paris")
        )
        context.insert(fruitiere)
        context.insert(note)

        #expect(link.isToOneRelationship)
        #expect(link.destination == "Fruitiere")
        #expect(link.inverseName == "notes")
        #expect(note.fruitiere == nil)
        #expect(fruitiere.notes.isEmpty)

        note.fruitiere = fruitiere
        #expect(note.fruitiere?.cheesemakerName == "Lucien Morel")
        #expect(fruitiere.notes.map(\.farmName) == ["Ferme Pellier, Plasne"])
    }

    @Test func plateauRollHoldsBothNotesWhenTheMaximumIsZero() throws {
        let context = try MemoryStore.context(for: MilkNote.self, Fruitiere.self)
        let roll = try storedRelationship(context, "Fruitiere", "notes")
        let notedOn = GregorianDay.date(year: 2026, month: 9, day: 2, timeZoneIdentifier: "Europe/Paris")
        let fruitiere = Fruitiere(
            deskName: "Fruitière du Plateau de Plasne",
            cheesemakerName: "Lucien Morel"
        )
        let pellier = MilkNote(
            farmName: "Ferme Pellier, Plasne",
            farmerName: "Hélène Pellier",
            litres: 86,
            notedOn: notedOn
        )
        let gaillard = MilkNote(
            farmName: "Ferme Gaillard, Le Fied",
            farmerName: "Antoine Gaillard",
            litres: 74,
            notedOn: notedOn
        )
        context.insert(fruitiere)
        context.insert(pellier)
        context.insert(gaillard)
        fruitiere.notes.append(pellier)
        fruitiere.notes.append(gaillard)

        #expect(roll.isToOneRelationship == false)
        #expect(roll.minimumModelCount == 0)
        #expect(roll.maximumModelCount == 0)
        #expect(fruitiere.notes.count == 2)
        #expect(pellier.fruitiere?.deskName == "Fruitière du Plateau de Plasne")
        #expect(gaillard.fruitiere?.deskName == "Fruitière du Plateau de Plasne")
    }

    @Test func memberAndGuestLinksStayOnTheirOwnInverses() throws {
        let context = try MemoryStore.context(for: CoopRoll.self, CoopHand.self)
        let members = try storedRelationship(context, "CoopRoll", "members")
        let guests = try storedRelationship(context, "CoopRoll", "guests")
        let roll = CoopRoll(deskName: "Fruitière du Plateau de Plasne")
        let member = CoopHand(handName: "Hélène Pellier", farmName: "Ferme Pellier, Plasne")
        let guest = CoopHand(handName: "Antoine Gaillard", farmName: "Ferme Gaillard, Le Fied")
        context.insert(roll)
        context.insert(member)
        context.insert(guest)
        roll.members.append(member)
        roll.guests.append(guest)

        #expect(members.inverseName == "membership")
        #expect(guests.inverseName == "visit")
        #expect(member.membership?.deskName == roll.deskName)
        #expect(member.visit == nil)
        #expect(guest.visit?.deskName == roll.deskName)
        #expect(guest.membership == nil)
    }

    @Test func markingTheVatFillsTheVatList() throws {
        let context = try MemoryStore.context(for: VatWheel.self, MorningVat.self)
        let vat = MorningVat(vatName: "Cuve du matin", cheesemakerName: "Lucien Morel")
        let wheel = VatWheel(code: "PL-19")
        context.insert(vat)
        context.insert(wheel)
        #expect(vat.wheels.isEmpty)

        wheel.vat = vat

        #expect(wheel.vat?.vatName == "Cuve du matin")
        #expect(vat.wheels.map(\.code) == ["PL-19"])
    }

    @Test func takingAWheelOffTheRackLeavesItInTheStore() throws {
        let context = try MemoryStore.context(for: CaveWheel.self, AgingCave.self)
        let cave = AgingCave(caveName: "Cave jeune, Les Rousses", affineurName: "Claire Roux")
        let kept = CaveWheel(code: "PL-19")
        let cracked = CaveWheel(code: "PL-03")
        context.insert(cave)
        context.insert(kept)
        context.insert(cracked)
        cave.wheels.append(kept)
        cave.wheels.append(cracked)
        #expect(cracked.cave?.caveName == "Cave jeune, Les Rousses")

        cave.wheels.removeAll { $0.code == "PL-03" }
        try context.save()
        let filed = ModelContext(context.container)
        let wheels = try filed.fetch(FetchDescriptor<CaveWheel>())

        #expect(kept.cave?.caveName == "Cave jeune, Les Rousses")
        #expect(cracked.cave == nil)
        #expect(cave.wheels.map(\.code) == ["PL-19"])
        #expect(Set(wheels.map(\.code)) == ["PL-19", "PL-03"])
        #expect(wheels.first { $0.code == "PL-03" }?.cave == nil)
    }

    @Test func secondBoardTakesTheWheelAndTheFirstBoardRemains() throws {
        let context = try MemoryStore.context(for: SpruceBoard.self, BoardWheel.self)
        let link = try storedRelationship(context, "SpruceBoard", "wheel")
        let wheel = BoardWheel(code: "PL-19")
        let first = SpruceBoard(boardCode: "SP-1", millerName: "Marc Bouvet")
        let second = SpruceBoard(boardCode: "SP-2", millerName: "Marc Bouvet")
        context.insert(wheel)
        context.insert(first)
        context.insert(second)
        first.wheel = wheel
        #expect(wheel.board?.boardCode == "SP-1")

        second.wheel = wheel
        try context.save()
        let filed = ModelContext(context.container)
        let boards = try filed.fetch(FetchDescriptor<SpruceBoard>())

        #expect(link.isUnique)
        #expect(link.options.contains(.unique))
        #expect(link.maximumModelCount == 1)
        #expect(first.wheel == nil)
        #expect(second.wheel?.code == "PL-19")
        #expect(wheel.board?.boardCode == "SP-2")
        #expect(boards.count == 2)
        #expect(boards.first { $0.boardCode == "SP-1" }?.wheel == nil)
        #expect(boards.first { $0.boardCode == "SP-2" }?.wheel?.code == "PL-19")
    }

    @Test func supperCardFilesWithNoBuyer() throws {
        let context = try MemoryStore.context(for: SupperOrder.self, SupperBuyer.self)
        let link = try storedRelationship(context, "SupperOrder", "buyer")
        let order = SupperOrder(
            supperName: "Odile Marchand supper, 20 September",
            shopName: "Fromagerie Vercel, Grande Rue",
            clerkName: "Chantal Vercel",
            bookedOn: GregorianDay.date(year: 2026, month: 9, day: 7, timeZoneIdentifier: "Europe/Paris")
        )
        context.insert(order)
        try context.save()
        let filed = ModelContext(context.container)
        let cards = try filed.fetch(FetchDescriptor<SupperOrder>())

        #expect(link.minimumModelCount == 1)
        #expect(link.isToOneRelationship)
        #expect(link.inverseName == nil)
        #expect(link.destination == "SupperBuyer")
        #expect(cards.count == 1)
        #expect(cards.first?.buyer == nil)
        #expect(cards.first?.clerkName == "Chantal Vercel")
    }

    @Test func juryLinksFromEitherSide() throws {
        let context = try MemoryStore.context(for: JuryWheel.self, JuryTaster.self)
        let tasters = try storedRelationship(context, "JuryWheel", "tasters")
        let wheels = try storedRelationship(context, "JuryTaster", "wheels")
        let wheel = JuryWheel(code: "PL-19")
        let ines = JuryTaster(tasterName: "Inès Garnier")
        let paul = JuryTaster(tasterName: "Paul Besnard")
        context.insert(wheel)
        context.insert(ines)
        context.insert(paul)
        wheel.tasters.append(ines)
        paul.wheels.append(wheel)
        try context.save()
        let filed = ModelContext(context.container)
        let fetched = try filed.fetch(FetchDescriptor<JuryWheel>())

        #expect(tasters.isToOneRelationship == false)
        #expect(wheels.isToOneRelationship == false)
        #expect(ines.wheels.map(\.code) == ["PL-19"])
        #expect(paul.wheels.map(\.code) == ["PL-19"])
        #expect(Set(wheel.tasters.map(\.tasterName)) == ["Inès Garnier", "Paul Besnard"])
        #expect(Set(fetched.first?.tasters.map(\.tasterName) ?? []) == ["Inès Garnier", "Paul Besnard"])
    }

    @Test func tastingSlipBelongsToOneTasterAndOneWheel() throws {
        let context = try MemoryStore.context(for: TastingSlip.self, SlipTaster.self, SlipWheel.self)
        let tasterLink = try storedRelationship(context, "TastingSlip", "taster")
        let wheelLink = try storedRelationship(context, "TastingSlip", "wheel")
        let taster = SlipTaster(tasterName: "Inès Garnier")
        let wheel = SlipWheel(code: "PL-19")
        let slip = TastingSlip(
            note: "Supple paste, fruit long, no hole",
            scoredOn: GregorianDay.date(year: 2026, month: 9, day: 9, timeZoneIdentifier: "Europe/Paris")
        )
        context.insert(taster)
        context.insert(wheel)
        context.insert(slip)
        slip.taster = taster
        slip.wheel = wheel

        #expect(tasterLink.isToOneRelationship)
        #expect(wheelLink.isToOneRelationship)
        #expect(tasterLink.inverseName == "slips")
        #expect(wheelLink.inverseName == "slips")
        #expect(taster.slips.count == 1)
        #expect(wheel.slips.count == 1)
        #expect(slip.taster?.tasterName == "Inès Garnier")
        #expect(slip.wheel?.code == "PL-19")
    }

    @Test func renamedRackKeepsThreeOriginalNames() throws {
        let context = try MemoryStore.context(for: CheeseRack.self, RackWheel.self, ShelfLabel.self)
        let wheels = try storedRelationship(context, "CheeseRack", "wheels")
        let rack = try storedRelationship(context, "RackWheel", "rack")
        let label = try storedRelationship(context, "RackWheel", "label")
        let shelf = try storedRelationship(context, "ShelfLabel", "wheel")

        #expect(wheels.originalName == "meules")
        #expect(wheels.name == "wheels")
        #expect(rack.originalName == "rack")
        #expect(label.originalName == "")
        #expect(shelf.originalName == "wheel")
    }

    @Test func guestReprintStoresTheHashOnTheGuestList() throws {
        let context = try MemoryStore.context(for: CoopRoll.self, CoopHand.self)
        let guests = try storedRelationship(context, "CoopRoll", "guests")
        let members = try storedRelationship(context, "CoopRoll", "members")
        let visit = try storedRelationship(context, "CoopHand", "visit")

        #expect(guests.hashModifier == "guest-book-2026")
        #expect(members.hashModifier == nil)
        #expect(visit.hashModifier == nil)
    }

    @Test func movingTheWheelKeepsItsIdentity() throws {
        let context = try MemoryStore.context(for: CaveWheel.self, AgingCave.self)
        let young = AgingCave(caveName: "Cave jeune, Les Rousses", affineurName: "Claire Roux")
        let aged = AgingCave(caveName: "Cave d'affinage, Les Rousses", affineurName: "Claire Roux")
        let wheel = CaveWheel(code: "PL-19")
        context.insert(young)
        context.insert(aged)
        context.insert(wheel)
        young.wheels.append(wheel)
        try context.save()
        let identity = wheel.persistentModelID

        wheel.cave = aged
        try context.save()
        let filed = ModelContext(context.container)
        let caves = try filed.fetch(FetchDescriptor<AgingCave>())
        let youngFiled = caves.first { $0.caveName == "Cave jeune, Les Rousses" }
        let agedFiled = caves.first { $0.caveName == "Cave d'affinage, Les Rousses" }

        let wheels = try filed.fetch(FetchDescriptor<CaveWheel>())

        #expect(young.wheels.isEmpty)
        #expect(aged.wheels.map(\.code) == ["PL-19"])
        #expect(wheel.persistentModelID == identity)
        #expect(wheel.cave?.caveName == "Cave d'affinage, Les Rousses")
        #expect(wheels.count == 1)
        #expect(youngFiled?.wheels.isEmpty == true)
        #expect(agedFiled?.wheels.first?.persistentModelID == identity)
    }

    @Test func morningFolderKeepsEachInverse() throws {
        let context = try MemoryStore.context(for: ComteFolder.types)
        let notedOn = GregorianDay.date(year: 2026, month: 9, day: 2, timeZoneIdentifier: "Europe/Paris")
        let fruitiere = Fruitiere(
            deskName: "Fruitière du Plateau de Plasne",
            cheesemakerName: "Lucien Morel"
        )
        let note = MilkNote(
            farmName: "Ferme Pellier, Plasne",
            farmerName: "Hélène Pellier",
            litres: 86,
            notedOn: notedOn
        )
        let vat = MorningVat(vatName: "Cuve du matin", cheesemakerName: "Lucien Morel")
        let vatWheel = VatWheel(code: "PL-19")
        let cave = AgingCave(caveName: "Cave d'affinage, Les Rousses", affineurName: "Claire Roux")
        let caveWheel = CaveWheel(code: "PL-19")
        let board = SpruceBoard(boardCode: "SP-2", millerName: "Marc Bouvet")
        let boardWheel = BoardWheel(code: "PL-19")
        context.insert(fruitiere)
        context.insert(note)
        context.insert(vat)
        context.insert(vatWheel)
        context.insert(cave)
        context.insert(caveWheel)
        context.insert(board)
        context.insert(boardWheel)
        note.fruitiere = fruitiere
        vatWheel.vat = vat
        cave.wheels.append(caveWheel)
        board.wheel = boardWheel
        try context.save()

        let filed = ModelContext(context.container)
        let notes = try filed.fetch(FetchDescriptor<MilkNote>())
        let wheels = try filed.fetch(FetchDescriptor<VatWheel>())
        let caveWheels = try filed.fetch(FetchDescriptor<CaveWheel>())
        let boards = try filed.fetch(FetchDescriptor<SpruceBoard>())

        #expect(context.container.schema.entities.count == 8)
        #expect(notes.first?.fruitiere?.notes.map(\.farmerName) == ["Hélène Pellier"])
        #expect(wheels.first?.vat?.wheels.map(\.code) == ["PL-19"])
        #expect(caveWheels.first?.cave?.wheels.map(\.code) == ["PL-19"])
        #expect(boards.first?.wheel?.board?.boardCode == "SP-2")
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
