import Foundation
import SwiftData
import Testing
@testable import SwiftDataMultivitamin

@MainActor
struct CodableAndEnumTests {
    @Test func harvestKeepsTheChosenAgave() throws {
        let context = try MemoryStore.context(for: AgaveHarvest.self)
        let harvest = AgaveHarvest(lotCode: "SC-26", growerName: "Inés Santiago")
        context.insert(harvest)
        try context.save()
        #expect(try context.freshFirst(AgaveHarvest.self)?.agave == .espadin)

        let identity = harvest.persistentModelID
        harvest.agave = .cuishe
        try context.save()
        let filed = try #require(try context.freshFirst(AgaveHarvest.self))
        #expect(filed.agave == .cuishe)
        #expect(filed.persistentModelID == identity)
        #expect(HarvestAgave.allCases.count == 3)
    }

    @Test func roastReplacementKeepsTheKilos() throws {
        let context = try MemoryStore.context(for: RoastCard.self)
        let roast = RoastCard(lotCode: "SC-26", measure: RoastMeasure(kilos: 840, coveredHours: 72))
        context.insert(roast)
        try context.save()
        let earlier = roast.measure
        roast.extendRoast(by: 6)
        try context.save()
        let filed = try #require(try context.freshFirst(RoastCard.self))

        #expect(earlier.coveredHours == 72)
        #expect(filed.measure == RoastMeasure(kilos: 840, coveredHours: 78))
        let entity = try #require(context.container.schema.entities.first { $0.name == "RoastCard" })
        #expect(entity.relationshipsByName.isEmpty)
    }

    @Test func maestraSignatureKeepsItsNestedAddress() throws {
        let context = try MemoryStore.context(for: MaestraCard.self)
        let signature = MaestraSignature(
            fullName: "Lucía Hernández", palenqueName: "Palenque del Guayabo",
            address: PalenqueAddress(village: "Santa Catarina Minas", district: "Ocotlán")
        )
        context.insert(MaestraCard(lotCode: "SC-26", signature: signature))
        try context.save()
        let filed = try #require(try context.freshFirst(MaestraCard.self))

        #expect(filed.signature == signature)
        #expect(filed.signature.address.district == "Ocotlán")
        #expect(context.container.schema.entities.count == 1)
    }

    @Test func tinaSeparatesNoSampleFromZeroBrix() throws {
        let context = try MemoryStore.context(for: FermentCard.self)
        let tina = FermentCard(tinaName: "Guayabo · SC-26")
        context.insert(tina)
        try context.save()
        let unsampled = try #require(try context.freshFirst(FermentCard.self))
        #expect(unsampled.reading == nil)

        tina.reading = FermentReading(brix: 0, celsius: 29)
        try context.save()
        let sampled = try #require(try context.freshFirst(FermentCard.self))
        #expect(sampled.reading == FermentReading(brix: 0, celsius: 29))

        tina.reading = nil
        try context.save()
        let withdrawn = try #require(try context.freshFirst(FermentCard.self))
        #expect(withdrawn.reading == nil)
    }

    @Test func clayPassesFollowTheLotPredicate() throws {
        let context = try MemoryStore.context(for: ClayRun.self)
        context.insert(ClayRun(lotCode: "SC-26", runNumber: 2, pass: .second))
        context.insert(ClayRun(lotCode: "SC-25", runNumber: 1, pass: .second))
        context.insert(ClayRun(lotCode: "SC-26", runNumber: 1, pass: .first))
        try context.save()
        let descriptor = FetchDescriptor<ClayRun>(
            predicate: #Predicate { $0.lotCode == "SC-26" },
            sortBy: [SortDescriptor(\ClayRun.runNumber)]
        )
        let filed = try context.freshFetch(descriptor)

        #expect(filed.map(\.pass) == [.first, .second])
        #expect(filed.filter { $0.pass == .second }.count == 1)
        #expect(filed.last?.pass.rawValue == 2)
    }

    @Test func heartCutRecoversEveryAssociatedPayloadAndRejectsDamage() throws {
        let context = try MemoryStore.context(for: HeartCut.self)
        let cut = try HeartCut(lotCode: "SC-26", verdict: .waiting)
        context.insert(cut)
        let decisions: [CutVerdict] = [.waiting, .hearts(abv: 47, litres: 96), .held(reason: "Recheck the tails")]
        for decision in decisions {
            try cut.record(decision)
            try context.save()
            let filed = try #require(try context.freshFirst(HeartCut.self))
            #expect(try filed.readVerdict() == decision)
        }
        cut.verdictJSON = Data("Torn cut slip".utf8)
        try context.save()
        let damaged = try #require(try context.freshFirst(HeartCut.self))
        #expect(throws: DecodingError.self) { try damaged.readVerdict() }
    }

    @Test func restingChecksKeepOrderAcrossAnAppend() throws {
        let context = try MemoryStore.context(for: RestingJar.self)
        let first = RestingCheck(day: 12, sealIntact: true, note: "Fresh clay")
        let second = RestingCheck(day: 19, sealIntact: true, note: "Clay aroma softened")
        let jar = RestingJar(jarCode: "SC-26-A", checks: [first])
        context.insert(jar)
        try context.save()
        jar.append(second)
        try context.save()
        let filed = try #require(try context.freshFirst(RestingJar.self))

        #expect(filed.checks == [first, second])
        #expect(filed.intactDays == 2)
        #expect(context.container.schema.entities.count == 1)
    }

    @Test func aromaArrayKeepsOrderAndRemovesASelection() throws {
        let context = try MemoryStore.context(for: AromaFlight.self)
        let flight = AromaFlight(roomName: "Sala del Tule", aromas: [.roastedAgave, .wetClay])
        context.insert(flight)
        try context.save()
        #expect(try context.freshFirst(AromaFlight.self)?.aromas == [.roastedAgave, .wetClay])

        flight.toggle(.wetClay)
        flight.toggle(.citrusPeel)
        try context.save()
        let filed = try #require(try context.freshFirst(AromaFlight.self))
        #expect(filed.aromas == [.roastedAgave, .citrusPeel])
    }

    @Test func labelKeysTranslateAtTheJSONBoundary() throws {
        let context = try MemoryStore.context(for: LabelProof.self)
        let document = Data(#"{"lote":"SC-26","alc_vol":47,"contenido_ml":700}"#.utf8)
        let proof = try LabelProof.importProof(document, printerName: "Imprenta del Nopal")
        context.insert(proof)
        try context.save()
        let filed = try #require(try context.freshFirst(LabelProof.self))
        #expect(filed.label == BottleLabel(lotCode: "SC-26", alcoholPercent: 47, bottleMillilitres: 700))

        let exported = try filed.exportDocument()
        let keys = try #require(try JSONSerialization.jsonObject(with: exported) as? [String: Any])
        #expect(Set(keys.keys) == Set(["lote", "alc_vol", "contenido_ml"]))
        let reimported = try LabelProof.importProof(exported, printerName: filed.printerName)
        #expect(reimported.label == filed.label)

        proof.label = BottleLabel(lotCode: "SC-26 revised", alcoholPercent: 48, bottleMillilitres: 750)
        try context.save()
        let revised = try #require(try context.freshFirst(LabelProof.self))
        #expect(revised.label == proof.label)
        let revisedImport = try LabelProof.importProof(revised.exportDocument(), printerName: revised.printerName)
        #expect(revisedImport.label == proof.label)
        #expect(throws: DecodingError.self) {
            try LabelProof.importProof(Data(#"{"lote":"SC-26"}"#.utf8), printerName: "Imprenta del Nopal")
        }
    }

    @Test func allocationQueuePreservesUnknownCodes() throws {
        let context = try MemoryStore.context(for: DistributorAllocation.self)
        let paris = DistributorAllocation(distributorName: "Cave des Terres, Paris", stageCode: "quai", cases: 4)
        context.insert(paris)
        for number in 1...6 {
            context.insert(DistributorAllocation(distributorName: "Distribuidora del Sur · reparto \(number)", stageCode: "packed", cases: number))
        }
        context.insert(DistributorAllocation(distributorName: "Mesa del Agave, Madrid", stageCode: "reserved", cases: 6))
        try context.save()
        let queue = try context.freshFetch(DistributorAllocation.packedQueue())
        #expect(queue.count == 5)
        #expect(queue.allSatisfy { $0.stage == .packed })
        #expect(queue.map(\.cases) == [1, 2, 3, 4, 5])

        let filed = try #require(try context.freshFetch(FetchDescriptor<DistributorAllocation>()).first { $0.distributorName == "Cave des Terres, Paris" })
        #expect(filed.stage == nil)
        #expect(filed.stageCode == "quai")
        paris.stage = .dispatched
        try context.save()
        let updated = try #require(try context.freshFetch(FetchDescriptor<DistributorAllocation>()).first { $0.distributorName == "Cave des Terres, Paris" })
        #expect(updated.stage == .dispatched)
    }

    @Test func flightCopiesKeepIndependentNestedPours() throws {
        let context = try MemoryStore.context(for: FlightRecipe.self)
        let recipe = PourRecipe(pours: [FlightPour(lotCode: "SC-26", millilitres: 15), FlightPour(lotCode: "SC-25 reserve", millilitres: 10)])
        let oaxaca = FlightRecipe(serviceName: "Sala del Tule, Oaxaca", recipe: recipe)
        let madrid = FlightRecipe(serviceName: "Mesa del Agave, Madrid", recipe: oaxaca.recipe)
        context.insert(oaxaca)
        context.insert(madrid)
        try context.save()
        madrid.resizeFirstPour(to: 20)
        try context.save()
        let filed = try context.freshFetch(FetchDescriptor<FlightRecipe>())
        let oaxacaReading = try #require(filed.first { $0.serviceName == oaxaca.serviceName })
        let madridReading = try #require(filed.first { $0.serviceName == madrid.serviceName })

        #expect(oaxacaReading.recipe == recipe)
        #expect(oaxacaReading.recipe.total(\.millilitres) == 25)
        #expect(madridReading.recipe.total(\.millilitres) == 30)
        #expect(madridReading.recipe.pours.last == recipe.pours.last)
    }

    @Test func customsActorReturnsTheDatedValue() async throws {
        let context = try MemoryStore.context(for: CustomsEnvelope.self)
        let sealedOn = GregorianDay.date(year: 2026, month: 3, day: 24, timeZoneIdentifier: "America/Mexico_City")
        let declaration = CustomsDeclaration(lotCode: "SC-26", destination: "Cave des Terres, Paris", sealedOn: sealedOn, certificate: "MX-SC-26")
        let envelope = try CustomsEnvelope(declaration: declaration)
        context.insert(envelope)
        try context.save()
        let reader = CustomsReader(modelContainer: context.container)
        let recovered = try await reader.declaration(for: envelope.persistentModelID)
        #expect(recovered == declaration)

        let filed = try #require(try context.freshFirst(CustomsEnvelope.self))
        let wire = try #require(try JSONSerialization.jsonObject(with: filed.declarationJSON) as? [String: Any])
        #expect(wire["sealedOn"] as? String == "2026-03-24T18:00:00Z")
        var uncertified = declaration
        uncertified.certificate = nil
        #expect(try CustomsDeclaration.decode(uncertified.encoded()).certificate == nil)
    }

    @Test func madridFolderStoresAnIndependentManifest() throws {
        let context = try MemoryStore.context(for: MezcalFolder.types)
        let manifest = try MezcalFolder.file(in: context)
        #expect(manifest.lotCode == "SC-26")
        #expect(manifest.agaveName == "Espadín")
        #expect(manifest.sealNotes == ["Clay aroma softened"])
        #expect(manifest.destination == "Mesa del Agave, Madrid")
        #expect(manifest.stageName == "dispatched")
        #expect(manifest.cases == 6)
        #expect(context.container.schema.entities.count == 4)
        #expect(context.container.schema.entities.allSatisfy { $0.relationshipsByName.isEmpty })

        let harvest = try #require(try context.fetch(FetchDescriptor<AgaveHarvest>()).first)
        harvest.agave = .tobala
        try context.save()
        let filed = try #require(try context.freshFirst(MezcalHandover.self))
        #expect(filed.manifest == manifest)
        #expect(try JSONDecoder().decode(MezcalManifest.self, from: JSONEncoder().encode(manifest)) == manifest)
    }
}
