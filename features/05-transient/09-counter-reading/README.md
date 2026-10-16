# Transient · 09 · Counter reading

On 10 April Aylin Şahin writes that pipe EB-7 is wrapped in newspaper. She reads the open counter, then a fresh copy of the book.

**What it teaches**

- A fetch in this context is the same card, and the aside is still there.
- A new context is a different card and reads an empty aside.

**Files**

| File | Role |
| --- | --- |
| [`CounterReading.swift`](CounterReading.swift) | The reading screen |

**Try it**

Open Counter reading. Open the counter card, then read it again. Same card is yes. The new context aside is empty.

`swift test` locks the identity in `sameContextReturnsTheSameCard`.
