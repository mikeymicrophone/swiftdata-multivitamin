# Attributes · 07 · Arequipa ledger reprint

The same morning, the season column on the reprinted ledger carries hash modifier `mill-ledger-2026`. The desk note beside it has none.

**What it teaches**

- `hashModifier` is stored on the attribute.
- A property with no hash modifier leaves `hashModifier` nil.

**Files**

| File | Role |
| --- | --- |
| [`SeasonReprint.swift`](SeasonReprint.swift) | The season reprint and its screen |

**Try it**

Open Arequipa ledger reprint. Reprint the season and compare the two hash lines.

`swift test` locks the modifier in `seasonReprintStoresTheHashModifier`.
