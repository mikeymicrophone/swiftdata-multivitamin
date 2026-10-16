# Codable and enums · 05 · Minas clay still

On 10 March Lucía distills SC-26 twice in the clay pots at Palenque del Guayabo, Santa Catarina Minas. Ordinario precedes the finished spirit.

**What it teaches**

- An Int-backed Codable enum stores the distillation pass.
- Query the primitive lot code, then match the enum in Swift.

**Files**

| File | Role |
| --- | --- |
| [`ClayRun.swift`](ClayRun.swift) | The value types, stored card, and screen |

**Try it**

Open Minas clay still. Hang both clay-pot cards. The filtered and sorted list shows first and second passes, and the finished-run tally counts one. The receipt reads both saved cases.

`swift test` locks the lesson in `clayPassesFollowTheLotPredicate`.
