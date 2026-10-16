# @Model basics · 12 · Albertina bench slip

One impression, AP 2/6, reaches Elif Berger at the Albertina study room. She writes the foxing note on the slip in her hand, then registers that same slip with the bench context. Autosave is off on this screen so the registration stays visible as an unsaved change.

**What it teaches**

- `insert` registers the instance you already hold.
- The slip on the bench and the registered model are the same object.
- Before insert, the context has no changes. After insert, it does.

**Files**

| File | Role |
| --- | --- |
| [`BenchSlip.swift`](BenchSlip.swift) | The bench slip and its screen |

**Try it**

Open Albertina bench slip. Register the impression. The screen shows the mark, the foxing note, and that the context has the slip registered and not yet saved.

`swift test` locks the registration in `benchSlipInsertRegistersTheSameInstance`.
