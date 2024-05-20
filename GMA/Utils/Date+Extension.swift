//
//  Date+Extension.swift
//  GMA
//
//  Created by Hoan Nguyen on 31/01/2023.
//

import Foundation

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func diffHour (toDate: Date) -> Int{
        let diffComponents = Calendar.current.dateComponents([.hour], from: self, to: toDate)
        if let hour = diffComponents.hour {
            return hour
        }
        return 0
    }
    
    func distanceAs(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distanceAs(from: date, only: component) == 0
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func isEndOfMonthDay() -> Bool {
        return self.hasSame(.day, as: self.endOfMonth())
    }
    
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func combineWithTime(timeInput: Date?) -> Date? {
        if let time = timeInput {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = AppContants.dateFormatLogic
            let dateStr = dateFormat.string(from: self)
            
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = AppContants.timeFormatLogic
            let timeStr = timeFormat.string(from: time)
            let dateAndTime = dateStr + " " + timeStr
            
            let fullDateFormat = DateFormatter()
            fullDateFormat.dateFormat = AppContants.dateFormatLogic + " " + AppContants.timeFormatLogic
            let fullDate = fullDateFormat.date(from: dateAndTime)
            return fullDate
        }
        return nil
    }
}
