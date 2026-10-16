# Delete rules · 07 · Qamsar wall tally

On 17 May Hossein Nazeri wipes the heading on the still-house wall. The chalk mark under it is QS-22.

**What it teaches**

- `.noAction` is the stored rule on the tally's mark list.
- The mark stays. Its tally line is empty.

**Files**

| File | Role |
| --- | --- |
| [`WallTally.swift`](WallTally.swift) | The tally, the mark, and the screen |

**Try it**

Open Qamsar wall tally. Chalk the mark, wipe the tally, and read the filed mark.

`swift test` locks the empty tally line in `noActionLeavesTheMarkWithAnEmptyTally`.
