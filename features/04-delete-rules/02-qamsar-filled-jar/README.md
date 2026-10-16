# Delete rules · 02 · Qamsar filled jar

On 13 May Hossein Nazeri fills jar J-1 with 18 litres from cook QS-22. The lot card is withdrawn.

**What it teaches**

- `.nullify` on the lot's jar list clears the jar's lot line.
- A new context still reads 18 litres on J-1.

**Files**

| File | Role |
| --- | --- |
| [`FilledJar.swift`](FilledJar.swift) | The lot, the jar, and the screen |

**Try it**

Open Qamsar filled jar. Fill the jar, withdraw the lot card, and read the litres.

`swift test` locks the litres in `filledJarKeepsItsLitres`.
