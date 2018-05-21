//
//  Event.swift
//  TeachUs
//
//  Created by ios on 4/7/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//


/*
 
 
 "event_id": "5",
 "event_name": "Miraaj",
 "event_code": "miraaj",
 "event_description": "lorem ipsum",
 "event_date": "2018-02-02",
 "total_participants": "19"
 
 
 */

import Foundation
import ObjectMapper

class Event:Mappable{
    var eventId:String = ""
    var eventName:String = " "
    var eventCode:String = ""
    var eventDescription:String =  ""
    var eventDate:String = ""
    var totalParticipants:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.eventId <- map["event_id"]
        self.eventName <- map["event_name"]
        self.eventCode <- map["event_code"]
        self.eventDescription <- map["event_description"]
        self.eventDate <- map["event_date"]
        self.totalParticipants <- map["total_participants"]
    }
    
    
}
