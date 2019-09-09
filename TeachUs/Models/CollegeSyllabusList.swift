//
//  CollegeSyllabusList.swift
//  TeachUs
//
//  Created by ios on 5/14/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 
 {
 "class_list": [
 {
 "course_name": "TYBMS - A",
 "class_id": "1",
 "status": "4"
 },
 
 */

/*
class CollegeSyllabusList:Mappable{
    var courseName:String = ""
    var classId:String = ""
    var status:String = ""
    var numberOfLectures:String?
    required init?(map: Map) {
    }
    
     func mapping(map: Map) {
        self.courseName <- map["course_name"]
        self.classId <- map["class_id"]
        self.status <- map["status"]
        self.numberOfLectures <- map["no_of_lecture"]
    }
    
}
*/

struct CollegeSyllabusList: Codable {
    var classList: [CourseClassList]
    
    enum CodingKeys: String, CodingKey {
        case classList = "class_list"
    }
}

class CourseClassList:Codable{
    var courseName:String?
    var classId:String?
    var status:DynamicValueEnum
    var numberOfLectures:String?
    
    enum CodingKeys:String,CodingKey{
        case courseName = "course_name"
        case classId = "class_id"
        case status = "status"
        case numberOfLectures = "no_of_lecture"
    }
}


enum DynamicValueEnum: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(DynamicValueEnum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DynamicValueEnum"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    var stringValue:String{
        switch self{
        case .integer(let value): return "\(value)"
        case .string(let value): return value
        }
    }
}
