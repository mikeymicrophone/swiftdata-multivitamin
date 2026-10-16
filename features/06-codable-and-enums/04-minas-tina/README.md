# Codable and enums · 04 · Minas tina

On 9 March Mateo Cruz samples the Guayabo tina holding SC-26. A dry sample reads zero Brix at 29 °C; an empty line means no sample.

**What it teaches**

- An optional Codable reading distinguishes no sample from a measured zero.
- Assigning a reading and clearing it are both saved states.

**Files**

| File | Role |
| --- | --- |
| [`FermentCard.swift`](FermentCard.swift) | The value types, stored card, and screen |

**Try it**

Open Minas tina. Open the tina, record the dry sample, then withdraw it. Each action saves and reads through a new context. Zero and no sample remain visibly different.

`swift test` locks the lesson in `tinaSeparatesNoSampleFromZeroBrix`.
