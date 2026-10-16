# Codable and enums · 09 · Oaxaca label proof

On 21 March Imprenta del Nopal in Oaxaca de Juárez sends Elena the SC-26 label proof: 47% ABV in a 700 ml bottle. The printer uses Spanish document keys.

**What it teaches**

- CodingKeys translates an external label document before insertion.
- The decoded Codable value is stored directly; its wire keys are a JSON concern.

**Files**

| File | Role |
| --- | --- |
| [`LabelProof.swift`](LabelProof.swift) | The value types, stored card, and screen |

**Try it**

Open Oaxaca label proof. Read the Nopal proof. The table shows the decoded lot, strength, and volume; the receipt reads the lot from a saved proof. CodingKeys applies when JSON is encoded or decoded, not as a SwiftData column-renaming instruction.

`swift test` locks the lesson in `labelKeysTranslateAtTheJSONBoundary`.
