//
//  ProfessorDetails.swift
//  TeachUs
//
//  Created by ios on 11/21/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 
 {
 "professorWise": [
 {
 "professorId": 4,
 "professorName": "Nitin",
 "professorLastName": "Mante",
 "subjectId": 2,
 "subjectName": "ECONOMICS",
 "isRatingSubmitted": "false"
 }
 ]
 }
 */

class ProfessorDetails:Mappable{
    
    var professorId:Int?
    var professorName:String?
    var professorLastName:String?
    var subjectId:String?
    var subjectName:String?
    var isRatingSubmitted:String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.professorId <- map["professorId"]
        self.professorName <- map["professorName"]
        self.professorLastName <- map["professorLastName"]
        self.subjectId <- map["subjectId"]
        self.subjectName <- map["subjectName"]
        self.isRatingSubmitted <- map["isRatingSubmitted"]
    }
}

/*
 "lookUpRatingCriteria": {
 "teacherRating": [
 {
 "criteriaId": 1,
 "criteria": "Topic Knowledge",
 "rating": "10",
 "description": "It refers to the familiarity, awareness, and understanding of the teacher with reference to the teaching subject. Please rate the teacher based on his/her subject knowledge."
 },]
 }
  }
 */

class RatingDetails:Mappable{
    var criteriaId:Int?
    var criteria:String?
    var rating:String?
    var description:String?
    
    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        self.criteriaId <- map["criteriaId"]
        self.criteria <- map["criteria"]
        self.rating <- map["rating"]
        self.description <- map["description"]
    }
}

