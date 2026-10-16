# Transient · 07 · Bedesten aside

On 8 April Aylin Şahin files pipe EB-7 at 4000 lira in the Eskişehir bedesten. She then writes that Emre will collect at dusk.

**What it teaches**

- Writing the aside leaves `hasChanges` false.
- A second save still files 4000 lira. A new context reads an empty aside.

**Files**

| File | Role |
| --- | --- |
| [`BedestenCard.swift`](BedestenCard.swift) | The counter card and its screen |

**Try it**

Open Bedesten aside. Open the counter card, then type the aside into the field. Each keystroke reads `hasChanges`, and it stays No. Save and read the filed card: the price stays 4000 lira and the aside is empty.

`swift test` locks the clean context in `asideDoesNotMarkTheContext`.
