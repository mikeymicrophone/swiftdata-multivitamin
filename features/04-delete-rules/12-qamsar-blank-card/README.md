# Delete rules · 12 · Qamsar blank card

On 19 May Hossein writes cook QS-23 and voids it before a slip is hung.

**What it teaches**

- `.cascade` is stored on a cook that has no slips.
- Voiding the card removes the cook. The save stands.

**Files**

| File | Role |
| --- | --- |
| [`BlankCard.swift`](BlankCard.swift) | The blank cook and the screen |

**Try it**

Open Qamsar blank card. Write the card, void it, and read the cook count.

`swift test` locks the empty book in `blankCardStillDeletes`.
