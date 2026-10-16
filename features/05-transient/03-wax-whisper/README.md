# Transient · 03 · Wax whisper

On 4 April Yusuf Demir cooks wax lot WX-7 and whispers that it should run cooler than yesterday.

**What it teaches**

- The whisper is optional and has no default value.
- A new context reads nil. The lot code is WX-7.

**Files**

| File | Role |
| --- | --- |
| [`WaxCook.swift`](WaxCook.swift) | The wax card and its screen |

**Try it**

Open Wax whisper. Open the card, then file the lot. This card keeps the whisper. The filed card shows WX-7 and unspoken.

`swift test` locks the nil whisper in `whisperComesBackNil`.
