# @Model basics · 02 · Legnica copper blank

Oliwia Wróbel cuts the blanks for Nino's six plates. Lot LG-220 does not open until the lot code, the count, the thickness, and the alloy are filled in. The bench has no house default for a blank.

**What it teaches**

- The initializer is the gate for a new record.
- A non-optional stored property has to be supplied.
- `CopperBlankTicket.ticket` returns nil while any of those fields is empty or zero.

**Files**

| File | Role |
| --- | --- |
| [`CopperBlankTicket.swift`](CopperBlankTicket.swift) | The blank ticket and its screen |

**Try it**

Open Legnica copper blank. Write the ticket stays disabled until the lot code, a thickness above zero, and an alloy are filled in. A count of six and 0.8 mm of electrolytic copper matches the order.

`swift test` locks the gate in `copperBlankTicketRefusesAnEmptySlip`.
