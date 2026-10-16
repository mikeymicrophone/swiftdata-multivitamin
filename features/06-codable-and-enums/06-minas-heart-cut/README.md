# Codable and enums · 06 · Minas heart cut

On 11 March Lucía cuts 96 litres of hearts at 47% ABV from SC-26 in Santa Catarina Minas. A held cut would carry a reason instead of volume and strength.

**What it teaches**

- An associated-value Codable enum can be explicitly encoded into a Data attribute.
- Decoding throws on damaged bytes; switch and if case recover the payload.

**Files**

| File | Role |
| --- | --- |
| [`HeartCut.swift`](HeartCut.swift) | The value types, stored card, and screen |

**Try it**

Open Minas heart cut. File Lucía’s hearts decision. Read the decoded volume and strength, then the resting-room handoff line matched with if case.

`swift test` locks the lesson in `heartCutRecoversEveryAssociatedPayloadAndRejectsDamage`.
