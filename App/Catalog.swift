import Foundation

struct CatalogFeature: Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String
    let scenarios: [CatalogScenario]
}

struct CatalogScenario: Identifiable, Hashable {
    let id: String
    let title: String
    let teaches: [String]
}

enum Catalog {
    static let features: [CatalogFeature] = [
        CatalogFeature(
            id: "01-model-basics",
            title: "@Model basics",
            summary: "A class marked @Model, its stored properties, and which types a schema keeps.",
            scenarios: modelBasics
        ),
        CatalogFeature(
            id: "02-attributes",
            title: "Attributes",
            summary: "@Attribute options, external storage, and original names.",
            scenarios: attributes
        ),
        CatalogFeature(
            id: "03-relationships",
            title: "Relationships",
            summary: "Links between models, including to-one and to-many.",
            scenarios: []
        ),
        CatalogFeature(
            id: "04-delete-rules",
            title: "Delete rules",
            summary: "What happens to related records when a model is deleted.",
            scenarios: []
        ),
        CatalogFeature(
            id: "05-transient",
            title: "@Transient",
            summary: "Properties that live on the class and are not columns.",
            scenarios: []
        ),
        CatalogFeature(
            id: "06-codable-and-enums",
            title: "Codable and enums",
            summary: "Stored enums and Codable values.",
            scenarios: []
        ),
        CatalogFeature(
            id: "07-model-container",
            title: "ModelContainer and ModelConfiguration",
            summary: "Where a store lives, in memory or on disk, and how it is opened.",
            scenarios: []
        ),
        CatalogFeature(
            id: "08-model-context",
            title: "ModelContext",
            summary: "Insert, save, autosave, and rollback.",
            scenarios: []
        ),
        CatalogFeature(
            id: "09-query",
            title: "@Query",
            summary: "SwiftUI queries that stay in step with the store.",
            scenarios: []
        ),
        CatalogFeature(
            id: "10-predicate",
            title: "#Predicate",
            summary: "Filters written against model properties.",
            scenarios: []
        ),
        CatalogFeature(
            id: "11-fetch-descriptor",
            title: "FetchDescriptor",
            summary: "Sort, limit, offset, and properties to fetch.",
            scenarios: []
        ),
        CatalogFeature(
            id: "12-index-and-unique",
            title: "#Index and #Unique",
            summary: "Indexes and uniqueness constraints.",
            scenarios: []
        ),
        CatalogFeature(
            id: "13-model-inheritance",
            title: "Model inheritance",
            summary: "Model classes that share a parent.",
            scenarios: []
        ),
        CatalogFeature(
            id: "14-model-actor",
            title: "@ModelActor",
            summary: "Background work on a model actor.",
            scenarios: []
        ),
        CatalogFeature(
            id: "15-undo",
            title: "Undo",
            summary: "Undoing and redoing changes in a context.",
            scenarios: []
        ),
        CatalogFeature(
            id: "16-schema-migrations",
            title: "Schema migrations",
            summary: "VersionedSchema and MigrationPlan.",
            scenarios: []
        ),
        CatalogFeature(
            id: "17-cloudkit-sync",
            title: "CloudKit sync",
            summary: "Syncing a SwiftData store through CloudKit.",
            scenarios: []
        ),
        CatalogFeature(
            id: "18-history-tracking",
            title: "History tracking",
            summary: "Reading the history of changes in a store.",
            scenarios: []
        ),
        CatalogFeature(
            id: "19-swiftui-integration",
            title: "SwiftUI integration and previews",
            summary: "Containers in the SwiftUI environment, and previews.",
            scenarios: []
        ),
        CatalogFeature(
            id: "20-widgets-and-app-intents",
            title: "Widgets and App Intents",
            summary: "The same models from a widget and from an App Intent.",
            scenarios: []
        ),
        CatalogFeature(
            id: "21-core-data-coexistence",
            title: "Core Data coexistence",
            summary: "Opening the same store through Core Data APIs.",
            scenarios: []
        )
    ]

    static func feature(_ id: String?) -> CatalogFeature? {
        features.first { $0.id == id }
    }

    private static let modelBasics: [CatalogScenario] = [
        CatalogScenario(
            id: "01-tbilisi-quince-commission",
            title: "Tbilisi quince commission",
            teaches: [
                "A class marked @Model is the stored record.",
                "Each stored property is a field on that record."
            ]
        ),
        CatalogScenario(
            id: "02-legnica-copper-blank",
            title: "Legnica copper blank",
            teaches: [
                "The initializer is the gate for a new record.",
                "A non-optional stored property has to be supplied."
            ]
        ),
        CatalogScenario(
            id: "03-haarlem-bite-note",
            title: "Haarlem bite note",
            teaches: [
                "An optional stored property can be absent.",
                "Nil is a stored state, not a missing column."
            ]
        ),
        CatalogScenario(
            id: "04-barcelona-bone-black",
            title: "Barcelona bone black",
            teaches: [
                "A default value is the stored starting value.",
                "The caller can override a default without a second type."
            ]
        ),
        CatalogScenario(
            id: "05-fabriano-damp-pack",
            title: "Fabriano damp pack",
            teaches: [
                "String, Int, Double, Bool, and Date store as themselves.",
                "One model can carry that mix without an attribute wrapper."
            ]
        ),
        CatalogScenario(
            id: "06-verona-crate-and-waybill",
            title: "Verona crate and waybill",
            teaches: [
                "One schema can hold two model types.",
                "Those types stay separate records when neither points at the other."
            ]
        ),
        CatalogScenario(
            id: "07-tbilisi-desk-briefing",
            title: "Tbilisi desk briefing",
            teaches: [
                "A method on the model is not a stored property.",
                "The method reads the stored fields and returns a value."
            ]
        ),
        CatalogScenario(
            id: "08-tbilisi-plate-receipt",
            title: "Tbilisi plate receipt",
            teaches: [
                "persistentModelID identifies the record.",
                "Changing a stored property does not change that identity."
            ]
        ),
        CatalogScenario(
            id: "09-barcelona-two-grinds",
            title: "Barcelona two grinds",
            teaches: [
                "Two instances of one class are two records.",
                "Editing one instance leaves the other alone."
            ]
        ),
        CatalogScenario(
            id: "10-fabriano-mill-schema",
            title: "Fabriano mill schema",
            teaches: [
                "@Model makes a class eligible for a store.",
                "The schema lists the types that store actually holds."
            ]
        ),
        CatalogScenario(
            id: "11-vera-district-shelf-card",
            title: "Vera District shelf card",
            teaches: [
                "A model is a class.",
                "Assigning a property edits that record in place."
            ]
        ),
        CatalogScenario(
            id: "12-albertina-bench-slip",
            title: "Albertina bench slip",
            teaches: [
                "insert registers the instance you already hold.",
                "The slip on the bench and the registered model are the same object."
            ]
        ),
        CatalogScenario(
            id: "13-morning-handover-folder",
            title: "Morning handover folder",
            teaches: [
                "A schema can hold several model classes at once.",
                "The screen joins them. The models still do not point at each other."
            ]
        )
    ]

    private static let attributes: [CatalogScenario] = [
        CatalogScenario(
            id: "01-lucanas-ear-mark",
            title: "Lucanas ear mark",
            teaches: [
                "@Attribute(.unique) marks one stored property.",
                "The entity's uniqueness constraints list that property."
            ]
        ),
        CatalogScenario(
            id: "02-arequipa-weigh-photo",
            title: "Arequipa weigh photo",
            teaches: [
                "@Attribute(.externalStorage) marks a Data value to be kept outside the row.",
                "The bytes still come back on the model after a save."
            ]
        ),
        CatalogScenario(
            id: "03-puno-lot-spotlight",
            title: "Puno lot spotlight",
            teaches: [
                "@Attribute(.spotlight) marks a property for Spotlight.",
                "The mark is on the attribute. This in-memory store is not a Spotlight catalog."
            ]
        ),
        CatalogScenario(
            id: "04-sucre-dye-note",
            title: "Sucre dye note",
            teaches: [
                "@Attribute(.allowsCloudEncryption) marks a property that a synced store may encrypt.",
                "The mark is on the attribute. This store does not sync."
            ]
        ),
        CatalogScenario(
            id: "05-lucanas-agreed-price",
            title: "Lucanas agreed price",
            teaches: [
                "@Attribute(.preserveValueOnDeletion) marks a value to be kept if the row is deleted.",
                "The mark is on the attribute."
            ]
        ),
        CatalogScenario(
            id: "06-arequipa-renamed-kilos",
            title: "Arequipa renamed kilos",
            teaches: [
                "originalName records the column's previous name.",
                "A property with no original name stores an empty original name."
            ]
        ),
        CatalogScenario(
            id: "07-arequipa-ledger-reprint",
            title: "Arequipa ledger reprint",
            teaches: [
                "hashModifier is stored on the attribute.",
                "A property with no hash modifier leaves that field nil."
            ]
        ),
        CatalogScenario(
            id: "08-la-paz-spoken-markup",
            title: "La Paz spoken markup",
            teaches: [
                "@Attribute(.ephemeral) is omitted from the filed row.",
                "The attribute is not reported as transient."
            ]
        ),
        CatalogScenario(
            id: "09-tarabuco-micron-reading",
            title: "Tarabuco micron reading",
            teaches: [
                "@Attribute(.transformable) names a ValueTransformer for a custom class.",
                "transformedValueClass() returns that class, and the reading survives a save."
            ]
        ),
        CatalogScenario(
            id: "10-puno-bale-code",
            title: "Puno bale code",
            teaches: [
                "One property can carry more than one attribute option.",
                "PU-77 is unique and marked for Spotlight."
            ]
        ),
        CatalogScenario(
            id: "11-puno-seal-and-photo",
            title: "Puno seal and photo",
            teaches: [
                "Two Data properties on one model can be stored differently.",
                "The wax seal stays inline. The scale photo is external."
            ]
        ),
        CatalogScenario(
            id: "12-lucanas-second-card",
            title: "Lucanas second card",
            teaches: [
                "Saving a second model with the same unique value keeps one row.",
                "That row keeps the first identity and takes the new values."
            ]
        ),
        CatalogScenario(
            id: "13-la-paz-morning-folder",
            title: "La Paz morning folder",
            teaches: [
                "One schema can hold several models, each with its own attribute marks.",
                "The folder is the screen. The marks stay on the attributes."
            ]
        )
    ]
}
