# Attributes · 01 · Lucanas ear mark

On 8 June 2026 Florentina Quispe opens the chaccu book at the Lucanas corral in Ayacucho. Vicuña LQ-184 is licensed for the shawl that will end in La Paz.

**What it teaches**

- `@Attribute(.unique)` marks `earMark`.
- The entity's uniqueness constraints are `[["earMark"]]`.

**Files**

| File | Role |
| --- | --- |
| [`ShearingLicense.swift`](ShearingLicense.swift) | The license and its screen |

**Try it**

Open Attributes, then Lucanas ear mark. Open the license and read the constraint line.

`swift test` locks the constraint in `earMarkIsTheUniqueConstraint`.
