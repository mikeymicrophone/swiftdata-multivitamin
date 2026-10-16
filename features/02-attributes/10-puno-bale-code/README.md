# Attributes · 10 · Puno bale code

On 12 June Soledad Condori nails plate PU-77 on the bale bound for Taller Choque. The code is unique and marked for Spotlight.

**What it teaches**

- One property can take `.unique` and `.spotlight` together.
- The uniqueness constraint is `[["baleCode"]]`.

**Files**

| File | Role |
| --- | --- |
| [`BalePlate.swift`](BalePlate.swift) | The bale plate and its screen |

**Try it**

Open Puno bale code. Nail the plate. The screen shows the code as unique and marked.

Opening this store logs the same unfinished Spotlight index as the lot-name screen. The test still passes.

`swift test` locks both options in `baleCodeIsUniqueAndMarkedForSpotlight`.
