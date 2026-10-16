# @Model basics · 03 · Haarlem bite note

The Legnica blanks reach Bram Visser's etching loft. He pulls plate HV-6 from an 18-minute bath in hard ground. The foul-bite line and the next bath can stay blank.

**What it teaches**

- An optional stored property can be absent.
- Nil is a stored state, not a missing column.
- Turning a line on writes a value; leaving it off stores nil.

**Files**

| File | Role |
| --- | --- |
| [`BiteNote.swift`](BiteNote.swift) | The bite note and its screen |

**Try it**

Open Haarlem bite note. Write the note with both optional lines off, then again in a fresh launch with a foul-bite line filled in. The stored note shows "Left blank" or the line you typed.

`swift test` locks the blank optionals in `biteNoteCanLeaveTheOptionalLinesBlank`.
