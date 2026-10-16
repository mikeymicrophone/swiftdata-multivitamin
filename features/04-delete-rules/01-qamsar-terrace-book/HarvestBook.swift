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
    private let container = MemoryStore.containerOrCrash(HarvestBook.self, RoseTicket.self)

    var body: some View {
        HarvestBookEditor()
            .modelContainer(container)
    }
}

private struct HarvestBookEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var book: HarvestBook?
    @State private var ticketLine = ""
    @State private var bookCount = -1

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
            if let book {
                BookFields(book: book, schema: modelContext.container.schema, ticketLine: ticketLine, bookCount: bookCount)
                if bookCount < 0 {
                    Button("Tear up the duplicate book") {
                        tearUp(book)
                    }
                }
            } else {
                Button("Open the terrace book") {
                    openBook()
                }
            }
        }
        .onAppear { modelContext.autosaveEnabled = false }
    }

    private func openBook() {
        let book = HarvestBook(deskName: "Upper terrace, Qamsar", clerkName: "Leila Amini")
        let ticket = RoseTicket(
            terraceName: "Upper terrace, Qamsar",
            growerName: "Leila Amini",
            baskets: 4,
            cutOn: GregorianDay.date(year: 2026, month: 5, day: 12, timeZoneIdentifier: "Asia/Tehran")
        )
        modelContext.insert(book)
        modelContext.insert(ticket)
        book.tickets.append(ticket)
        try? modelContext.save()
        self.book = book
    }

    private func tearUp(_ book: HarvestBook) {
        modelContext.delete(book)
        try? modelContext.save()
        let filed = ModelContext(modelContext.container)
        let tickets = (try? filed.fetch(FetchDescriptor<RoseTicket>())) ?? []
        let books = (try? filed.fetch(FetchDescriptor<HarvestBook>())) ?? []
        ticketLine = tickets.first.map { "\($0.baskets) baskets, book \( $0.book?.deskName ?? "empty")" } ?? "No ticket"
        bookCount = books.count
    }
}

private struct BookFields: View {
    let book: HarvestBook
    let schema: Schema
    let ticketLine: String
    let bookCount: Int

    var body: some View {
        Section(book.deskName) {
            LabeledContent("Clerk", value: book.clerkName)
            LabeledContent("Rule", value: ruleTitle)
        }
        if bookCount >= 0 {
            Section("Filed book") {
                LabeledContent("Books", value: "\(bookCount)")
                Text(ticketLine)
            }
        }
        Section {
            Text("Hossein Nazeri fills the first jar from cook QS-22.")
                .foregroundStyle(.secondary)
        }
    }

    private var ruleTitle: String {
        guard let rule = StoredRelationship.named("tickets", on: "HarvestBook", in: schema)?.deleteRule else {
            return "Missing"
        }
        return StoredRelationship.ruleTitle(rule)
    }
}
