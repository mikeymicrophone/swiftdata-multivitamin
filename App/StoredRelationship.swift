import SwiftData

enum StoredRelationship {
    static func named(_ name: String, on typeName: String, in schema: Schema) -> Schema.Relationship? {
        schema.entities.first { $0.name == typeName }?.relationshipsByName[name]
    }
}
