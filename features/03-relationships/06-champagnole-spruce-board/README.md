# Relationships · 06 · Champagnole spruce board

On 6 September Marc Bouvet sends boards SP-1 and SP-2 for wheel PL-19. The wheel sits on SP-1, then SP-2 takes it. SP-1 remains, with no wheel.

**What it teaches**

- `@Relationship(.unique)` with `maximumModelCount` 1 keeps the wheel on one board.
- The second assignment clears the first board. The save keeps both boards.

**Files**

| File | Role |
| --- | --- |
| [`SpruceBoard.swift`](SpruceBoard.swift) | The boards, the wheel, and the screen |

**Try it**

Open Champagnole spruce board. Lay SP-1, then lay SP-2, and read which board holds PL-19.

`swift test` locks the move in `secondBoardTakesTheWheelAndTheFirstBoardRemains`.
