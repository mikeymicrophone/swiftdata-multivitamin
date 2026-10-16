# Delete rules · 05 · Kashan seal chit

On 15 May Farhad Golshan writes a seal chit in the Kashan bazaar copper row for cook QS-22.

**What it teaches**

- The cascade sits on the chit.
- Voiding the chit deletes the cook it warrants.

**Files**

| File | Role |
| --- | --- |
| [`SealChit.swift`](SealChit.swift) | The chit, the cook, and the screen |

**Try it**

Open Kashan seal chit. Write the chit, void it, and read both counts.

`swift test` locks the vanished cook in `voidingTheSealChitDeletesTheCook`.
