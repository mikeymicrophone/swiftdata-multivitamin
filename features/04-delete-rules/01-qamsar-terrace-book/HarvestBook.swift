// Feature: Delete rules
// Slot 01 — Qamsar terrace book
// Teaches:
// - A relationship with no delete rule stores nullify.
// - Tearing up the book leaves the harvest ticket, with an empty book line.

import SwiftData
import SwiftUI

@Model
final class RoseTicket {
    var terraceName: String
    var growerName: String
    var baskets: Int
    var cutOn: Date
    var book: HarvestBook?

    init(terraceName: String, growerName: String, baskets: Int, cutOn: Date) {
        self.terraceName = terraceName
        self.growerName = growerName
        self.baskets = baskets
        self.cutOn = cutOn
    }
}

@Model
final class HarvestBook {
    var deskName: String
    var clerkName: String
    @Relationship(inverse: \RoseTicket.book)
    var tickets: [RoseTicket] = []

    init(deskName: String, clerkName: String) {
        self.deskName = deskName
        self.clerkName = clerkName
    }
}

struct HarvestBookScreen: View {
    var body: some View {
        HarvestBookEditor()
            .inMemoryStore(for: HarvestBook.self, RoseTicket.self)
    }
}

private struct HarvestBookEditor: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [HarvestBook]
    @Query(sort: [SortDescriptor(\RoseTicket.cutOn, order: .reverse)]) private var tickets: [RoseTicket]
    @State private var tornUp = false

    var body: some View {
        ScenarioChrome(
            kicker: "Delete rules · 01",
            title: "Qamsar terrace book",
            situation: "On 12 May Leila Amini's terrace book lists four baskets from the upper terrace in Qamsar. A duplicate book is torn up. The ticket stays.",
            teaches: [
                "A relationship with no delete rule stores nullify.",
                "Tearing up the book leaves the harvest ticket, with an empty book line."
            ]
        ) {
            if books.isEmpty && !tornUp {
                Button("Open the terrace book", action: openBook)
            } else {
                Section("Books · rule \(ruleTitle)") {
                    ForEach(books) { book in
                        HStack {
                            LabeledContent(book.deskName, value: book.clerkName)
                            Button("Tear up", systemImage: "trash", role: .destructive) {
                                tearUp(book)
                            }
                            .labelStyle(.iconOnly)
                        }
                    }
                    if books.isEmpty {
                        Text("No books on the desk.")
                            .foregroundStyle(.secondary)
                    }
                }
                Section("Tickets") {
                    ForEach(tickets) { ticket in
                        LabeledContent(ticket.terraceName) {
                            Text("\(ticket.baskets) baskets, book \(ticket.book?.deskName ?? "empty")")
                        }
                    }
                }
            }
            Section {
                Text("Hossein Nazeri fills the first jar from cook QS-22.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var ruleTitle: String {
        guard let rule = StoredRelationship.named("tickets", on: "HarvestBook", in: modelContext.container.schema)?.deleteRule else {
            return "missing"
        }
        return StoredRelationship.ruleTitle(rule).lowercased()
    }

    private func openBook() {
        let book = HarvestBook(deskName: "Upper terrace, Qamsar", clerkName: "Leila Amini")
        modelContext.insert(book)
        book.tickets.append(RoseTicket(
            terraceName: "Upper terrace, Qamsar",
            growerName: "Leila Amini",
            baskets: 4,
            cutOn: GregorianDay.date(year: 2026, month: 5, day: 12, timeZoneIdentifier: "Asia/Tehran")
        ))
        try? modelContext.save()
    }

    private func tearUp(_ book: HarvestBook) {
        modelContext.delete(book)
        try? modelContext.save()
        tornUp = true
    }
}
