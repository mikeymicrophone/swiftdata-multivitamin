# Codable and enums · 07 · Minas resting jars

On 12 and 19 March Mateo checks jar SC-26-A in the Guayabo resting room in Santa Catarina Minas. The wax remains intact, and the clay aroma softens.

**What it teaches**

- An array of Codable structs is a value collection on one model.
- Appending through a copied array preserves the ordered inspection history.

**Files**

| File | Role |
| --- | --- |
| [`RestingJar.swift`](RestingJar.swift) | The value types, stored card, and screen |

**Try it**

Open Minas resting jars. File both wax inspections. Read the ordered day-and-note rows and the two-intact-inspections tally. The receipt repeats the notes from a new context.

`swift test` locks the lesson in `restingChecksKeepOrderAcrossAnAppend`.
