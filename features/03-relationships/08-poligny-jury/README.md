# Relationships · 08 · Poligny jury

On 8 September Inès Garnier and Paul Besnard taste wheel PL-19 at the Maison du Comté in Poligny. Inès is added from the wheel. Paul is added from his own list.

**What it teaches**

- Tasters and wheels are a many-to-many. Neither side is to-one.
- Linking from either side fills the other side, and a new context still has both tasters.

**Files**

| File | Role |
| --- | --- |
| [`JuryWheel.swift`](JuryWheel.swift) | The wheel, the tasters, and the screen |

**Try it**

Open Poligny jury. Seat the jury, then pick each taster. The picker reads a sorted `@Query`; the wheel list below is a second `@Query` whose `#Predicate` looks inside the wheel's taster list. PL-19 shows up for both.

`swift test` locks both directions in `juryLinksFromEitherSide`.
