import SwiftData

enum StoredAttribute {
    static func named(_ name: String, on typeName: String, in schema: Schema) -> Schema.Attribute? {
        schema.entities.first { $0.name == typeName }?.attributesByName[name]
    }
}
