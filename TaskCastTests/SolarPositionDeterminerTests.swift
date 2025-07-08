import XCTest
@testable import TaskCast

final class SolarProgressTests: XCTestCase {

    let calendar = Calendar(identifier: .gregorian)

    func testProgressAtStart() {
        let start = "06:00 AM"
        let end = "06:00 PM"
        let referenceTime = makeDate(hour: 6, minute: 0)

        let progress = solarProgressBetween(start: start, end: end, referenceTime: referenceTime, calendar: calendar)
        XCTAssertEqual(progress, 0, accuracy: 0.0001)
    }

    func testProgressAtEnd() {
        let start = "06:00 AM"
        let end = "06:00 PM"
        let referenceTime = makeDate(hour: 18, minute: 0)

        let progress = solarProgressBetween(start: start, end: end, referenceTime: referenceTime, calendar: calendar)
        XCTAssertEqual(progress, 1)
    }

    func testProgressHalfway() {
        let start = "06:00 AM"
        let end = "06:00 PM"
        let referenceTime = makeDate(hour: 12, minute: 0)

        let progress = solarProgressBetween(start: start, end: end, referenceTime: referenceTime, calendar: calendar)
        XCTAssertEqual(progress, 0.5, accuracy: 0.01)
    }

    func testProgressBeforeStart() {
        let start = "06:00 AM"
        let end = "06:00 PM"
        let referenceTime = makeDate(hour: 5, minute: 0)

        let progress = solarProgressBetween(start: start, end: end, referenceTime: referenceTime, calendar: calendar)
        XCTAssertEqual(progress, 0)
    }

    func testProgressAfterEnd() {
        let start = "06:00 AM"
        let end = "06:00 PM"
        let referenceTime = makeDate(hour: 20, minute: 0)

        let progress = solarProgressBetween(start: start, end: end, referenceTime: referenceTime, calendar: calendar)
        XCTAssertEqual(progress, 1)
    }

    func testInvalidStartOrEndTime() {
        let invalidStart = "notATimeString"
        let invalidEnd = "notATimeString"
        let referenceTime = Date()

        XCTAssertEqual(solarProgressBetween(start: invalidStart, end: "06:00 PM", referenceTime: referenceTime, calendar: calendar), 0)
        XCTAssertEqual(solarProgressBetween(start: "06:00 AM", end: invalidEnd, referenceTime: referenceTime, calendar: calendar), 0)
        XCTAssertEqual(solarProgressBetween(start: invalidStart, end: invalidEnd, referenceTime: referenceTime, calendar: calendar), 0)
    }
    
    private func makeDate(hour: Int, minute: Int) -> Date {
        var gmtCalendar = Calendar(identifier: .gregorian)
        gmtCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var components = gmtCalendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        components.second = 0

        return gmtCalendar.date(from: components)!
    }

}
