# Attributes · 08 · La Paz spoken markup

On 18 June Mariela Rojas opens a counter card at Casa Rojas, Calle Linares: 920 bolivianos. She says to add forty bolivianos. That sentence is ephemeral.

**What it teaches**

- `@Attribute(.ephemeral)` needs a default. After save, a new context reads the default, not the spoken line.
- `isTransient` stays false. The asking price is filed.

**Files**

| File | Role |
| --- | --- |
| [`ShawlCounter.swift`](ShawlCounter.swift) | The counter card and its screen |

**Try it**

Open La Paz spoken markup. Open the counter card, then file it. The filed book shows 920 bolivianos and an empty spoken markup.

`swift test` locks the filed row in `spokenMarkupIsEphemeralAndUnfiled`.
