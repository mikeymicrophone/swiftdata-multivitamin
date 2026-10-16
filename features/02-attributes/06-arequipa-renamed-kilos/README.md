# Attributes · 06 · Arequipa renamed kilos

On 11 June Raúl Mamani reprints the mill card. The old column was fleece kilos. The card now records scoured kilos, 1.1 for lot AQ-10.

**What it teaches**

- `originalName: "fleeceKilos"` is stored on `scouredKilos`.
- `lotCode` has no original name, and the schema stores that original name as an empty string.

**Files**

| File | Role |
| --- | --- |
| [`ScouredWeight.swift`](ScouredWeight.swift) | The scoured weight and its screen |

**Try it**

Open Arequipa renamed kilos. Reprint the weight and read the previous column names.

`swift test` locks both original names in `renamedKilosKeepTheOldColumnName`.
