# @Model basics · 11 · Vera District shelf card

Luka Katsitadze puts an overrun impression of the quince study on the counter at the Vera District Print Room for 85 lari. When the warmer black is confirmed, he changes that same card to 90.

**What it teaches**

- A model is a class.
- Assigning a property edits that record in place.
- The counter copy reads the same object the stepper writes.

**Files**

| File | Role |
| --- | --- |
| [`ShelfCard.swift`](ShelfCard.swift) | The shelf card and its screen |

**Try it**

Open Vera District shelf card. Put the card on the counter, then move the price. The counter copy repeats the new price.

`swift test` locks the in-place edit in `shelfCardEditsInPlace`.
