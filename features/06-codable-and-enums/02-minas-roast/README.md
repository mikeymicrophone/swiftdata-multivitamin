# Codable and enums · 02 · Minas roast

On 3 March Lucía Hernández covers 840 kilos from SC-26 in the earth oven at Palenque del Guayabo in Santa Catarina Minas. The roast starts at 72 hours.

**What it teaches**

- A Codable struct is a value on the roast card, not a related model.
- Copying, editing, and assigning the value files the revised roast.

**Files**

| File | Role |
| --- | --- |
| [`RoastCard.swift`](RoastCard.swift) | The value types, stored card, and screen |

**Try it**

Open Minas roast. Write the oven card, then add six hours. Compare the open and filed readings in the grid: 840 kilos, 78 hours.

`swift test` locks the lesson in `roastReplacementKeepsTheKilos`.
