# Relationships

To-one and to-many links, inverses, and the counts and names stored on a relationship.

Official reference: <https://developer.apple.com/documentation/swiftdata/relationship(_:deleterule:minimummodelcount:maximummodelcount:originalname:inverse:hashmodifier:)>

The thirteen screens are one wheel of Comté, from the morning milk at Plasne to a counter on the Grande Rue in Besançon. Each screen opens its own in-memory store.

On 2 September 2026 Hélène Pellier writes 86 litres at Ferme Pellier before the fruitière is named. Lucien Morel then posts that note with Antoine Gaillard's 74 litres from Le Fied, and he keeps Pellier as a member and Gaillard as a guest. On 3 September the morning vat is marked on wheel PL-19. On 4 September Claire Roux racks it in the young cave at Les Rousses and takes cracked PL-03 off the rack. On 6 September Marc Bouvet's boards arrive from Champagnole, and SP-2 takes the wheel from SP-1. On 7 September Chantal Vercel opens a card at Fromagerie Vercel for Odile Marchand's supper. On 8 September Inès Garnier and Paul Besnard taste the wheel at the Maison du Comté in Poligny. On 9 September Inès writes the slip. On 10 September Claire reprints the rack list that used to be called meules. On 11 September Lucien reprints the guest book. On 12 September the wheel moves to the aging cave. On 14 September the four pairs sit on Chantal's counter. The supper is 20 September.

## Examples (13 of 13 bottled)

01. [Plasne milk note](01-plasne-milk-note/) — available
02. [Plateau roll](02-plateau-roll/) — available
03. [Plasne member book](03-plasne-member-book/) — available
04. [Plasne morning vat](04-plasne-morning-vat/) — available
05. [Rousses young cave](05-rousses-young-cave/) — available
06. [Champagnole spruce board](06-champagnole-spruce-board/) — available
07. [Besançon supper card](07-besancon-supper-card/) — available
08. [Poligny jury](08-poligny-jury/) — available
09. [Poligny tasting slip](09-poligny-tasting-slip/) — available
10. [Rousses renamed rack](10-rousses-renamed-rack/) — available
11. [Plasne guest reprint](11-plasne-guest-reprint/) — available
12. [Rousses aged cave](12-rousses-aged-cave/) — available
13. [Besançon morning folder](13-besancon-morning-folder/) — available

## What each scenario adds

| Slot | Relationship technique |
| --- | --- |
| 01 | An optional to-one, absent until the fruitière is named |
| 02 | A to-many. `maximumModelCount` is 0, and both notes stay on the roll |
| 03 | Two relationships to one type, each with an explicit inverse |
| 04 | Setting the to-one fills the inverse to-many |
| 05 | Appending sets the inverse. Removing clears it and leaves the model |
| 06 | `.unique` moves the wheel onto the second board and keeps the first board |
| 07 | `minimumModelCount` 1, no inverse, and a nil buyer still files |
| 08 | Many-to-many, filled from either side |
| 09 | One slip with two to-one links |
| 10 | `originalName` on the macro, the inverse's own name, and an empty original name |
| 11 | `hashModifier` on the guest list, nil on the member list and the inverse |
| 12 | Reassigning the to-one moves the wheel and keeps its identity |
| 13 | Several pairs in one schema, each inverse intact after a save |

What a delete does to a related model is bottled with the delete rules.

See [CONTRIBUTING.md](../../CONTRIBUTING.md) before filling a later feature.
