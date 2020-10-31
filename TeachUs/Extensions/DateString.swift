//
//  DateString.swift
//  TeachUs
//
//  Created by ios on 11/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation

extension String {
    func getDateFromString() -> String{
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        return dateFormatter.string(from: date)
    }
    
    func getFormaatedDate(format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = format //dd MMM yyyy
        return dateFormatter.string(from: date)

    }
    
    func timeToDate(format:String,for dateObj:Date = Date()) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let dateWithTime = dateFormatter.date(from: self) else {
            print("Date Conversion Failed")
            return Date()
        }
        dateFormatter.timeZone = TimeZone.current
        let calendare = Calendar.current
        let actualDate = calendare.dateComponents([.hour, .minute, .second], from: dateWithTime)
        let hour = actualDate.hour ?? 0
        let mins = actualDate.minute ?? 0
        let secs = actualDate.second ?? 0
        return Calendar.current.date(bySettingHour: hour, minute: mins, second: secs, of: dateObj) ?? Date()

    }
}
