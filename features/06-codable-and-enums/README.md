# Codable and enum properties

Stored enums and Codable values.

Official references: [Preserving your app’s model data across launches](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches) and [Defining data relationships with enumerations and model classes](https://developer.apple.com/documentation/swiftdata/defining-data-relationships-with-enumerations-and-model-classes).

The thirteen screens follow mezcal lot SC-26 from agave fields near Miahuatlán through a palenque in Santa Catarina Minas, a tasting room and printer in Oaxaca de Juárez, and distributors in Mexico City, Paris, and Madrid. Each screen opens its own in-memory store. Business and producer names form the catalog’s fictional chain in these real places.

On 2 March 2026 Inés Santiago cuts espadín for Palenque del Guayabo. On 3 March maestra mezcalera Lucía Hernández roasts 840 kilos there, extending the covered roast from 72 to 78 hours. On 6 March she signs the fermentation book. On 9 March Mateo Cruz reads the dry tina at zero Brix and 29 °C. On 10 March Lucía runs the clay pots twice; on 11 March she cuts 96 litres of hearts at 47% ABV. Mateo inspects resting jar SC-26-A on 12 and 19 March. On 20 March Elena Ruiz pours the lot at Sala del Tule in Oaxaca; on 21 March Imprenta del Nopal proofs the 700 ml label. On 22 March Distribuidora del Sur packs eight cases in Mexico City while Cave des Terres sends an unfamiliar Paris status code. On 23 March Elena enlarges Madrid’s first flight pour. On 24 March the Paris customs envelope is sealed. On 25 March Rafael Vega opens six cases at Mesa del Agave in Madrid and lays out the morning folder before that evening’s tasting.

## Examples (13 of 13 bottled)

01. [Miahuatlán agave](01-miahuatlan-agave/) — available
02. [Minas roast](02-minas-roast/) — available
03. [Minas maestra](03-minas-maestra/) — available
04. [Minas tina](04-minas-tina/) — available
05. [Minas clay still](05-minas-clay-still/) — available
06. [Minas heart cut](06-minas-heart-cut/) — available
07. [Minas resting jars](07-minas-resting-jars/) — available
08. [Oaxaca aroma flight](08-oaxaca-aroma-flight/) — available
09. [Oaxaca label proof](09-oaxaca-label-proof/) — available
10. [Mexico City allocation](10-mexico-city-allocation/) — available
11. [Oaxaca flight revision](11-oaxaca-flight-revision/) — available
12. [Paris customs envelope](12-paris-customs-envelope/) — available
13. [Madrid morning folder](13-madrid-morning-folder/) — available

## What each scenario adds

| Slot | Codable or enum behavior / Swift idiom |
| --- | --- |
| 01 | String-backed enum, CaseIterable, @Bindable Picker |
| 02 | Codable struct, copy/edit/assign, Grid |
| 03 | Nested Codable structs, sorted @Query |
| 04 | Optional Codable, if let shorthand, Optional.map |
| 05 | Int-backed enum, switch expression, #Predicate + SortDescriptor, List |
| 06 | Associated-value Codable enum, explicit JSON Data, Result, switch / if case |
| 07 | Codable struct array, replacement append, lazy.filter, KeyPath map |
| 08 | Codable enum array, Binding, sheet, filter |
| 09 | CodingKeys, throwing factory, JSON import, Table |
| 10 | Raw-code facade, computed enum, predicate + fetchLimit, compactMap |
| 11 | Nested value snapshots, guard, KeyPath reduction, whole-value replacement |
| 12 | ISO 8601 strategies, @ModelActor, async/await, Sendable DTO |
| 13 | Shared schema registry, fresh reads, Codable manifest, independent snapshot |

Direct enum and struct properties are the lesson in the opening cards. The heart-cut decision and customs envelope deliberately store JSON bytes in `Data` properties: their types provide explicit throwing encode/decode operations. Those examples teach a wire boundary, not an assumption about how SwiftData internally encodes every Codable type. The label proof keeps `CodingKeys` on a separate printer document for JSON import/export; its directly stored value uses synthesized keys matching its Swift properties.

Queries filter primitive columns and then match enums in Swift. The distributor card shows an alternative for a queryable status: retain the raw code in the store and expose a computed optional enum. An unfamiliar code remains available for review. These screens target the package’s macOS 14 API baseline and do not use newer attribute options.

The shared `MemoryStore`, `inMemoryStore(for:)`, fresh-read helpers, `GregorianDay`, and `ScenarioChrome` carry setup and presentation. `MezcalFolder.types` is the feature’s combined schema registry. Tests live in `Tests/SwiftDataMultivitaminTests/CodableAndEnumTests.swift`, one lesson test per slot, and use fresh contexts to read saved values.

See [CONTRIBUTING.md](../../CONTRIBUTING.md) before filling a later feature.
