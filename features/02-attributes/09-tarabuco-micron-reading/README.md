# Attributes · 09 · Tarabuco micron reading

On 16 June Edwin Cruz records a mean of 12.5 microns on sample TB-16 before he warps the shawl. The reading is a `MicronReading`, archived by `MicronReadingTransformer`.

**What it teaches**

- `@Attribute(.transformable(by:))` names the transformer. The schema reports the attribute as transformable.
- `transformedValueClass()` returns `MicronReading`. The reading is still 12.5 after a save and a fetch.

**Files**

| File | Role |
| --- | --- |
| [`FiberSample.swift`](FiberSample.swift) | The reading, the transformer, the sample, and the screen |

**Try it**

Open Tarabuco micron reading. Record the microns. The screen shows 12.5 and the transformer name.

`swift test` locks the round trip in `micronReadingSurvivesTheTransformer`.
