# Delete rules · 13 · Yazd morning folder

On 20 May Maryam Farahi pulls four cards before the Farahi supper: the cook, the lot, Still 2, and the wall tally.

**What it teaches**

- One save on a `@ModelActor` deletes those four sources. The screen hands the actor `PersistentIdentifier`s, not model objects, and gets back a `Sendable` audit.
- A new context shows no slips, jar J-1 with 18 litres and an empty lot, cook QS-22 with an empty still, and chalk mark QS-22 with an empty tally.

**Files**

| File | Role |
| --- | --- |
| [`RosewaterHandover.swift`](RosewaterHandover.swift) | The folder screen |

**Try it**

Open Yazd morning folder. Pull the four cards. The main context files the graph, and `.task(id:)` awaits `FolderAuditor.pull`. Read the four lines.

`swift test` locks the four outcomes in `morningFolderKeepsEachOutcome`.
