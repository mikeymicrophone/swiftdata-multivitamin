# Codable and enums · 10 · Mexico City allocation

On 22 March Distribuidora del Sur in Mexico City packs eight cases of SC-26. Cave des Terres in Paris sends stage code quai for four more cases.

**What it teaches**

- A raw String column supports a predicate while a computed enum guides the desk.
- Unknown distributor codes stay intact instead of silently becoming a known case.

**Files**

| File | Role |
| --- | --- |
| [`DistributorAllocation.swift`](DistributorAllocation.swift) | The value types, stored card, and screen |

**Try it**

Open Mexico City allocation. Read the packed queue. Only the Mexico City allocation appears there. The unfamiliar Paris code stays visible for review instead of being replaced by a known enum case.

`swift test` locks the lesson in `allocationQueuePreservesUnknownCodes`.
