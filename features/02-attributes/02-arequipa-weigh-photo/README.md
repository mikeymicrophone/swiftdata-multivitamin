# Attributes · 02 · Arequipa weigh photo

On 10 June Raúl Mamani weighs the Lucanas fleece at Lavadero Mamani: lot AQ-10, 1.25 kg. The scale-face bytes are marked `@Attribute(.externalStorage)`.

**What it teaches**

- `.externalStorage` marks a `Data` property to be kept outside the row.
- After a save, a new context reads the same bytes back.

**Files**

| File | Role |
| --- | --- |
| [`WeighTicket.swift`](WeighTicket.swift) | The weigh ticket, the scale-face bytes, and the screen |

**Try it**

Open Arequipa weigh photo. Keep the scale face. The screen shows the byte count and that the photo sits outside the row.

`swift test` locks the round trip in `weighPhotoRoundTripsOutsideTheRow`.
