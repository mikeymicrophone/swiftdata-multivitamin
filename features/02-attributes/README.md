# Attributes

`@Attribute` options, a previous column name, and a hash modifier.

Official reference: <https://developer.apple.com/documentation/swiftdata/attribute(_:originalname:hashmodifier:)>

The thirteen screens are one vicuña shawl, from a community chaccu in Lucanas to a counter on Calle Linares in La Paz. Each screen opens its own in-memory store.

On 8 June 2026 Florentina Quispe licenses vicuña LQ-184 at the Lucanas corral. Nélida Apaza locks the community price at 480 soles the same morning. Raúl Mamani weighs the fleece in Arequipa on 10 June and, on 11 June, reprints the ledger so fleece kilos are now scoured kilos. Soledad Condori's road desk in Puno carries bale PU-77 on 12 June. Rosario Choque dyes it in Sucre on 14 June. Edwin Cruz records the fiber diameter in Tarabuco on 16 June. Mariela Rojas files the shawl at Casa Rojas on 18 June. On 20 June the four slips that matter sit on her counter. A second card for LQ-184, offered later on 8 June, does not open a second row.

## Examples (13 of 13 bottled)

01. [Lucanas ear mark](01-lucanas-ear-mark/) — available
02. [Arequipa weigh photo](02-arequipa-weigh-photo/) — available
03. [Puno lot spotlight](03-puno-lot-spotlight/) — available
04. [Sucre dye note](04-sucre-dye-note/) — available
05. [Lucanas agreed price](05-lucanas-agreed-price/) — available
06. [Arequipa renamed kilos](06-arequipa-renamed-kilos/) — available
07. [Arequipa ledger reprint](07-arequipa-ledger-reprint/) — available
08. [La Paz spoken markup](08-la-paz-spoken-markup/) — available
09. [Tarabuco micron reading](09-tarabuco-micron-reading/) — available
10. [Puno bale code](10-puno-bale-code/) — available
11. [Puno seal and photo](11-puno-seal-and-photo/) — available
12. [Lucanas second card](12-lucanas-second-card/) — available
13. [La Paz morning folder](13-la-paz-morning-folder/) — available

## What each scenario adds

| Slot | Attribute technique |
| --- | --- |
| 01 | `@Attribute(.unique)` and the uniqueness constraint |
| 02 | `@Attribute(.externalStorage)` on a `Data` value, which still round-trips |
| 03 | `@Attribute(.spotlight)` as a mark. This store is not a Spotlight catalog |
| 04 | `@Attribute(.allowsCloudEncryption)` as a mark. This store does not sync |
| 05 | `@Attribute(.preserveValueOnDeletion)` as a mark |
| 06 | `originalName`, and the empty original name on an unmarked property |
| 07 | `hashModifier`, and nil when it is omitted |
| 08 | `@Attribute(.ephemeral)`: unfiled after save, and not `isTransient` |
| 09 | `@Attribute(.transformable)` through a `ValueTransformer` |
| 10 | `.unique` and `.spotlight` on one property |
| 11 | One inline `Data` and one external `Data` |
| 12 | A second save with the same unique value keeps one row and takes the new values |
| 13 | Several models in one schema, each mark still on its own attribute |

See [CONTRIBUTING.md](../../CONTRIBUTING.md) before filling a later feature.
