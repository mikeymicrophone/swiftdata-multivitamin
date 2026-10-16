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

## Relationships

### A to-many whose maximum is 0 still holds every note

**What happens.** `Fruitiere.notes` is declared `@Relationship` with no count arguments. The schema stores `minimumModelCount` 0 and `maximumModelCount` 0. The Pellier note and the Gaillard note are both appended. Both stay on the roll, and each note names the plateau fruitière.

**Why it matters.** A clerk who reads 0 as "this roll holds nothing" will think the morning deliveries were refused.

**What to do.** Treat 0 on a relationship that carries `@Relationship` as the omitted count. Count the models when you need the size of the roll.

Shown in [Plateau roll](features/03-relationships/02-plateau-roll/).

### A second unique board takes the wheel and leaves the first board in the store

**What happens.** `SpruceBoard.wheel` is `@Relationship(.unique)` with `maximumModelCount` 1. Board SP-1 is given wheel PL-19. Board SP-2 is then given that same wheel. SP-1's wheel becomes nil. SP-2 carries PL-19. The save throws nothing. A fetch returns both boards.

**Why it matters.** Unique does not refuse the second board, and it does not delete the first one. The wheel moves.

**What to do.** After the second assignment, read both boards. The earlier board is still a row.

Shown in [Champagnole spruce board](features/03-relationships/06-champagnole-spruce-board/).

### A buyer minimum of 1 still files a card with no buyer

**What happens.** `SupperOrder.buyer` is `@Relationship(minimumModelCount: 1)`. `SupperBuyer` has no relationship back, so `inverseName` is nil. The card is saved with no buyer. The save throws nothing. A new context fetches one card, and its buyer is nil.

**Why it matters.** The minimum is a stored count. It does not stop the save.

**What to do.** Read `minimumModelCount` from the schema. If the card must name a buyer, check the relationship before saving.

Shown in [Besançon supper card](features/03-relationships/07-besancon-supper-card/).

### An inverse stores its own name as the original name

**What happens.** `CheeseRack.wheels` is `@Relationship(originalName: "meules")`. Its original name is `meules`. `RackWheel.rack` is the inverse and does not carry `@Relationship`. Its original name is `rack`. `RackWheel.label` carries `@Relationship` and omits `originalName`. Its original name is `""`. `ShelfLabel.wheel`, the inverse of that label, stores `wheel`.

**Why it matters.** An empty original name means the macro omitted it. An inverse's own name in that field does not mean the relationship was renamed.

**What to do.** Treat a non-empty original name as a previous name on the relationship that carries `@Relationship`. On an inverse that does not carry the macro, the stored original name is the property name.

Shown in [Rousses renamed rack](features/03-relationships/10-rousses-renamed-rack/).

## Delete rules

### A deny rule still saves the deletion

**What happens.** `CopperStill.cooks` is `@Relationship(deleteRule: .deny)`. Cook QS-22 is on that list. The still is deleted and the context is saved. The save throws nothing. A new context finds no still. It finds the cook, and the cook's still line is empty.

**Why it matters.** The rule name says the deletion should be refused while a cook is charged. This store deletes the still anyway.

**What to do.** Read `deleteRule` when you need the stored mark. After the save, fetch the cook if the desk still needs it. Do not treat deny as a guard in this store.

Shown in [Qamsar copper still](features/04-delete-rules/06-qamsar-copper-still/).

### A noAction rule leaves the related mark with an empty link

**What happens.** `WallTally.marks` is `@Relationship(deleteRule: .noAction)`. The tally is deleted and the context is saved. The save throws nothing. A new context finds no tally. It finds chalk mark QS-22, and that mark's tally is nil.

**Why it matters.** No action does not leave the mark pointing at the deleted tally. The link is empty, and the mark stays.

**What to do.** Read the stored rule when the name matters. After the save, read the mark from a new context. Its tally line is empty.

Shown in [Qamsar wall tally](features/04-delete-rules/07-qamsar-wall-tally/).
