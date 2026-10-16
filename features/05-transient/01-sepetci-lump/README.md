# Transient · 01 · Sepetçi lump card

On 2 April Kemal Aydın cuts lump EB-7 at the pit in Sepetçi, 180 grams. He says to avoid the grey seam.

**What it teaches**

- The seam note is not among the schema properties. The columns are the lump code, the cutter, the grams, and the day.
- The lump code is what a new context reads back.

**Files**

| File | Role |
| --- | --- |
| [`SepetciLump.swift`](SepetciLump.swift) | The lump card and its screen |

**Try it**

Open Sepetçi lump card. Open the card, then file it. The seam note is on the card and absent from the columns. The filed lump is EB-7.

`swift test` locks the columns and the filed code in `seamNoteIsAbsentFromTheSchema`.
