//
//  Array.swift
//  TeachUs
//
//  Created by ios on 3/4/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

extension Array where Element: Equatable{
    
    mutating func remove(object: Element) {
        var index: Int?
        for (idx, objectToCompare)  in enumerated() {
            if let to = objectToCompare as Element! {
                if object == to {
                    index = idx
                }
            }
        }
        if(index != nil) {
            self.remove(at: index!)
        }
    }
}
