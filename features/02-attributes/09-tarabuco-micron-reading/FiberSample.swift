// Feature: Attributes
// Slot 09 — Tarabuco micron reading
// Teaches:
// - @Attribute(.transformable) names a ValueTransformer for a custom class.
// - transformedValueClass() returns that class, and the reading survives a save.

import SwiftData
import SwiftUI

@objc(MicronReading)
final class MicronReading: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool { true }
    let meanMicrons: Double

    init(meanMicrons: Double) {
        self.meanMicrons = meanMicrons
    }

    func encode(with coder: NSCoder) {
        coder.encode(meanMicrons, forKey: "meanMicrons")
    }

    required init?(coder: NSCoder) {
        meanMicrons = coder.decodeDouble(forKey: "meanMicrons")
    }
}

@objc(MicronReadingTransformer)
final class MicronReadingTransformer: ValueTransformer {
    static let transformerName = NSValueTransformerName("MicronReadingTransformer")

    // The attribute's stored class is MicronReading. Returning NSData here makes insert fail.
    override class func transformedValueClass() -> AnyClass { MicronReading.self }
    override class func allowsReverseTransformation() -> Bool { true }

    static func register() {
        ValueTransformer.setValueTransformer(MicronReadingTransformer(), forName: transformerName)
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let reading = value as? MicronReading else { return nil }
        return try? NSKeyedArchiver.archivedData(withRootObject: reading, requiringSecureCoding: true)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: MicronReading.self, from: data)
    }
}

@Model
final class FiberSample {
    var sampleCode: String
    var weaverName: String
    var workshopName: String
    @Attribute(.transformable(by: MicronReadingTransformer.self)) var reading: MicronReading
    var sampledOn: Date

    init(sampleCode: String, weaverName: String, workshopName: String, reading: MicronReading, sampledOn: Date) {
        self.sampleCode = sampleCode
        self.weaverName = weaverName
        self.workshopName = workshopName
        self.reading = reading
        self.sampledOn = sampledOn
    }
}

struct FiberSampleScreen: View {
    init() {
        MicronReadingTransformer.register()
    }

    var body: some View {
        FiberSampleEditor()
            .inMemoryStore(for: FiberSample.self)
    }
}

private struct FiberSampleEditor: View {
    @Environment(\.modelContext) private var modelContext
    @State private var sample: FiberSample?

    var body: some View {
        ScenarioChrome(
            kicker: "Attributes · 09",
            title: "Tarabuco micron reading",
            situation: "On 16 June Edwin Cruz records the mean fiber diameter before he warps the shawl. The reading is a MicronReading, stored through MicronReadingTransformer.",
            teaches: [
                "@Attribute(.transformable) names a ValueTransformer for a custom class.",
                "transformedValueClass() returns that class, and the reading survives a save."
            ]
        ) {
            if let sample {
                SampleFields(sample: sample, schema: modelContext.container.schema)
            } else {
                Button("Record the microns") {
                    record()
                }
            }
        }
    }

    private func record() {
        let sample = FiberSample(
            sampleCode: "TB-16",
            weaverName: "Edwin Cruz",
            workshopName: "Tarabuco",
            reading: MicronReading(meanMicrons: 12.5),
            sampledOn: GregorianDay.date(year: 2026, month: 6, day: 16, timeZoneIdentifier: "America/La_Paz")
        )
        modelContext.insert(sample)
        self.sample = sample
    }
}

private struct SampleFields: View {
    let sample: FiberSample
    let schema: Schema

    private var transformable: Bool {
        StoredAttribute.named("reading", on: "FiberSample", in: schema)?.isTransformable == true
    }

    var body: some View {
        Section(sample.workshopName) {
            LabeledContent("Weaver", value: sample.weaverName)
            LabeledContent("Sample", value: sample.sampleCode)
            LabeledContent("Mean", value: "\(sample.reading.meanMicrons.formatted(.number.precision(.fractionLength(1)))) microns")
            LabeledContent("Transformer", value: transformable ? "MicronReadingTransformer" : "Unmarked")
        }

        Section {
            Text("Mariela Rojas will receive the finished shawl at Casa Rojas in La Paz.")
                .foregroundStyle(.secondary)
        }
    }
}
