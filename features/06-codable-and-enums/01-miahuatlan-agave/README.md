# Codable and enums · 01 · Miahuatlán agave

On 2 March 2026 Inés Santiago cuts espadín near Miahuatlán for lot SC-26. Palenque del Guayabo in Santa Catarina Minas receives the piñas.

**What it teaches**

- A String-backed Codable enum can be a stored property.
- CaseIterable supplies a Picker without storing its display labels separately.

**Files**

| File | Role |
| --- | --- |
| [`AgaveHarvest.swift`](AgaveHarvest.swift) | The value types, stored card, and screen |

**Try it**

Open Miahuatlán agave. Receive Inés’s piñas, choose an agave in the picker, then file the agave name. The new-context line shows the saved case.

`swift test` locks the lesson in `harvestKeepsTheChosenAgave`.
