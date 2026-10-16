# Codable and enums · 11 · Oaxaca flight revision

On 23 March Elena copies Sala del Tule’s Oaxaca flight for Mesa del Agave in Madrid. The SC-26 pour grows from 15 to 20 ml; the SC-25 reserve pour stays at 10 ml.

**What it teaches**

- Copying a Codable recipe into another model creates an independent value snapshot.
- A KeyPath reduction totals the nested pours after a whole-value replacement.

**Files**

| File | Role |
| --- | --- |
| [`FlightRecipe.swift`](FlightRecipe.swift) | The value types, stored card, and screen |

**Try it**

Open Oaxaca flight revision. Copy and resize Madrid’s flight. The fresh readings total 25 ml for Oaxaca and 30 ml for Madrid. A value snapshot can be revised without editing its source.

`swift test` locks the lesson in `flightCopiesKeepIndependentNestedPours`.
