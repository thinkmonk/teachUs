//
//  ProfessorLogs.swift
//  TeachUs
//
//  Created by ios on 11/28/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 
 "classId": 0,
 "fromTime": "13:14 PM",
 "toTime": "14:14 PM",
 "noOfLecture": 1,
 "totalAttendance": 2,
 "dateTime": "2017-11-26T14:15:35",
 "topicWise": [
 {
 "topicId": 0,
 "unitNumber": "UNIT 1",
 "unitName": "Introduction to Unix",
 "chapterWise": [
 {
 "chapterId": 1,
 "chapterNumber": "Chapture 01",
 "chapterNamme": "TEST CHAPTER 1",
 "status": "COMPLETE"
 }
 ]
 }
 ]
 */


class ProfessorLogs:Mappable{
    var classId:Int!
    var fromTime:String = ""
    var toTime:String = ""
    var noOfLecture:Int!
    var totalAttendance:Int!
    var dateTime:String = ""
    var topics : [Topic] = []
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.classId <- map["classId"]
        self.fromTime <- map["fromTime"]
        self.toTime <- map["toTime"]
        self.noOfLecture <- map["noOfLecture"]
        self.totalAttendance <- map["totalAttendance"]
        self.dateTime <- map["dateTime"]
        if(map.JSON["topicWise"] != nil){
            var topicArray:[[String:Any]] = []
            topicArray <- map["topicWise"]
            if(topicArray.count > 0){
                for topic in topicArray{
                    let tempTopic = Mapper<Topic>().map(JSON: topic)
                    self.topics.append(tempTopic!)
                }
            }
        }
    }
}
