# @Model basics · 06 · Verona crate and waybill

Giulia Bruni's road desk in Verona has the bitten plates and a departure on 11 March. She writes crate label VR-14 and waybill BR-338 for the Brenner road desk. Neither slip points at the other.

**What it teaches**

- One schema can hold two model types.
- Those types stay separate records when neither points at the other.
- Editing the crate's handling note leaves the waybill's carrier alone.

**Files**

| File | Role |
| --- | --- |
| [`VeronaDeparture.swift`](VeronaDeparture.swift) | The crate label, the waybill, and the screen |

**Try it**

Open Verona crate and waybill. Write both slips, then change the handling note. The waybill still leaves with the Brenner road desk.

`swift test` locks the two entity names and the independent edit in `veronaSlipsStaySeparateRecords`.
