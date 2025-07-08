import Foundation

// This is needed to calculate the sun's percentage position since the API does not provide this data
public func solarProgressBetween(
    start: String,
    end: String,
    referenceTime: Date,
    calendar: Calendar = .current
) -> CGFloat {
    let fmt = DateFormatter()
    fmt.dateFormat = "hh:mm a"
    fmt.locale = Locale(identifier: "en_US_POSIX")
    fmt.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard
        let startTime = fmt.date(from: start),
        let endTime   = fmt.date(from: end)
    else { return 0 }
    
    let today = calendar.dateComponents([.year, .month, .day], from: referenceTime)
    guard
        let startTime = calendar.date(bySettingHour: calendar.component(.hour,   from: startTime),
                                      minute:        calendar.component(.minute, from: startTime),
                                      second: 0,
                                      of: calendar.date(from: today)!),
        let endTime   = calendar.date(bySettingHour: calendar.component(.hour,   from: endTime),
                                      minute:        calendar.component(.minute, from: endTime),
                                      second: 0,
                                      of: calendar.date(from: today)!)
    else { return 0 }
    
    let clampedRef = min(max(referenceTime, startTime), endTime)
    
    let total   = endTime.timeIntervalSince(startTime)
    let soFar   = clampedRef.timeIntervalSince(startTime)
    
    return total > 0 ? soFar / total : 0
}
