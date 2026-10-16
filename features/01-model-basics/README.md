# @Model basics

A class marked `@Model`, the stored properties on it, and the schema that
decides which of those classes a store holds.

Official reference: <https://developer.apple.com/documentation/swiftdata/model()>

The thirteen screens are one order for a quince-branch intaglio, told as
paperwork moving between desks. Each screen opens its own in-memory store.
The chain is the story and the values on the slips, not one shared database.

Nino Beridze at the Works on Paper room of the Georgian National Museum
commissions six copper plates and forty impressions. Oliwia Wróbel in
Legnica cuts the blanks. Bram Visser in Haarlem bites the plate. Joana Puig
in Barcelona mills the black. Chiara Fioravanti in Fabriano damps the rag
sheets. Giulia Bruni in Verona writes the crate label and the waybill as
two unlinked slips. Nino reads the order back to her room. Mariam
Gelashvili marks the job card received without changing its identity. Joana
logs a second, warmer grind. Paolo Fioravanti checks that the mill book
does not keep Tbilisi's commission. Luka Katsitadze reprices the overrun
at the Vera District Print Room. Elif Berger registers one impression at
the Albertina. On 21 March the four slips that matter that morning sit on
Nino's desk.

## Examples (13 of 13 bottled)

01. [Tbilisi quince commission](01-tbilisi-quince-commission/) — available
02. [Legnica copper blank](02-legnica-copper-blank/) — available
03. [Haarlem bite note](03-haarlem-bite-note/) — available
04. [Barcelona bone black](04-barcelona-bone-black/) — available
05. [Fabriano damp pack](05-fabriano-damp-pack/) — available
06. [Verona crate and waybill](06-verona-crate-and-waybill/) — available
07. [Tbilisi desk briefing](07-tbilisi-desk-briefing/) — available
08. [Tbilisi plate receipt](08-tbilisi-plate-receipt/) — available
09. [Barcelona two grinds](09-barcelona-two-grinds/) — available
10. [Fabriano mill schema](10-fabriano-mill-schema/) — available
11. [Vera District shelf card](11-vera-district-shelf-card/) — available
12. [Albertina bench slip](12-albertina-bench-slip/) — available
13. [Morning handover folder](13-morning-handover-folder/) — available

## What each scenario adds

| Slot | @Model technique |
| --- | --- |
| 01 | One `@Model` class; stored properties are the record |
| 02 | The initializer requires every non-optional stored property |
| 03 | Optional stored properties can be absent |
| 04 | Default values are the stored starting value |
| 05 | `String`, `Int`, `Double`, `Bool`, and `Date` on one model |
| 06 | Two `@Model` types in one schema, with no relationship |
| 07 | A method on the model is not a stored property |
| 08 | `persistentModelID` stays put when a stored property changes |
| 09 | Two instances of one class are two records |
| 10 | The schema decides which `@Model` types the store holds |
| 11 | Assigning a property edits that record in place |
| 12 | `insert` registers the instance you already hold |
| 13 | Several model classes, one schema, still no links between them |

See [CONTRIBUTING.md](../../CONTRIBUTING.md) before filling a later feature.
