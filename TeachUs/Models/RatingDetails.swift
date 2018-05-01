//
//  RatingDetails.swift
//  TeachUs
//
//  Created by ios on 4/21/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//


/*

 "criteria_list": [
 {
 "criteria_id": "1",
 "criteria": "Topic Knowledge",
 "description": "Lorem ipsum",
 "ratings": "10.0"
 }
 ]


*/

import Foundation
import ObjectMapper
class ProfessorRatingDetials:Mappable{
    
    var criteriaId:String = ""
    var criteria:String = ""
    var description:String = ""
    var ratings:String = ""

    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        self.criteriaId <- map["criteria_id"]
        self.criteria <- map["criteria"]
        self.description <- map["description"]
        self.ratings <- map["ratings"]
    }
    
}
