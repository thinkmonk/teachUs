//
//  ApplicationTabs.swift
//  TeachUs
//
//  Created by iOS on 05/04/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation

// MARK: - ApplicationTabs
class ApplicationTabs: Codable {
    var userControls: [UserControl] = []
    var selecetedIdString : String{//        let selectedClassIdArray: [String] = selectedAdminClassArray.map({$0.collegeClass?.classId ?? ""})

        let selectedControlsArray =  self.userControls.filter({$0.isSelected == true})
        let selectedControls:[String] = selectedControlsArray.map({($0.id ?? "")})
        var idString = selectedControls.joined(separator: ",")
        return idString.count > 0 ? idString : "0"
        
    }
    enum CodingKeys: String, CodingKey {
        case userControls = "user_controls"
    }
}

// MARK: - UserControl
class UserControl: Codable {
    var id: String?
    var user: String?
    var isSelected:Bool = false
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user = "user"
    }
}
