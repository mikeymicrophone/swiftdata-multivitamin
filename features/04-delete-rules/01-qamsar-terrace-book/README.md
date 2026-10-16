# Delete rules · 01 · Qamsar terrace book

On 12 May Leila Amini lists four baskets from the upper terrace in Qamsar. A duplicate book is torn up.

**What it teaches**

- The tickets relationship has no delete-rule argument. The schema stores nullify.
- The harvest ticket stays, and its book line is empty.

**Files**

| File | Role |
| --- | --- |
| [`HarvestBook.swift`](HarvestBook.swift) | The book, the ticket, and the screen |

**Try it**

Open Qamsar terrace book. Open the book, then tear it up from its row. Both lists are `@Query` results, so the book row disappears and the ticket row redraws with an empty book line.

`swift test` locks the rule and the ticket in `terraceBookNullifiesTheTicket`.
