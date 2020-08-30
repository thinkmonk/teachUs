//
//  EditSyllabus.swift
//  TeachUs
//
//  Created by iOS on 09/01/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation

// MARK: - EditSyllabus
class SyllabusStatusData: Codable {
    let syllabusPercentage: String
    let unitSyllabusArray: [UnitSyllabusArray]

    enum CodingKeys: String, CodingKey {
        case syllabusPercentage = "syllabus_percentage"
        case unitSyllabusArray = "unit_syllabus_array"
    }
}

// MARK: - UnitSyllabusArray
class UnitSyllabusArray: Codable {
    let unitName: String?
    let unitId: String?
    let topicList: [TopicList]

    enum CodingKeys: String, CodingKey {
        case unitName = "unit_name"
        case unitId = "unit_id"
        case topicList = "topic_list"
    }
}

// MARK: - TopicList
class TopicList: Codable {
    var unitName:String?
    var unitId:String?
    let topicName: String?
    let topicId: String?
    let topicDescription: String?
    var status: String?
    let resultStatus: String?
    var resultStatusFlag:String?
    var resultStatusDate:String?
    var isUpdated:Bool = false
    var chapterStatusTheme :SyllabusCompletetionType! = .NotStarted
    var setChapterStatus:String? = "Not Started"
    
    
    enum CodingKeys: String, CodingKey {
        case topicName = "topic_name"
        case topicId = "topic_id"
        case topicDescription = "topic_description"
        case status = "status"
        case resultStatus = "result_status"
    }
    
    required init(from decoder: Decoder) throws {
        let container       = try decoder.container(keyedBy: CodingKeys.self)
        topicName           = try container.decode(String.self, forKey: .topicName)
        topicDescription    = try container.decodeIfPresent(String.self, forKey: .topicDescription)
        topicId             = try container.decode(String.self, forKey: .topicId)
        status              = try container.decodeIfPresent(String.self, forKey: .status)
        do {
            
            resultStatus    = try container.decode(String.self, forKey: .resultStatus)
        }
        catch {
            resultStatus    = ""
        }
        if !(resultStatus?.isEmpty ?? false), let resultStatusArray = resultStatus?.components(separatedBy: "|")
        {
            self.resultStatusFlag = resultStatusArray.first
            self.resultStatusDate = resultStatusArray.last
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
