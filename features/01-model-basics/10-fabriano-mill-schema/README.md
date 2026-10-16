# @Model basics · 10 · Fabriano mill schema

On 16 March Paolo Fioravanti opens the mill book. It keeps rag lot FA-80 and deckle proof FA-80-D. `QuinceCommission` is a model class in this catalog, and this store's schema does not list it.

**What it teaches**

- `@Model` makes a class eligible for a store.
- The schema lists the types that store actually holds.
- Eligibility and membership are different steps.

**Files**

| File | Role |
| --- | --- |
| [`FioravantiMillBook.swift`](FioravantiMillBook.swift) | The rag lot, the deckle proof, the mill schema, and the screen |

**Try it**

Open Fabriano mill schema. Open the mill book and read the entity names. The list is the rag lot and the deckle proof.

`swift test` locks those names in `millSchemaOmitsTheTbilisiCommission`.
