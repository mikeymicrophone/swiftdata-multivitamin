# @Model basics · 07 · Tbilisi desk briefing

On the evening of 11 March, Nino Beridze reads the commission back to the Works on Paper room: six plates, forty impressions, ordered 3 March 2026. The sentence is a method on the model.

**What it teaches**

- A method on the model is not a stored property.
- The method reads the stored fields and returns a value.
- The schema's property list has the fields and does not have `spokenSummary`.

**Files**

| File | Role |
| --- | --- |
| [`DeskBriefing.swift`](DeskBriefing.swift) | The briefing model, `spokenSummary()`, and the screen |

**Try it**

Open Tbilisi desk briefing. Open the briefing, then read it to the room.

`swift test` locks the sentence and the property list in `spokenSummaryIsNotAStoredProperty`.
