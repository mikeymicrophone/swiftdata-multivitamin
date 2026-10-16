# Delete rules

What happens to related records when a model is deleted.

Official reference: <https://developer.apple.com/documentation/swiftdata/schema/relationship/deleterule>

The thirteen screens are one cook of rosewater, from a terrace in Qamsar to a supper in Yazd. Each screen opens its own in-memory store.

On 12 May 2026 Leila Amini cuts four baskets on the upper terrace in Qamsar. On 13 May Hossein Nazeri distills cook QS-22 at his golabkhaneh, 18 litres, and fills a jar. On 14 May the tasting slips hang on that cook. On 15 May Farhad Golshan writes a seal chit in the Kashan bazaar copper row. On 16 May the card for Still 2 is pulled while the cook is charged. On 17 May the wall tally is wiped. On 18 May the cook card is voided: the slips go, and Still 2 stays. On 19 May Maryam Farahi voids a duplicate tray at Shirini Farahi in Yazd. Soraya Dehghan, who brings the gaz from the Kashan bazaar, is named on a place card. Jar J-1 cracks; jar J-2 stays. A blank cook card is voided before any slip is hung. On 20 May the four outcomes sit on Maryam's counter. The Farahi supper is that evening.

## Examples (13 of 13 bottled)

01. [Qamsar terrace book](01-qamsar-terrace-book/) — available
02. [Qamsar filled jar](02-qamsar-filled-jar/) — available
03. [Qamsar cook slips](03-qamsar-cook-slips/) — available
04. [Qamsar torn slip](04-qamsar-torn-slip/) — available
05. [Kashan seal chit](05-kashan-seal-chit/) — available
06. [Qamsar copper still](06-qamsar-copper-still/) — available
07. [Qamsar wall tally](07-qamsar-wall-tally/) — available
08. [Qamsar cook and still](08-qamsar-cook-and-still/) — available
09. [Qamsar correction line](09-qamsar-correction-line/) — available
10. [Yazd wedding tray](10-yazd-wedding-tray/) — available
11. [Yazd sister jar](11-yazd-sister-jar/) — available
12. [Qamsar blank card](12-qamsar-blank-card/) — available
13. [Yazd morning folder](13-yazd-morning-folder/) — available

## What each scenario adds

| Slot | Delete rule |
| --- | --- |
| 01 | No rule argument. The schema stores nullify, and the ticket stays |
| 02 | `.nullify`. The jar stays, and its litres stay |
| 03 | `.cascade` on the cook. The slips go with the cook |
| 04 | The other end is nullify. Tearing the slip leaves the cook |
| 05 | `.cascade` on the model that is voided. The chit takes the cook with it |
| 06 | `.deny` is stored. The save still removes the still and keeps the cook |
| 07 | `.noAction` is stored. The mark stays, and its tally line is empty |
| 08 | One delete cascades the slips and nullifies the still |
| 09 | Cascade continues through a second cascade, and the corrections go |
| 10 | Cascade stops at a nullify link. The place cards go. The litres stay |
| 11 | Nullify on one jar. The lot and the sister jar stay |
| 12 | Cascade with no slips still removes the cook |
| 13 | Four source cards in one save, each outcome fetched again |

See [CONTRIBUTING.md](../../CONTRIBUTING.md) before filling a later feature.
