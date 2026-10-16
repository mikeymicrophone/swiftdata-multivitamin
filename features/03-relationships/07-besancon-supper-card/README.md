# Relationships · 07 · Besançon supper card

On 7 September Chantal Vercel opens a card at Fromagerie Vercel, Grande Rue, for Odile Marchand's supper on 20 September. The buyer line is empty.

**What it teaches**

- `minimumModelCount` is 1, and `inverseName` is nil because the buyer has no relationship back.
- Filing the card with no buyer still saves. A new context reads that empty buyer.

**Files**

| File | Role |
| --- | --- |
| [`SupperOrder.swift`](SupperOrder.swift) | The supper card, the buyer, and the screen |

**Try it**

Open Besançon supper card. Open the card, file it, and read the buyer line in the filed book.

`swift test` locks the minimum and the empty buyer in `supperCardFilesWithNoBuyer`.
