# @Model basics · 08 · Tbilisi plate receipt

Mariam Gelashvili opens the job card that travelled in crate VR-14. The card still says bitten. She marks HV-6 in the Works on Paper room. The identity on the card does not change.

**What it teaches**

- `persistentModelID` identifies the record.
- Changing a stored property does not change that identity.

**Files**

| File | Role |
| --- | --- |
| [`PlateJob.swift`](PlateJob.swift) | The plate job and its screen |

**Try it**

Open Tbilisi plate receipt. Receive the plate job, then change the state from bitten to in the Works on Paper room. The screen says the job identity is unchanged.

`swift test` locks that comparison in `plateJobIdentitySurvivesAStateChange`.
