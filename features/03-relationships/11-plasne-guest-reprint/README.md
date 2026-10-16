# Relationships · 11 · Plasne guest reprint

On 11 September Lucien Morel reprints the guest book. Antoine Gaillard is still the guest. The reprint marks the guest list.

**What it teaches**

- `hashModifier` on the guest relationship is `guest-book-2026`.
- The member list and the inverse `visit` leave `hashModifier` nil.

**Files**

| File | Role |
| --- | --- |
| [`GuestReprint.swift`](GuestReprint.swift) | The reprint screen |
| [`../03-plasne-member-book/CoopRoll.swift`](../03-plasne-member-book/CoopRoll.swift) | The member book and the hands |

**Try it**

Open Plasne guest reprint. Reprint the book and read the three hash lines.

`swift test` locks the hash in `guestReprintStoresTheHashOnTheGuestList`.
