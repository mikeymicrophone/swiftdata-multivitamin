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
            summary: "To-one and to-many links, inverses, and the counts and names stored on a relationship.",
            scenarios: relationships
        ),
        CatalogFeature(
            id: "04-delete-rules",
            title: "Delete rules",
            summary: "What happens to related records when a model is deleted.",
            scenarios: deleteRules
        ),
        CatalogFeature(
            id: "05-transient",
            title: "@Transient",
            summary: "Properties that live on the class and are not columns.",
            scenarios: transient
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

    private static let relationships: [CatalogScenario] = [
        CatalogScenario(
            id: "01-plasne-milk-note",
            title: "Plasne milk note",
            teaches: [
                "An optional to-one can be absent.",
                "Naming the fruitière puts this note on its roll."
            ]
        ),
        CatalogScenario(
            id: "02-plateau-roll",
            title: "Plateau roll",
            teaches: [
                "The fruitière's roll is a to-many.",
                "maximumModelCount stays 0, and the roll still holds both notes."
            ]
        ),
        CatalogScenario(
            id: "03-plasne-member-book",
            title: "Plasne member book",
            teaches: [
                "Two relationships to one type need an explicit inverse each.",
                "A member link and a guest link do not cross."
            ]
        ),
        CatalogScenario(
            id: "04-plasne-morning-vat",
            title: "Plasne morning vat",
            teaches: [
                "Setting the wheel's vat fills the vat's wheel list.",
                "The list is the inverse. Nobody appends to it."
            ]
        ),
        CatalogScenario(
            id: "05-rousses-young-cave",
            title: "Rousses young cave",
            teaches: [
                "Appending the wheel sets its cave.",
                "Taking a wheel off the rack clears that link and leaves the wheel in the store."
            ]
        ),
        CatalogScenario(
            id: "06-champagnole-spruce-board",
            title: "Champagnole spruce board",
            teaches: [
                "@Relationship(.unique) keeps the wheel on one board.",
                "A second board takes the wheel. The first board stays, with no wheel."
            ]
        ),
        CatalogScenario(
            id: "07-besancon-supper-card",
            title: "Besançon supper card",
            teaches: [
                "minimumModelCount records that the card should name a buyer.",
                "The buyer has no inverse, and a save with no buyer still files the card."
            ]
        ),
        CatalogScenario(
            id: "08-poligny-jury",
            title: "Poligny jury",
            teaches: [
                "A taster and a wheel are a many-to-many.",
                "Linking from either side fills the other side."
            ]
        ),
        CatalogScenario(
            id: "09-poligny-tasting-slip",
            title: "Poligny tasting slip",
            teaches: [
                "The slip is one model with two to-one links.",
                "Each inverse list contains that slip."
            ]
        ),
        CatalogScenario(
            id: "10-rousses-renamed-rack",
            title: "Rousses renamed rack",
            teaches: [
                "originalName on the relationship keeps the previous name.",
                "The inverse stores its own name. A relationship that omits originalName stores an empty one."
            ]
        ),
        CatalogScenario(
            id: "11-plasne-guest-reprint",
            title: "Plasne guest reprint",
            teaches: [
                "hashModifier is stored on the relationship that sets it.",
                "The member list and the inverse visit leave it nil."
            ]
        ),
        CatalogScenario(
            id: "12-rousses-aged-cave",
            title: "Rousses aged cave",
            teaches: [
                "Pointing the wheel at the aged cave takes it off the young rack.",
                "The wheel keeps its identity."
            ]
        ),
        CatalogScenario(
            id: "13-besancon-morning-folder",
            title: "Besançon morning folder",
            teaches: [
                "One schema holds the pairs from the route.",
                "After a save, each inverse still names the other side."
            ]
        )
    ]

    private static let deleteRules: [CatalogScenario] = [
        CatalogScenario(
            id: "01-qamsar-terrace-book",
            title: "Qamsar terrace book",
            teaches: [
                "A relationship with no delete rule stores nullify.",
                "Tearing up the book leaves the harvest ticket, with an empty book line."
            ]
        ),
        CatalogScenario(
            id: "02-qamsar-filled-jar",
            title: "Qamsar filled jar",
            teaches: [
                ".nullify clears the link and keeps the jar.",
                "The jar's litres are still on the card after a new context reads it."
            ]
        ),
        CatalogScenario(
            id: "03-qamsar-cook-slips",
            title: "Qamsar cook slips",
            teaches: [
                ".cascade on the cook deletes the slips with the cook.",
                "A new context finds neither the cook nor the slips."
            ]
        ),
        CatalogScenario(
            id: "04-qamsar-torn-slip",
            title: "Qamsar torn slip",
            teaches: [
                "The cook's rule is cascade. The slip's rule back is nullify.",
                "Tearing up the slip runs the slip's rule, and the cook stays."
            ]
        ),
        CatalogScenario(
            id: "05-kashan-seal-chit",
            title: "Kashan seal chit",
            teaches: [
                "The cascade sits on the chit, which is the model that is voided.",
                "Voiding the chit deletes the cook it warrants."
            ]
        ),
        CatalogScenario(
            id: "06-qamsar-copper-still",
            title: "Qamsar copper still",
            teaches: [
                ".deny is stored on the still's cook list.",
                "The save still removes the still. The charged cook remains, with an empty still line."
            ]
        ),
        CatalogScenario(
            id: "07-qamsar-wall-tally",
            title: "Qamsar wall tally",
            teaches: [
                ".noAction is stored on the tally's mark list.",
                "Wiping the tally leaves the mark, and the mark's tally line is empty."
            ]
        ),
        CatalogScenario(
            id: "08-qamsar-cook-and-still",
            title: "Qamsar cook and still",
            teaches: [
                "One delete runs cascade on the slips and nullify on the still.",
                "The slips are gone. The still remains, with an empty cook line."
            ]
        ),
        CatalogScenario(
            id: "09-qamsar-correction-line",
            title: "Qamsar correction line",
            teaches: [
                "The cook cascades to its slips, and each slip cascades to its correction.",
                "Voiding the cook removes the slips and the corrections."
            ]
        ),
        CatalogScenario(
            id: "10-yazd-wedding-tray",
            title: "Yazd wedding tray",
            teaches: [
                "The tray cascades to its place cards.",
                "Each card's link to the lot is nullify, so the lot and its litres stay."
            ]
        ),
        CatalogScenario(
            id: "11-yazd-sister-jar",
            title: "Yazd sister jar",
            teaches: [
                ".nullify on the jar clears that jar's line on the lot.",
                "The lot and the sister jar stay, and the sister jar still names QS-22."
            ]
        ),
        CatalogScenario(
            id: "12-qamsar-blank-card",
            title: "Qamsar blank card",
            teaches: [
                ".cascade is stored even when the cook has no slips.",
                "Voiding that card removes the cook, and the save stands."
            ]
        ),
        CatalogScenario(
            id: "13-yazd-morning-folder",
            title: "Yazd morning folder",
            teaches: [
                "One save deletes four source cards, each under its own rule.",
                "A new context shows the slips gone, the jar kept, the charged cook kept, and the chalk mark kept."
            ]
        )
    ]

    private static let transient: [CatalogScenario] = [
        CatalogScenario(
            id: "01-sepetci-lump",
            title: "Sepetçi lump card",
            teaches: [
                "The seam note is absent from the schema.",
                "The lump code is a column."
            ]
        ),
        CatalogScenario(
            id: "02-odunpazari-bowl",
            title: "Odunpazarı bowl",
            teaches: [
                "After save, this card still holds the opening count.",
                "A new context reads 0, and the bowl name is filed."
            ]
        ),
        CatalogScenario(
            id: "03-wax-whisper",
            title: "Wax whisper",
            teaches: [
                "An optional transient needs no default value.",
                "A new context reads nil. The wax lot is filed."
            ]
        ),
        CatalogScenario(
            id: "04-stem-nick",
            title: "Stem nick",
            teaches: [
                "A non-optional transient needs a default.",
                "A new context reads that default, not the nick Halime set."
            ]
        ),
        CatalogScenario(
            id: "05-lattice-scratch",
            title: "Lattice scratch",
            teaches: [
                "A transient property can hold a struct that is not a column.",
                "A new context reads the default scratch. The bowl name is filed."
            ]
        ),
        CatalogScenario(
            id: "06-hide-case",
            title: "Hide case",
            teaches: [
                "Two transient properties are both omitted from the schema.",
                "A new context resets both. The leather grade is filed."
            ]
        ),
        CatalogScenario(
            id: "07-bedesten-aside",
            title: "Bedesten aside",
            teaches: [
                "Writing the aside leaves the context unchanged.",
                "The filed price stays 4000 lira."
            ]
        ),
        CatalogScenario(
            id: "08-bedesten-price",
            title: "Bedesten price",
            teaches: [
                "A stored edit is filed. The aside is not.",
                "This card keeps the aside after the save."
            ]
        ),
        CatalogScenario(
            id: "09-counter-reading",
            title: "Counter reading",
            teaches: [
                "A fetch in this context returns the same card, aside included.",
                "A new context is a different card and reads the default aside."
            ]
        ),
        CatalogScenario(
            id: "10-twin-lumps",
            title: "Twin lumps",
            teaches: [
                "Each open card keeps its own seam note.",
                "A new context defaults both notes. Both lump codes are filed."
            ]
        ),
        CatalogScenario(
            id: "11-two-benches",
            title: "Two benches",
            teaches: [
                "Each model's transient property is omitted from that model.",
                "The wax lot and the stem wood are filed."
            ]
        ),
        CatalogScenario(
            id: "12-trial-hour",
            title: "Trial hour",
            teaches: [
                "A transient date uses its default on a new context.",
                "The stem wood is filed."
            ]
        ),
        CatalogScenario(
            id: "13-bedesten-morning",
            title: "Bedesten morning folder",
            teaches: [
                "One schema holds the four cards, and each aside is omitted.",
                "A new context files the four desk facts and reads each default aside."
            ]
        )
    ]
}
