# @Model basics · 09 · Barcelona two grinds

After the briefing, Nino asks for a warmer black. On 15 March Joana Puig logs two grind lines: BP-19-A stays four passes of bone black, and BP-19-B starts at two passes of bone black with burnt sienna.

**What it teaches**

- Two instances of one class are two records.
- Editing one instance leaves the other alone.
- The two lines have different `persistentModelID` values.

**Files**

| File | Role |
| --- | --- |
| [`GrindEntry.swift`](GrindEntry.swift) | The grind entry and the two-line screen |

**Try it**

Open Barcelona two grinds. Log both grinds, then raise the passes on BP-19-B. The BP-19-A line still reads four passes of bone black.

`swift test` locks the independence in `twoGrindEntriesStayIndependent`.
