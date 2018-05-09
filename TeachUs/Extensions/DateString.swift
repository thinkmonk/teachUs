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
}
