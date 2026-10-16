# Attributes · 11 · Puno seal and photo

The wax seal for PU-77 stays in the row. The copied scale-face bytes are marked external. Both sit on one pack record.

**What it teaches**

- Two `Data` properties on one model can carry different attribute options.
- `waxSeal` has an empty option list. `scalePhoto` contains `.externalStorage`.

**Files**

| File | Role |
| --- | --- |
| [`BalePack.swift`](BalePack.swift) | The pack, the two byte values, and the screen |

**Try it**

Open Puno seal and photo. Pack the bale and read where each value sits.

`swift test` locks the two option lists in `waxSealStaysInlineAndScalePhotoIsExternal`.
