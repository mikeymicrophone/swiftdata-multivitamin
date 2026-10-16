# Discoveries

Non-obvious SwiftData behaviors found while bottling this catalog. Every
entry needs a test in this repository that shows it. Nothing is written
here from the docs alone, and nothing is written here until a test has
shown it.

Each entry has a short title, what happens, why it matters, what to do
about it, and a link to the scenario that shows it.

## Attributes

### A second insert with the same unique value overwrites the first row

**What happens.** Two `ShearingLicense` values with ear mark `LQ-184` are inserted, and each insert is saved. The second save throws nothing. A fetch returns one row. That row's `persistentModelID` is the first object's id. The first object's `conditionNote` is now the second card's note, "Cut on the left shoulder".

**Why it matters.** A clerk who expects the book to refuse a duplicate mark will instead replace the condition on the license already on the nail.

**What to do.** Save the first license, then treat a second insert with that mark as an edit of the existing row. Read the row back after the save.

Shown in [Lucanas second card](features/02-attributes/12-lucanas-second-card/).

### A property with no original name stores an empty string

**What happens.** `ScouredWeight.scouredKilos` is declared `@Attribute(originalName: "fleeceKilos")`. Its schema attribute has `originalName` `fleeceKilos` and `name` `scouredKilos`. `lotCode` on the same model has no `originalName` argument. Its schema attribute has `originalName` `""`.

**Why it matters.** Comparing `originalName` with `name` does not tell you whether the column was renamed. Every unmarked property fails that comparison, because the stored original name is empty rather than the current name.

**What to do.** Treat a non-empty `originalName` as the previous column name.

Shown in [Arequipa renamed kilos](features/02-attributes/06-arequipa-renamed-kilos/).

### An ephemeral attribute is not transient, and the value is absent after save

**What happens.** `ShawlCounter.spokenMarkup` is `@Attribute(.ephemeral)` with default `""`. The schema option list contains `ephemeral`. `isTransient` is false. The card is saved with spoken markup "Add forty bolivianos" and asking price 920. A new context fetches asking price 920 and spoken markup `""`.

**Why it matters.** A counter copy that reads `isTransient` will treat the spoken line as a stored column. The filed book does not contain it.

**What to do.** Give the ephemeral property a default. Read the option. After save, read the row from a new context when you need the filed value.

Shown in [La Paz spoken markup](features/02-attributes/08-la-paz-spoken-markup/).
