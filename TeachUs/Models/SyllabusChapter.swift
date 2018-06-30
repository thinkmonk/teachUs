//
//  SyllabusChapter.swift
//  TeachUs
//
//  Created by ios on 11/17/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper


/*
 
 //SUBJECT NEW
 {
 "syllabus_subject_list": [
 {
 "subject_id": "3",
 "subject_code": "OR",
 "subject_name": "Operations Research",
 "class_id": "1",
 "course_name": "FYBMS",
 "class_division": "A",
 "total_lectures": "27",
 "syllabus_percentage": "39"
 },
 
 }
 
 "unit_syllabus_array": [
 {
 "unit_name": "Unit 01",
 "unit_id": "1",
 "topic_list": [
 {
 "topic_name": "LPP Graphical",
 "topic_id": "1",
 "topic_description": "",
 "status": "2"
 },
 {
 "topic_name": "LPP Simplex",
 "topic_id": "2",
 "topic_description": "",
 "status": "2"
 }
 ]
 },
 
 
 
 
 
 {
 "subjectWise": [
 {
 "subjectId": 2,
 "subjectName": "ECONOMICS",
 "numOfLecture": 1,
 "completion": "33%",
 "topicWise": [
 {
 "topicId": 8,
 "unitNumber": "UNIT3",
 "unitName": "Unit Third",
 "chapterWise": [
 {
 "chapterId": 7,
 "chapterNumber": "CHAPTER 01",
 "chapterNamme": "Transmiision",
 "status": "NOTSTARTED"
 }
 ]}
 }
 }
 
 */

class Unit:Mappable{
    
    var unitId:String = ""
    var unitName:String = ""
    var unitNumber:String = ""
    var topicArray:[Chapter]? = []
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.unitId <- map["unit_id"]
        self.unitName <- map["unit_name"]
        var chaptersArray:[[String:Any]] = []
        chaptersArray <- map["topic_list"]
        
        if(chaptersArray.count > 0){
            for chapter in chaptersArray {
                let tempChapter = Mapper<Chapter>().map(JSON: chapter)
                self.topicArray?.append(tempChapter!)
            }
        }
    }
}


class Chapter:Mappable{
    
    var chapterName:String = ""
    var chapterId:String = ""
    var chapterDescription:String = ""
    var chapterNumber:String = ""
    var status:String = ""
    var isUpdated:Bool = false
    
    
    var setChapterStatus:String? = "Not Started"
    var chapterStatusTheme :SyllabusCompletetionType! = .NotStarted
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.chapterName <- map["topic_name"]
        self.chapterId <- map["topic_id"]
        self.chapterDescription <- map["topic_description"]
        if(map.JSON["status"] != nil){
            self.status <- map["status"]
        }else{
            self.status = ""
        }
        switch self.status {//status 2 is for completed topic / 1 is for inprogress
        case "0":
            self.chapterStatusTheme = SyllabusCompletetionType.NotStarted
            self.setChapterStatus = "Not Started"
            break
        case "1":
            self.chapterStatusTheme = SyllabusCompletetionType.InProgress
            self.setChapterStatus = "In Progess"
            break
        case "2":
            self.chapterStatusTheme = SyllabusCompletetionType.Completed
            self.setChapterStatus = "Completed"
            break
        default:
            break
        }
    }
}


/*
 
 {
 "class_division" = A;
 "class_id" = 1;
 "course_name" = TYBMS;
 "subject_code" = IEM;
 "subject_id" = 2;
 "subject_name" = "Indian Ethos in Management";
 "syllabus_percentage" = 13;
 "total_lectures" = 6;
 },
 
 */



class Subject:Mappable{
    
    var subjectId:String = ""
    var subjectName:String = ""
    var numberOfLectures:String = ""
    var completion:String = ""
    var subjectCode:String = ""
    var classId:String = ""
    var classDivision:String = ""
    var courseName:String = ""
//    var topics:[Unit]? = []
    
    
    required public init?(map: Map){
    }
    
    public func mapping(map: Map) {
        self.subjectId <- map["subject_id"]
        self.subjectName <- map["subject_name"]
        self.numberOfLectures <- map["total_lectures"]
        self.completion <- map["syllabus_percentage"]
        self.subjectCode <- map["subject_code"]
        self.classId <- map["class_id"]
        self.classDivision <- map["class_division"]
        self.courseName <- map["course_name"]
        
        /*
        var topicArray:[[String:Any]] = []
        topicArray <- map["topicWise"]
        if(topicArray.count > 0){
            for topic in topicArray{
                let tempTopic = Mapper<Unit>().map(JSON: topic)
                self.topics?.append(tempTopic!)
            }
        }
        */
        
    }
}
