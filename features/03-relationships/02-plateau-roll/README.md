# Relationships · 02 · Plateau roll

The same morning Lucien Morel posts two deliveries: 86 litres from Ferme Pellier and 74 from Ferme Gaillard in Le Fied.

**What it teaches**

- The roll is a to-many, so `isToOneRelationship` is false.
- The schema stores `maximumModelCount` 0, and the roll still holds both notes.

**Files**

| File | Role |
| --- | --- |
| [`PlateauRoll.swift`](PlateauRoll.swift) | The roll screen |
| [`../01-plasne-milk-note/MilkNote.swift`](../01-plasne-milk-note/MilkNote.swift) | The milk note and the fruitière |

**Try it**

Open Plateau roll. Post the roll and read the maximum beside the two deliveries.

`swift test` locks the zero maximum and both notes in `plateauRollHoldsBothNotesWhenTheMaximumIsZero`.
