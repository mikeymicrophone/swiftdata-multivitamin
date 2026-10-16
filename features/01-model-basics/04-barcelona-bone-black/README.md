# @Model basics · 04 · Barcelona bone black

Joana Puig opens batch BP-19 on 8 March for the ink the quince impressions will use. An unordered batch starts as bone black, four passes, not yet approved. She can override those values and put the house formula back.

**What it teaches**

- A default value is the stored starting value.
- The caller can override a default without a second type.
- Restoring the house formula writes the defaults back onto the same batch. The opened day stays.

**Files**

| File | Role |
| --- | --- |
| [`BoneBlackBatch.swift`](BoneBlackBatch.swift) | The ink batch and its screen |

**Try it**

Open Barcelona bone black. Open the house batch and read the jar line. Raise the passes, mark it approved, then restore the house formula.

`swift test` locks the defaults in `boneBlackBatchStartsFromTheHouseFormula`.
