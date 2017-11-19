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

class Chapter:Mappable{
    
    var chapterId:Int?
    var chapterNumber:String?
    var chapterName:String?
    var status:String?
    var setChapterStatus:String? = "Not Started"
    var chapterStatusTheme :SyllabusCompletetionType! = .NotStarted
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.chapterId <- map["chapterId"]
        self.chapterNumber <- map["chapterNumber"]
        self.chapterName <- map["chapterNamme"]
        if(map.JSON["status"] != nil){
            self.status <- map["status"]
        }else{
            self.status = ""
        }
    }
}


class Topic:Mappable{
    
    var topicId:Int?
    var unitNumber:String?
    var unitName:String?
    var chapters:[Chapter]? = []
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.topicId <- map["topicId"]
        self.unitName <- map["unitName"]
        self.unitNumber <- map["unitNumber"]
        var chaptersArray:[[String:Any]] = []
        chaptersArray <- map["chapterWise"]
        
        if(chaptersArray.count > 0){
            for chapter in chaptersArray {
                let tempChapter = Mapper<Chapter>().map(JSON: chapter)
                self.chapters?.append(tempChapter!)
            }
        }
    }
}



class Subject:Mappable{
    
    var subjectId:Int?
    var subjectName:String?
    var numberOfLectures:Int?
    var completion:String?
    var topics:[Topic]? = []
    
    
    required public init?(map: Map){
    }
    
    public func mapping(map: Map) {
        self.subjectId <- map["subjectId"]
        self.subjectName <- map["subjectName"]
        self.numberOfLectures <- map["numOfLecture"]
        self.completion <- map["completion"]
        var topicArray:[[String:Any]] = []
        topicArray <- map["topicWise"]
        if(topicArray.count > 0){
            for topic in topicArray{
                let tempTopic = Mapper<Topic>().map(JSON: topic)
                self.topics?.append(tempTopic!)
            }
        }
        
    }
}
