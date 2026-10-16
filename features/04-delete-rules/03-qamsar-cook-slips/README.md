# Delete rules · 03 · Qamsar cook slips

On 14 May two slips hang on cook QS-22: clear, and a long rose. Hossein voids the cook card.

**What it teaches**

- `.cascade` on the cook deletes the slips with the cook.
- A new context finds no cook and no slips.

**Files**

| File | Role |
| --- | --- |
| [`CookBatch.swift`](CookBatch.swift) | The cook, the slips, and the screen |

**Try it**

Open Qamsar cook slips. Hang the slips, then void the cook. The save runs in `do`/`catch`; a refused save rolls the context back. Both counts come from `fetchCount` on a new context.

`swift test` locks the empty book in `voidingTheCookDeletesTheSlips`.
