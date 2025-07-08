import Foundation

public extension Date {
    func isSame(_ component: Calendar.Component,
                as other: Date,
                calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: other, toGranularity: component)
    }
    
    func isSameDay(as other: Date, calendar: Calendar = .current) -> Bool {
        isSame(.day, as: other, calendar: calendar)
    }
    
    func dayMonthString(locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "d MMM"
        return formatter.string(from: self)
    }
}
