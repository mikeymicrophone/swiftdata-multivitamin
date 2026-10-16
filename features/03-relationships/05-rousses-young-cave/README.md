# Relationships · 05 · Rousses young cave

On 4 September Claire Roux puts PL-19 on the young rack at Les Rousses and takes cracked PL-03 off it. PL-03 stays in the cave office with no cave named.

**What it teaches**

- Appending a wheel sets that wheel's cave.
- Removing a wheel clears the inverse and leaves the wheel in the store.

**Files**

| File | Role |
| --- | --- |
| [`YoungCave.swift`](YoungCave.swift) | The cave, the wheels, and the screen |

**Try it**

Open Rousses young cave. Set the rack and read PL-19 on it and PL-03 off it.

`swift test` locks both the link and the remaining wheel in `takingAWheelOffTheRackLeavesItInTheStore`.
