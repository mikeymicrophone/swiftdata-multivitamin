# SwiftData Multivitamin

Thirteen samples of healthy code for each feature of SwiftData. This is the
SwiftData sibling of
[Stimulus Multivitamin](https://github.com/mikeymicrophone/stimulus-multivitamin).

| Supplement Facts | |
| --- | --- |
| Serving size | 1 scenario |
| Servings per feature | 13 |
| Features | 21 |
| Scenarios | 273 |
| Bottled | 39 |
| Active ingredient | SwiftData (macOS 14 API) |
| Catalog | One SwiftUI screen per scenario |

## Why

The official SwiftData docs explain each feature well, but most of their
snippets are deliberately small: a trip, a friend, a bucket list. That is
enough to learn the macro and not enough to see how a feature holds up
inside a real desk.

SwiftData Multivitamin is a catalog of realistic scenarios. Each feature
gets thirteen of them, in one chain of events, so you can watch the same
feature carry a job from one desk to the next.

Every scenario uses real, domain-meaningful names. You will not find
placeholder names here.

The bottle is not full yet: 21 features, 13 scenarios each, 39 of 273 bottled.
@Model basics, attributes, and relationships are full. The other features are named and waiting.

## Run the catalog

```sh
swift test
swift run SwiftDataMultivitamin
```

`swift test` checks the bottled scenarios. `swift run` opens the catalog.
Each bottled scenario is one screen, with its own in-memory store. The
chain is the story and the field values, not one shared database.

The app targets macOS 14. This chunk was built and tested with Xcode 27
on this machine.

## Layout

```
App/                               catalog shell and the in-memory store helper
features/
  01-model-basics/
    README.md                      the chain and its 13 slots
    01-tbilisi-quince-commission/
      QuinceCommission.swift      the model and its SwiftUI screen
      README.md
```

## Features

1. [@Model basics](features/01-model-basics/) — 13 of 13 bottled
2. [Attributes](features/02-attributes/) — 13 of 13 bottled
3. [Relationships](features/03-relationships/) — 13 of 13 bottled
4. Delete rules
5. @Transient
6. Codable and enum properties
7. ModelContainer and ModelConfiguration
8. ModelContext — insert, save, autosave, rollback
9. @Query
10. #Predicate
11. FetchDescriptor — sort, limit, offset, properties to fetch
12. #Index and #Unique
13. Model inheritance
14. @ModelActor background work
15. Undo
16. Schema migrations — VersionedSchema, MigrationPlan
17. CloudKit sync
18. History tracking
19. SwiftUI integration and previews
20. Widgets and App Intents
21. Core Data coexistence — the same store through Core Data APIs

The reference scenario that later ones copy is
[@Model basics · 01 · Tbilisi quince commission](features/01-model-basics/01-tbilisi-quince-commission/).

## Discoveries

Behaviors the official docs don't mention, found while building these
scenarios, go in [DISCOVERIES.md](DISCOVERIES.md). Nothing is written there
until a test has shown it.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © Mike Schwab
