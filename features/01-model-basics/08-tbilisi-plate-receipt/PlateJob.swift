// Feature: @Model basics
// Slot 08 — Tbilisi plate receipt
// Teaches:
// - persistentModelID identifies the record.
// - Changing a stored property does not change that identity.

import SwiftData
import SwiftUI

@Model
final class PlateJob {
    var jobCode: String
    var plateCode: String
    var state: String
    var keeperName: String

    init(jobCode: String, plateCode: String, state: String, keeperName: String) {
        self.jobCode = jobCode
        self.plateCode = plateCode
        self.state = state
        self.keeperName = keeperName
    }
}

struct PlateJobScreen: View {
    var body: some View {
        PlateJobEditor()
            .inMemoryStore(for: PlateJob.self)
    }
}

private struct PlateJobEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var job: PlateJob?
    @State private var identityAtOpening = ""

    var body: some View {
        ScenarioChrome(
            kicker: "@Model basics · 08",
            title: "Tbilisi plate receipt",
            situation: "Mariam Gelashvili opens the job card that travelled in crate VR-14. She marks HV-6 received. The card's identity stays on the nail.",
            teaches: [
                "persistentModelID identifies the record.",
                "Changing a stored property does not change that identity."
            ]
        ) {
            if let job {
                PlateJobFields(job: job, identityAtOpening: identityAtOpening)
            } else {
                Button("Receive the plate job") {
                    receiveJob()
                }
            }
        }
    }

    private func receiveJob() {
        let job = PlateJob(
            jobCode: "HV-6",
            plateCode: "HV-6",
            state: "bitten",
            keeperName: "Mariam Gelashvili"
        )
        modelContext.insert(job)
        identityAtOpening = String(describing: job.persistentModelID)
        self.job = job
    }
}

private struct PlateJobFields: View {
    @Bindable var job: PlateJob
    let identityAtOpening: String

    private var identityNow: String {
        String(describing: job.persistentModelID)
    }

    var body: some View {
        Section(job.jobCode) {
            LabeledContent("Keeper", value: job.keeperName)
            LabeledContent("Plate", value: job.plateCode)
            Picker("State", selection: $job.state) {
                Text("bitten").tag("bitten")
                Text("in the Works on Paper room").tag("in the Works on Paper room")
            }
        }

        Section("Identity on the nail") {
            Text(identityNow == identityAtOpening ? "The job identity is unchanged." : "The job identity changed.")
            Text(identityNow)
                .font(.caption.monospaced())
                .textSelection(.enabled)
        }
    }
}
