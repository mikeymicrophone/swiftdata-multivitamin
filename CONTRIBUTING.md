# Contributing to SwiftData Multivitamin

Every scenario in this catalog follows the same conventions. The reference
scenario, [@Model basics · 01 · Tbilisi quince commission](features/01-model-basics/01-tbilisi-quince-commission/),
follows all of them; copy its shape when you add a new one.

## The rules

### 1. Real names, always

This rule is not negotiable. Every model, property, method, file, folder,
and string a reader sees gets a name that means something in the scenario's
domain.

Never use `foo`, `bar`, `baz`, `qux`, `hello`, `helloWorld`, `example`,
`demo`, `test`, `thing`, `item1`, `myModel`, `someValue`, `data`, `x`, or
similar stand-ins. If you are tempted to write one, the scenario is not
concrete enough yet.

| Instead of | Write |
| --- | --- |
| `class Item` | `class QuinceCommission` |
| `var name: String` | `var studyTitle: String` |
| `var count: Int` | `var plateCount: Int` |
| `Button("Submit")` | `Button("Open the commission")` |

Content counts too: use believable sample data (a plate count, a damp
percent, a price in lari), not lorem ipsum.

Test files may use Swift Testing. Inside the test, the names are still the
scenario's names.

### 2. One chain of thirteen per feature

Each feature's thirteen scenarios are one chain of events. A supplier, a
workshop, a haulier, and a shop (or the same kinds of desks) hand work
onward. Dates and names should make the previous slip matter to the next
one.

Each feature gets its own chain. Do not stretch the Tbilisi quince-plate
order across the whole catalog.

Pick a scenario where the feature is the natural tool, not one bent to fit
it. The thirteen slots should each show the feature in a different shape.

Skip flight (that belongs to phoenix-multivitamin), lighthouses, maritime
work, and the Puget Sound. Do not reuse a scenario name or a desk from
stimulus-multivitamin, rubyllm-multivitamin, or phoenix-multivitamin.
Prefer places outside the United States. Keep the institutions varied.

### 3. A runnable SwiftUI screen

Every scenario includes a small SwiftUI view. The catalog app is the
runner: one screen per scenario, each with its own in-memory store. The
chain is the story and the field values, not one shared database.

Order the thirteen slots roughly from moderate to complex. Other SwiftData
features may appear when a real desk would use them, but the folder's
feature must be the star.

### 4. A short comment header that says what it teaches

- The Swift file opens with a comment: the feature, slot number, and
  scenario title, followed by a short "Teaches:" list.
- The scenario's `README.md` repeats that list, plus a table of files and
  a "Try it" section.

Inside the code, comment only on constraints the code cannot show. Do not
narrate what the next line does.

### 5. A test that locks the lesson

Each bottled scenario has a test that fails if the lesson regresses. Prefer
the model and the schema over the view hierarchy. Run `swift test`.

### 6. Thirteen per feature, and a quirked-safe folder

A slot is bottled when its folder contains the Swift file, a README, and a
test that exercises it. Until then the feature is listed with an empty
scenario list.

A future `quirked` branch will keep every SwiftData technique and the same
thirteen-per-feature structure, but swap the scenarios for more obscure
subject matter: still readable and real, never gibberish. Rule 1 applies
there too.

To make that reskin a matter of renaming rather than restructuring:

- Scenario-specific names, copy, and sample data live in that scenario's
  folder, not in `App/`.
- `App/` holds the catalog shell, the day helper, and the in-memory store.
  Those files should not mention a museum, a mill, or a plate.
- Put the SwiftData lesson in the structure (which types exist, what the
  test asserts), not in domain details, so a new domain can map onto the
  same structure one name at a time.

The catalog index in `App/Catalog.swift` lists titles the way the root
README does. That list is the index, not shared scenario logic.

## Adding a scenario

1. Pick the next open feature, or the next open slot if a chain is already
   started. Design the thirteen titles as one chain before bottling the
   first slot.
2. Create the scenario folder: a Swift file with the model and the screen,
   and a README.
3. Register the screen in `App/CatalogView.swift` and the title in
   `App/Catalog.swift`.
4. Exclude the scenario README from the executable target in `Package.swift`.
   Root Markdown files are excluded there too; add a new one to that list.
5. Add the test. Run `swift test`.
6. Update the bottled counts in the feature README and the root README.

## Building

`swift test` and `swift run SwiftDataMultivitamin` need the macOS SDK and
Xcode. The package targets macOS 14.
