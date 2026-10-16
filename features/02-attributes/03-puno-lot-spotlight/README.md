# Attributes · 03 · Puno lot spotlight

On 12 June Soledad Condori writes the lot name at the Condori road desk in Puno: "Lucanas chaccu, shawl for La Paz".

**What it teaches**

- `@Attribute(.spotlight)` marks `lotName`.
- The mark is the lesson. This in-memory store is not a Spotlight catalog. Opening it logs a Core Data Spotlight index that does not finish. The test still passes.

**Files**

| File | Role |
| --- | --- |
| [`RoadLot.swift`](RoadLot.swift) | The road lot and its screen |

**Try it**

Open Puno lot spotlight. Write the lot name. The screen says the name is marked.

`swift test` locks the option in `lotNameIsMarkedForSpotlight`.
