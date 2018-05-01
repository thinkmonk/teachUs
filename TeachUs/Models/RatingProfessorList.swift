//
//  RatingProfessorList.swift
//  TeachUs
//
//  Created by ios on 4/21/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

/*
 
 
 {
 "prof_list":
     [
         {
             "professor_id": "2",
             "f_name": "Jaimin",
             "l_name": "Shah",
             "m_name": "Chetan",
             "subject_code": "OR",
             "subject_id": "3",
             "subject_name": "Operations Research",
             "ratings": "7.1",
             "popularity": "2"
         }
     ]
 }
 
 */


import Foundation
import ObjectMapper


class RatingProfessorList: Mappable {
   
    
    var professorId:String = ""
    var firstName:String = ""
    var middleName:String = ""
    var lastName:String = ""
    var subjectCode:String = ""
    var subjectId:String = ""
    var subjectName:String = ""
    var ratings:String = ""
    var popularity:String = ""
    var imageUrl:String = ""
    
    var fullname:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.professorId <- map["professor_id"]
        self.firstName <- map["f_name"]
        self.middleName <- map["m_name"]
        self.lastName <- map["l_name"]
        self.subjectCode <- map["subject_code"]
        self.subjectId <- map["subject_id"]
        self.subjectName <- map["subject_name"]
        self.ratings <- map["ratings"]
        self.popularity <- map["popularity"]
        self.imageUrl <- map[""]
        
        self.fullname = "\(self.firstName) \(self.middleName) \(self.lastName)"
     }
    
}
