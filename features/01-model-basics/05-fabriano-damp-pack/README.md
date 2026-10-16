# @Model basics · 05 · Fabriano damp pack

Chiara Fioravanti damps the sheets that will take the impressions: 80 sheets of cotton offcuts from the Prato mills, 42.5 percent damp, sized, on 9 March.

**What it teaches**

- `String`, `Int`, `Double`, `Bool`, and `Date` store as themselves.
- One model can carry that mix without an attribute wrapper.

**Files**

| File | Role |
| --- | --- |
| [`RagDampSlip.swift`](RagDampSlip.swift) | The damp slip and its screen |

**Try it**

Open Fabriano damp pack. Damp the pack, then change the sheet count and the damp percent. The slip is those five values.

`swift test` locks the five fields in `ragDampSlipStoresThePlainValueTypes`.
