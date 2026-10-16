# Codable and enums · 12 · Paris customs envelope

On 24 March Cave des Terres in Paris receives the SC-26 envelope from Distribuidora del Sur. It carries certificate MX-SC-26 and the seal date from Mexico City.

**What it teaches**

- Explicit JSON date strategies define the customs document's wire format.
- A ModelActor reads stored bytes and returns a Sendable Codable value, not a model.

**Files**

| File | Role |
| --- | --- |
| [`CustomsEnvelope.swift`](CustomsEnvelope.swift) | The value types, stored card, and screen |

**Try it**

Open Paris customs envelope. Send the sealed envelope to the reader. The task awaits the model actor and displays a Sendable declaration. The actor receives a PersistentIdentifier; model objects stay in their contexts. ISO 8601 is an explicit JSON wire choice, not SwiftData’s automatic encoding strategy.

`swift test` locks the lesson in `customsActorReturnsTheDatedValue`.
