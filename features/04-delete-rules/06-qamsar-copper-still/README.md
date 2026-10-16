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

Open Qamsar copper still. Charge the still, then pull the card. The desk warns that a cook is still charged, and the store pulls the card anyway. The filed cook is found by a `#Predicate` on its empty still line.

`swift test` locks the stored deny and the remaining cook in `denyStillSavesAndKeepsTheCook`.
