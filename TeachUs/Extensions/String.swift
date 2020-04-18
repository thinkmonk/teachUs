//
//  String.swift
//  TeachUs
//
//  Created by ios on 4/6/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation

extension String{
    func isValidEmailAddress() -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func convertToDate() -> Date? {
        let strDate = self
        print(strDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strDate)
        return date ?? Date()
    }
    
    func convertTimeStringToDate() -> Date? {
        let strDate = self
        print(strDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        let date = dateFormatter.date(from: strDate)
        return date ?? Date()

    }
    
    func addColorForString(_ string:String, stringColor:UIColor) -> NSAttributedString{
        
        let range = (self.lowercased() as NSString).range(of: string.lowercased())
        let attribute = NSMutableAttributedString.init(string: self)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: stringColor , range: range)
        return attribute
    }
    
    func decodedString() -> String {
        return replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? ""
    }

    func encodedString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .letters) ?? ""
    }
    
    func addHyphenToString() -> String{
        return self != "" ? " - " + self : ""
    }
}

extension Optional where Wrapped == String{
    func addHyphenToString() -> String{
        guard let `self` = self else{
            return ""
        }
        return self != "" ? " - " + self : ""
    }
}
