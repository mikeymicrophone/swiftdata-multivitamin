import Foundation
import SwiftData

@MainActor
enum MemoryStore {
    static func make(_ types: any PersistentModel.Type...) throws -> ModelContainer {
        try make(types)
    }

    static func make(_ types: [any PersistentModel.Type]) throws -> ModelContainer {
        let schema = Schema(types)
        let configuration = ModelConfiguration(
            "memory-\(UUID().uuidString)",
            schema: schema,
            isStoredInMemoryOnly: true,
            allowsSave: true,
            groupContainer: .none,
            cloudKitDatabase: .none
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    static func context(for types: any PersistentModel.Type...) throws -> ModelContext {
        try context(for: types)
    }

    static func context(for types: [any PersistentModel.Type]) throws -> ModelContext {
        let container = try make(types)
        let context = ModelContext(container)
        context.autosaveEnabled = false
        return context
    }

    static func containerOrCrash(_ types: any PersistentModel.Type...) -> ModelContainer {
        do {
            return try make(types)
        } catch {
            fatalError("In-memory store failed: \(error)")
        }
    }
}
