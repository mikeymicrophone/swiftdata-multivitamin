import Foundation
import SwiftData
import Testing
@testable import SwiftDataMultivitamin

@MainActor
struct AttributeTests {
    @Test func earMarkIsTheUniqueConstraint() throws {
        let attribute = try storedAttribute(ShearingLicense.self, "earMark")
        let container = try MemoryStore.make(ShearingLicense.self)
        let constraints = container.schema.entities.first { $0.name == "ShearingLicense" }?.uniquenessConstraints

        #expect(attribute.isUnique)
        #expect(attribute.options.contains(.unique))
        #expect(constraints == [["earMark"]])
    }

    @Test func weighPhotoRoundTripsOutsideTheRow() throws {
        let context = try MemoryStore.context(for: WeighTicket.self)
        let ticket = WeighTicket(
            lotCode: "AQ-10",
            millerName: "Raúl Mamani",
            kilos: 1.25,
            weighPhoto: ScaleFace.bytes,
            weighedOn: GregorianDay.date(year: 2026, month: 6, day: 10, timeZoneIdentifier: "America/Lima")
        )
        context.insert(ticket)
        try context.save()

        let filed = ModelContext(context.container)
        let fetched = try filed.fetch(FetchDescriptor<WeighTicket>())
        let attribute = try storedAttribute(WeighTicket.self, "weighPhoto")

        #expect(attribute.options.contains(.externalStorage))
        #expect(fetched.count == 1)
        #expect(fetched.first?.weighPhoto == ScaleFace.bytes)
        #expect(fetched.first?.kilos == 1.25)
    }

    @Test func lotNameIsMarkedForSpotlight() throws {
        let attribute = try storedAttribute(RoadLot.self, "lotName")
        #expect(attribute.options.contains(.spotlight))
    }

    @Test func recipeIsMarkedForCloudEncryption() throws {
        let attribute = try storedAttribute(DyeFormula.self, "recipe")
        #expect(attribute.options.contains(.allowsCloudEncryption))
    }

    @Test func agreedSolesAreMarkedToBePreserved() throws {
        let attribute = try storedAttribute(AgreedPrice.self, "agreedSoles")
        #expect(attribute.options.contains(.preserveValueOnDeletion))
    }

    @Test func renamedKilosKeepTheOldColumnName() throws {
        let scoured = try storedAttribute(ScouredWeight.self, "scouredKilos")
        let lot = try storedAttribute(ScouredWeight.self, "lotCode")

        #expect(scoured.originalName == "fleeceKilos")
        #expect(scoured.name == "scouredKilos")
        #expect(lot.originalName == "")
    }

    @Test func seasonReprintStoresTheHashModifier() throws {
        let season = try storedAttribute(SeasonReprint.self, "seasonName")
        let desk = try storedAttribute(SeasonReprint.self, "deskNote")

        #expect(season.hashModifier == "mill-ledger-2026")
        #expect(desk.hashModifier == nil)
    }

    @Test func spokenMarkupIsEphemeralAndUnfiled() throws {
        let attribute = try storedAttribute(ShawlCounter.self, "spokenMarkup")
        let context = try MemoryStore.context(for: ShawlCounter.self)
        let card = ShawlCounter(
            shopName: "Casa Rojas, Calle Linares",
            sellerName: "Mariela Rojas",
            askingBolivianos: 920,
            spokenMarkup: "Add forty bolivianos",
            openedOn: GregorianDay.date(year: 2026, month: 6, day: 18, timeZoneIdentifier: "America/La_Paz")
        )
        context.insert(card)
        try context.save()

        let filed = ModelContext(context.container)
        let fetched = try filed.fetch(FetchDescriptor<ShawlCounter>())

        #expect(attribute.options.contains(.ephemeral))
        #expect(!attribute.isTransient)
        #expect(fetched.first?.askingBolivianos == 920)
        #expect(fetched.first?.spokenMarkup == "")
    }

    @Test func micronReadingSurvivesTheTransformer() throws {
        MicronReadingTransformer.register()
        let attribute = try storedAttribute(FiberSample.self, "reading")
        let context = try MemoryStore.context(for: FiberSample.self)
        let sample = FiberSample(
            sampleCode: "TB-16",
            weaverName: "Edwin Cruz",
            workshopName: "Tarabuco",
            reading: MicronReading(meanMicrons: 12.5),
            sampledOn: GregorianDay.date(year: 2026, month: 6, day: 16, timeZoneIdentifier: "America/La_Paz")
        )
        context.insert(sample)
        try context.save()

        let filed = ModelContext(context.container)
        let fetched = try filed.fetch(FetchDescriptor<FiberSample>())

        #expect(attribute.isTransformable)
        #expect(attribute.options.contains { $0.debugDescription.contains("MicronReadingTransformer") })
        #expect(fetched.first?.reading.meanMicrons == 12.5)
    }

    @Test func baleCodeIsUniqueAndMarkedForSpotlight() throws {
        let attribute = try storedAttribute(BalePlate.self, "baleCode")
        let container = try MemoryStore.make(BalePlate.self)
        let constraints = container.schema.entities.first { $0.name == "BalePlate" }?.uniquenessConstraints

        #expect(attribute.isUnique)
        #expect(attribute.options.contains(.unique))
        #expect(attribute.options.contains(.spotlight))
        #expect(constraints == [["baleCode"]])
    }

    @Test func waxSealStaysInlineAndScalePhotoIsExternal() throws {
        let seal = try storedAttribute(BalePack.self, "waxSeal")
        let photo = try storedAttribute(BalePack.self, "scalePhoto")

        #expect(seal.options.isEmpty)
        #expect(photo.options.contains(.externalStorage))
        #expect(!seal.options.contains(.externalStorage))
    }

    @Test func secondLicenseKeepsTheFirstIdentity() throws {
        let context = try MemoryStore.context(for: ShearingLicense.self)
        let shornOn = GregorianDay.date(year: 2026, month: 6, day: 8, timeZoneIdentifier: "America/Lima")
        let first = ShearingLicense(
            earMark: "LQ-184",
            communityName: "Comunidad campesina de Lucanas",
            clerkName: "Florentina Quispe",
            conditionNote: "Clear coat, no cut",
            shornOn: shornOn
        )
        context.insert(first)
        try context.save()
        let identity = first.persistentModelID

        let second = ShearingLicense(
            earMark: "LQ-184",
            communityName: "Comunidad campesina de Lucanas",
            clerkName: "Florentina Quispe",
            conditionNote: "Cut on the left shoulder",
            shornOn: shornOn
        )
        context.insert(second)
        try context.save()

        let rows = try context.fetch(FetchDescriptor<ShearingLicense>())
        #expect(rows.count == 1)
        #expect(rows.first?.persistentModelID == identity)
        #expect(first.conditionNote == "Cut on the left shoulder")
        #expect(first.persistentModelID == identity)
    }

    @Test func morningFolderKeepsEachAttributeMark() throws {
        let context = try MemoryStore.context(for: ShawlFolder.types)
        let schema = context.container.schema

        #expect(StoredAttribute.named("earMark", on: "ShearingLicense", in: schema)?.options.contains(.unique) == true)
        #expect(StoredAttribute.named("scouredKilos", on: "ScouredWeight", in: schema)?.originalName == "fleeceKilos")
        #expect(StoredAttribute.named("recipe", on: "DyeFormula", in: schema)?.options.contains(.allowsCloudEncryption) == true)
        #expect(StoredAttribute.named("spokenMarkup", on: "ShawlCounter", in: schema)?.options.contains(.ephemeral) == true)
        #expect(schema.entities.map(\.name).count == 4)
    }

    private func storedAttribute(_ type: any PersistentModel.Type, _ name: String) throws -> Schema.Attribute {
        let container = try MemoryStore.make([type])
        let entity = try #require(container.schema.entities.first { $0.name == String(describing: type) })
        return try #require(entity.attributesByName[name])
    }
}
