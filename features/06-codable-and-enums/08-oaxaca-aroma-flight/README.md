# Codable and enums · 08 · Oaxaca aroma flight

On 20 March Elena Ruiz pours SC-26 at Sala del Tule in Oaxaca de Juárez. Roasted agave comes before wet clay in her distributor flight.

**What it teaches**

- A collection of Codable enum values keeps its tasting order.
- A sheet edits the collection by assigning a replacement array.

**Files**

| File | Role |
| --- | --- |
| [`AromaFlight.swift`](AromaFlight.swift) | The value types, stored card, and screen |

**Try it**

Open Oaxaca aroma flight. Choose the flight aromas, change the toggles in the sheet, return to Elena’s flight, then file it. The receipt preserves selection order.

`swift test` locks the lesson in `aromaArrayKeepsOrderAndRemovesASelection`.
