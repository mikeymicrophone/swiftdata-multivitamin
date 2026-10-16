# Codable and enums · 03 · Minas maestra

On 6 March Lucía signs the SC-26 fermentation book at Palenque del Guayabo. Her address is Santa Catarina Minas, district of Ocotlán.

**What it teaches**

- Codable values can nest other Codable structs.
- A sorted @Query reads the producer snapshot stored on each card.

**Files**

| File | Role |
| --- | --- |
| [`MaestraCard.swift`](MaestraCard.swift) | The value types, stored card, and screen |

**Try it**

Open Minas maestra. Sign the fermentation book. The sorted query shows Lucía’s nested address; the receipt reads the village through a new context.

`swift test` locks the lesson in `maestraSignatureKeepsItsNestedAddress`.
