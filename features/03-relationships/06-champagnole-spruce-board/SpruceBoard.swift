// Feature: Relationships
// Slot 06 — Champagnole spruce board
// Teaches:
// - @Relationship(.unique) keeps the wheel on one board.
// - A second board takes the wheel. The first board stays, with no wheel.

import SwiftData
import SwiftUI

@Model
final class BoardWheel {
    var code: String
    var board: SpruceBoard?

    init(code: String) {
        self.code = code
    }
}

@Model
final class SpruceBoard {
    var boardCode: String
    var millerName: String
    @Relationship(.unique, maximumModelCount: 1, inverse: \BoardWheel.board)
    var wheel: BoardWheel?

    init(boardCode: String, millerName: String) {
        self.boardCode = boardCode
        self.millerName = millerName
    }
}

struct SpruceBoardScreen: View {
    var body: some View {
        SpruceBoardEditor()
            .inMemoryStore(for: SpruceBoard.self, BoardWheel.self)
    }
}

private struct SpruceBoardEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var first: SpruceBoard?
    @State private var second: SpruceBoard?
    @State private var wheel: BoardWheel?
    @State private var laidSecond = false

    var body: some View {
        ScenarioChrome(
            kicker: "Relationships · 06",
            title: "Champagnole spruce board",
            situation: "On 6 September Marc Bouvet's mill sends boards SP-1 and SP-2 for wheel PL-19. The wheel can sit on only one of them.",
            teaches: [
                "@Relationship(.unique) keeps the wheel on one board.",
                "A second board takes the wheel. The first board stays, with no wheel."
            ]
        ) {
            if let first, let second, let wheel {
                BoardFields(
                    first: first,
                    second: second,
                    wheel: wheel,
                    schema: modelContext.container.schema,
                    laidSecond: laidSecond
                )
                if !laidSecond {
                    Button("Lay SP-2 under the wheel") {
                        second.wheel = wheel
                        laidSecond = true
                    }
                }
            } else {
                Button("Lay SP-1 under the wheel") {
                    layFirst()
                }
            }
        }
    }

    private func layFirst() {
        let wheel = BoardWheel(code: "PL-19")
        let first = SpruceBoard(boardCode: "SP-1", millerName: "Marc Bouvet")
        let second = SpruceBoard(boardCode: "SP-2", millerName: "Marc Bouvet")
        modelContext.insert(wheel)
        modelContext.insert(first)
        modelContext.insert(second)
        first.wheel = wheel
        self.wheel = wheel
        self.first = first
        self.second = second
    }
}

private struct BoardFields: View {
    let first: SpruceBoard
    let second: SpruceBoard
    let wheel: BoardWheel
    let schema: Schema
    let laidSecond: Bool

    private var link: Schema.Relationship? {
        StoredRelationship.named("wheel", on: "SpruceBoard", in: schema)
    }

    var body: some View {
        Section("Champagnole") {
            LabeledContent("Miller", value: first.millerName)
            LabeledContent("Unique", value: link?.isUnique == true ? "Yes" : "No")
            LabeledContent("Maximum", value: maximumText)
            LabeledContent("Wheel sits on", value: wheel.board?.boardCode ?? "None")
        }

        Section(first.boardCode) {
            LabeledContent("Wheel", value: first.wheel?.code ?? "None")
        }

        if laidSecond {
            Section(second.boardCode) {
                LabeledContent("Wheel", value: second.wheel?.code ?? "None")
            }
        }

        Section {
            Text("Chantal Vercel opens a card for Odile Marchand's supper.")
                .foregroundStyle(.secondary)
        }
    }

    private var maximumText: String {
        guard let maximum = link?.maximumModelCount else { return "None" }
        return "\(maximum)"
    }
}
