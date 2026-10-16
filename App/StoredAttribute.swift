import SwiftData

enum StoredAttribute {
    static func named(_ name: String, on typeName: String, in schema: Schema) -> Schema.Attribute? {
        schema.entities.first { $0.name == typeName }?.attributesByName[name]
    }

    static func propertyNames(on typeName: String, in schema: Schema) -> [String] {
        (schema.entities.first { $0.name == typeName }?.properties.map(\.name) ?? []).sorted()
    }
}
