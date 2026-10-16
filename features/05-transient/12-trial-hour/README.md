# Transient · 12 · Trial hour

On 13 April Halime Öztürk tries the cherry tenon at 16:00. The unmarked hour on the card is 08:00, when the bench opened.

**What it teaches**

- The trial hour is not a column.
- A new context reads 08:00. The wood is cherry.
- `hoursAfterOpening` is a computed property in an extension. It reads 8 on this card and 0 on the filed card.

**Files**

| File | Role |
| --- | --- |
| [`TrialFit.swift`](TrialFit.swift) | The trial card, the Istanbul clock, and the screen |

**Try it**

Open Trial hour. Pick the trial hour, open the card, then file it. This card shows 16:00. The filed card shows cherry and 08:00.

`swift test` locks the opening hour in `trialHourComesBackAsTheOpening`.
