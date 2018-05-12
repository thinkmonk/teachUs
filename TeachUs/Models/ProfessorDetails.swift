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
 
 
 ///NEW JSON
 "prof_list": [
 {
 "professor_id": "2",
 "subject_id": "3",
 "subject_name": "Operations Research",
 "subject_code": "OR",
 "f_name": "Jaimin",
 "m_name": "Chetan",
 "l_name": "Shah",
 "email": "shahjmn@gmail.com",
 "contact": "9773608085",
 "profile": "http://zilliotech.com/api/profile/195ac3a3f1c9a86.jpg",
 "rating_status": "1"
 },
 */

class ProfessorDetails:Mappable{
    
    var professorId:String = ""
    var professorName:String = ""
    var professorLastName:String = ""
    var subjectId:String = ""
    var subjectName:String = ""
    var isRatingSubmitted:String = ""
    var imageURL:String = ""
    
    var professorMiddleName:String = ""
    var subjectCode:String = ""
    var professorEmail:String = ""
    var contact:String = ""
    var professforFullname:String = ""
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.professorId <- map["professor_id"]
        self.professorName <- map["f_name"]
        self.professorLastName <- map["l_name"]
        self.subjectId <- map["subject_id"]
        self.subjectName <- map["subject_name"]
        self.isRatingSubmitted <- map["rating_status"]
        self.imageURL <- map["profile"]
        self.professorMiddleName <- map["m_name"]
        self.subjectCode <- map["subject_code"]
        self.professorEmail <- map["email"]
        self.contact <- map["contact"]
        self.professforFullname = self.professorName + " " + self.professorMiddleName + " " + self.professorLastName
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
/*
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
 
 */

