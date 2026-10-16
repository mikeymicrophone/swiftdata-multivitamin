# Transient · 08 · Bedesten price

On 9 April Aylin Şahin raises pipe EB-7 from 4000 lira to 4500 and writes to hold it for Emre.

**What it teaches**

- The price is filed. The aside is not.
- The open card still says hold it for Emre.

**Files**

| File | Role |
| --- | --- |
| [`BedestenPrice.swift`](BedestenPrice.swift) | The price screen. The card type lives with the bedesten aside |

**Try it**

Open Bedesten price. Open the counter card, then rewrite the price. This card keeps the aside. The filed card shows 4500 lira and an empty aside.

`swift test` locks the filed price in `priceIsFiledAndTheAsideIsNot`.
