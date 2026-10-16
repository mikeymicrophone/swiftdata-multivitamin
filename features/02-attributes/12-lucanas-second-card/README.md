# Attributes · 12 · Lucanas second card

Later on 8 June a second card is offered for LQ-184. The new condition is a cut on the left shoulder. The book keeps the first license.

**What it teaches**

- The second save throws nothing and leaves one row.
- That row keeps the first `persistentModelID` and takes the new condition note.

**Files**

| File | Role |
| --- | --- |
| [`SecondLicense.swift`](SecondLicense.swift) | The screen. The model is `ShearingLicense` from the ear-mark slot |

**Try it**

Open Lucanas second card. File the first license, then file the second card. Both saves run on the `LicenseClerk` model actor; the screen awaits each one and keeps only the returned `PersistentIdentifier`. The main context then fetches one row, with the new condition and the first identity.

`swift test` locks the overwrite in `secondLicenseKeepsTheFirstIdentity`.
