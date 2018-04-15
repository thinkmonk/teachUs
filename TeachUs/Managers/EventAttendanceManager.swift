//
//  EventAttendanceManager.swift
//  TeachUs
//
//  Created by ios on 4/14/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class EventAttendanceManager{
    
    static let sharedEventAttendanceManager = EventAttendanceManager()
    var arrayStudents : Variable<[EventStudents]> = Variable([])
    let disposeBag = DisposeBag()
    var totalPresentCount:Variable<Int> = Variable(0)
    
    
    func updateCount(){
        self.totalPresentCount.value =  self.arrayStudents.value.map({$0.attendance.value}).reduce(0, +)
    }
    
    func increaseAttendance(student:EventStudents){
        self.arrayStudents.value.filter{$0.studentID == student.studentID}.first!.attendance.value += 1
        self.updateCount()
    }
    
    func decreaseAttendance(student:EventStudents){
        self.arrayStudents.value.filter{$0.studentID == student.studentID}.first?.attendance.value -= 1
        self.updateCount()
    }
    
    
    /*
    var attendanceListJSON:[[String:Any] ]{
        var students = [[String:Any]] ()
        for student in arrayStudents.value{
//             studentString["student_id"] = student.studentID
//            studentString["attendance"] = Int(student.attendance.value)
            let studentString = ["student_id":"\(student.studentID)",
                                            "attendance":"\(student.attendance.value)" ]
            
            students.insert(studentString, at: students.count)
        }
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: students,options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            print("parameters = \(theJSONText!)")
        }
        
        return students
    }
    */
    var attendanceList2:String{
//        var result = [String: [String: AnyObject]]()
//        let students = self.arrayStudents.value
//
//        for i in 0..<students.count {
//            let student  = students[i]
//            let attendanceList :[String:AnyObject] = [
//                "student_id":"\(student.studentID)" as AnyObject,
//                "attendance":"\(student.attendance.value)" as AnyObject
//            ]
//            result["\(i)"] = attendanceList
//        }
//        return result
        
        
        let result:[String:Any] = ["student_id": "4",
                                   "attendance":"2"]
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: result,options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            print("parameters = \(theJSONText!)")
            return theJSONText!
        }
        return ""
        
    }
    
    
    var attendanceJSON:[String : [[String : String]]]{
        var students = [[String:String]] ()
        for student in arrayStudents.value{
            //             studentString["student_id"] = student.studentID
            //            studentString["attendance"] = Int(student.attendance.value)
            let studentString = ["student_id":"\(student.studentID)",
                "attendance":"\(student.attendance.value)" ]
            
            students.insert(studentString, at: students.count)
        }
        return ["student_list":students]
    }
}




/*
 {"student_list":[{"student_id":4, "attendance":2 },{"student_id":5, "attendance":2 },{"student_id":6, "attendance":2 },{"student_id":7, "attendance":2 } ]}
 
 */
