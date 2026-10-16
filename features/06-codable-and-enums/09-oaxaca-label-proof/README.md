# Codable and enums · 09 · Oaxaca label proof

On 21 March Imprenta del Nopal in Oaxaca de Juárez sends Elena the SC-26 label proof: 47% ABV in a 700 ml bottle. The printer uses Spanish document keys.

**What it teaches**

- CodingKeys translates an external label document before insertion.
- A separate document type keeps wire keys out of the stored Codable value.

**Files**

| File | Role |
| --- | --- |
| [`LabelProof.swift`](LabelProof.swift) | The value types, stored card, and screen |

**Try it**

Open Oaxaca label proof. Read the Nopal proof. The table shows the decoded lot, strength, and volume; the receipt reads the lot from a saved proof. `PrinterLabelDocument` uses CodingKeys for Spanish JSON import/export, while the directly stored `BottleLabel` uses synthesized keys matching its Swift properties. Keeping these types separate avoids missing mandatory fields when SwiftData saves and reloads the composite value.

`swift test` locks the lesson in `labelKeysTranslateAtTheJSONBoundary`.
