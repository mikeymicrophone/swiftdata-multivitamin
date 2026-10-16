import Foundation
import SwiftData
import SwiftUI

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
        containerOrCrash(types)
    }

    static func containerOrCrash(_ types: [any PersistentModel.Type]) -> ModelContainer {
        do {
            return try make(types)
        } catch {
            fatalError("In-memory store failed: \(error)")
        }
    }
}

/// Gives a scenario screen its own in-memory container. Autosave is off on the
/// main context, so every save in a scenario is one the reader can see.
@MainActor
private struct InMemoryStore: ViewModifier {
    @State private var container: ModelContainer

    init(types: [any PersistentModel.Type]) {
        let container = MemoryStore.containerOrCrash(types)
        container.mainContext.autosaveEnabled = false
        _container = State(initialValue: container)
    }

    func body(content: Content) -> some View {
        content.modelContainer(container)
    }
}

extension View {
    @MainActor
    func inMemoryStore(for types: any PersistentModel.Type...) -> some View {
        modifier(InMemoryStore(types: types))
    }

    @MainActor
    func inMemoryStore(for types: [any PersistentModel.Type]) -> some View {
        modifier(InMemoryStore(types: types))
    }
}

extension ModelContext {
    /// Fetches through a new context on the same container. That context sees
    /// only saved rows, and none of this context's live objects or transient values.
    func freshFetch<Model: PersistentModel>(_ descriptor: FetchDescriptor<Model> = FetchDescriptor<Model>()) throws -> [Model] {
        try ModelContext(container).fetch(descriptor)
    }

    func freshFirst<Model: PersistentModel>(_ type: Model.Type) throws -> Model? {
        try freshFetch(FetchDescriptor<Model>()).first
    }

    func freshCount<Model: PersistentModel>(_ type: Model.Type) throws -> Int {
        try ModelContext(container).fetchCount(FetchDescriptor<Model>())
    }
}
