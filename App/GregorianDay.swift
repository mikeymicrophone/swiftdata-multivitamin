import Foundation

enum GregorianDay {
    static func date(year: Int, month: Int, day: Int, timeZoneIdentifier: String) -> Date {
        let timeZone = TimeZone(identifier: timeZoneIdentifier) ?? TimeZone(secondsFromGMT: 0)!
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let components = DateComponents(year: year, month: month, day: day, hour: 12)
        return calendar.date(from: components)!
    }
}
