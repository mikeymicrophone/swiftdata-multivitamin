# @Model basics · 13 · Morning handover folder

On 21 March, before the study day, Nino Beridze lays four slips on one desk: the commission, Chiara's damp pack, the plate job as Mariam left it, and Luka's shelf card at 90 lari. The screen reads across them. None of the models points at another.

**What it teaches**

- A schema can hold several model classes at once.
- The screen joins them. The models still do not point at each other.
- This store's entities are the commission, the damp slip, the plate job, and the shelf card.

**Files**

| File | Role |
| --- | --- |
| [`MorningHandover.swift`](MorningHandover.swift) | The morning folder screen, using the four models from earlier slots |

**Try it**

Open Morning handover folder. Lay out the folder and read the line across the desk.

`swift test` locks the four entity names in `morningFolderHoldsFourUnlinkedModels`.
