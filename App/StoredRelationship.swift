import SwiftData

enum StoredRelationship {
    static func named(_ name: String, on typeName: String, in schema: Schema) -> Schema.Relationship? {
        schema.entities.first { $0.name == typeName }?.relationshipsByName[name]
    }

    static func ruleTitle(_ rule: Schema.Relationship.DeleteRule) -> String {
        switch rule {
        case .nullify: "Nullify"
        case .cascade: "Cascade"
        case .deny: "Deny"
        case .noAction: "No action"
        @unknown default: "Unknown"
        }
    }
}
