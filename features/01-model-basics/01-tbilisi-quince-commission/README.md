# @Model basics · 01 · Tbilisi quince commission

Nino Beridze opens a commission at the Works on Paper room of the Georgian National Museum: six copper plates and forty impressions of "Quince branch, Vera courtyard", ordered 3 March 2026.

**What it teaches**

- A class marked `@Model` is the stored record.
- Each stored property is a field on that record.
- Editing the study title or the counts changes the card the room is reading.

**Files**

| File | Role |
| --- | --- |
| [`QuinceCommission.swift`](QuinceCommission.swift) | The commission model and its screen |

**Try it**

```sh
swift run SwiftDataMultivitamin
```

Open @Model basics, then Tbilisi quince commission. Open the commission, change the plate count, and read the sentence under the card.

`swift test` locks the stored fields in `quinceCommissionStoresTheFieldsYouPass`.
