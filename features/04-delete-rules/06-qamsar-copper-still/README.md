# Delete rules · 06 · Qamsar copper still

On 16 May the card for Still 2 is pulled while cook QS-22 is charged. Farhad Golshan made the still. Hossein Nazeri runs it.

**What it teaches**

- `.deny` is the stored rule on the still's cook list.
- The save removes the still. The cook remains, and its still line is empty.

**Files**

| File | Role |
| --- | --- |
| [`CopperStill.swift`](CopperStill.swift) | The still, the cook, and the screen |

**Try it**

Open Qamsar copper still. Charge the still, pull the card, and read the filed cook.

`swift test` locks the stored deny and the remaining cook in `denyStillSavesAndKeepsTheCook`.
