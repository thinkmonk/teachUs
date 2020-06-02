//
//  AdmissionAcademicManager.swift
//  TeachUs
//
//  Created by iOS on 01/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class AdmissionAcademicManager{
    static var shared = AdmissionAcademicManager()
    var recordData:AdmissionAcademicRecord?
    var dataSource = [AcademicSectionDataSource]()
    
    func makeDataSource(){
        dataSource.removeAll()
        
        let rowPreviousAcademicDataSource = self.getPreviousAcademicRecordDataSource()
        let sectionDs = AcademicSectionDataSource(type: .previousRecords, attachedObj: rowPreviousAcademicDataSource)
        self.dataSource.append(sectionDs)
        
        let recordDs = self.getRecordSectionDatasource()
        self.dataSource.append(contentsOf: recordDs)
        
        
        let newRecordAddd = AcademicRowDataSource(type: .addNewRecord, obj: nil, dataSource: nil, compulsoryFlag: false, greyedOut: false)
        let ds = AcademicSectionDataSource(type: .addNewRecord, attachedObj: [newRecordAddd])
        self.dataSource.append(ds)
        

    }
    
    func getPreviousAcademicRecordDataSource() -> [AcademicRowDataSource]{
        var rownDs = [AcademicRowDataSource]()
        let recordObj = self.recordData?.academicRecord
        let degreds = AcademicRowDataSource(type: .degreeName, obj: recordObj?.nameOfDegree, dataSource: nil, compulsoryFlag: false, greyedOut: true)
        rownDs.append(degreds)
        
        let mediumds = AcademicRowDataSource(type: .mediumOfInstruction, obj: recordObj?.mediumOfInstructions, dataSource: nil, compulsoryFlag: false, greyedOut: true)
        rownDs.append(mediumds)

        
        let durationDs = AcademicRowDataSource(type: .degreeDuration , obj: recordObj?.durationOfDegree, dataSource: nil, compulsoryFlag: false, greyedOut: true)
        rownDs.append(durationDs)

        let schemeDS = AcademicRowDataSource(type: .SchemeOfExamination, obj: recordObj?.schemeOfExamination, dataSource: nil, compulsoryFlag: false, greyedOut: true)
        rownDs.append(schemeDS)

        let disiplineDs = AcademicRowDataSource(type: .discipline, obj: recordObj?.discipline, dataSource: nil, compulsoryFlag: false, greyedOut: true)
        rownDs.append(disiplineDs)


        let univEnrollmentDs = AcademicRowDataSource(type: .prnNuber, obj: recordObj?.prnNo, dataSource: nil, compulsoryFlag: false, greyedOut: false)
        rownDs.append(univEnrollmentDs)

        let univNameDs = AcademicRowDataSource(type: .unversityName, obj: recordObj?.universityName, dataSource: nil, compulsoryFlag: false, greyedOut: true)
        rownDs.append(univNameDs)

        let flag = ["Yes","No"]
        let inHouseds = AcademicRowDataSource(type: .inHouse, obj: recordObj?.inHouse, dataSource: flag, compulsoryFlag: true, greyedOut: false)
        rownDs.append(inHouseds)

        let instiDs = AcademicRowDataSource(type: .InstituteName, obj: recordObj?.instituteName, dataSource: nil, compulsoryFlag: false, greyedOut: true)
        rownDs.append(instiDs)
        
        let markingDs = AcademicRowDataSource(type: .markingSystem, obj: recordObj?.markingSystem, dataSource: nil, compulsoryFlag: false, greyedOut: true)
        rownDs.append(markingDs)

        return rownDs
    }
    
    
    func getRecordSectionDatasource() -> [AcademicSectionDataSource]{
        var rowDs = [AcademicRowDataSource]()
        var _dataSource = [AcademicSectionDataSource]()
        if let recordObj = self.recordData?.academicRecord{
            
            for (index,resultObj) in recordObj.result?.enumerated() ?? [].enumerated(){
                let recordNumber = AcademicRowDataSource(type: .recordNumberHeader, obj: "Record \(index+1)", dataSource: nil, compulsoryFlag: false, greyedOut: false)
                rowDs.append(recordNumber)

                let acadmeicYr = AcademicRowDataSource(type: .academicYear, obj: resultObj.academicYear, dataSource: AdmissionConstantData.academicYear, compulsoryFlag: true, greyedOut: false)
                rowDs.append(acadmeicYr)

                let sesmester = AcademicRowDataSource(type: .semester, obj: resultObj.academicSemester, dataSource: AdmissionConstantData.semsters, compulsoryFlag: true, greyedOut: false)
                rowDs.append(sesmester)

                let resultDeclard = AcademicRowDataSource(type: .resultDeclared, obj: resultObj.resultStatus, dataSource: AdmissionConstantData.In_house, compulsoryFlag: false, greyedOut: false)
                rowDs.append(resultDeclard)
                
                let resultDeclared =  resultObj.resultStatus?.boolValuefromYesNo() ?? true
                
                
                let cgpa = AcademicRowDataSource(type: .cgpa, obj: resultObj.marks, dataSource: nil, compulsoryFlag: !resultDeclared, greyedOut: !resultDeclared) //negation helps the proper setup
                rowDs.append(cgpa)
                
                let credits = AcademicRowDataSource(type: .creditEarned, obj: resultObj.creditEarned, dataSource: nil, compulsoryFlag: !resultDeclared, greyedOut: !resultDeclared)
                rowDs.append(credits)
                
                let grade = AcademicRowDataSource(type: .grade, obj: resultObj.grade, dataSource: AdmissionConstantData.grade, compulsoryFlag: !resultDeclared, greyedOut: !resultDeclared)
                rowDs.append(grade)

                let passingMonth = AcademicRowDataSource(type: .passingMonth, obj: resultObj.passingMonth, dataSource: AdmissionConstantData.months, compulsoryFlag: !resultDeclared, greyedOut: !resultDeclared)
                rowDs.append(passingMonth)

                
                let passingyear = AcademicRowDataSource(type: .passingYear, obj: resultObj.academicYear, dataSource: nil, compulsoryFlag: !resultDeclared, greyedOut: !resultDeclared)
                rowDs.append(passingyear)

                
                let atkt = AcademicRowDataSource(type: .atkt, obj: resultObj.noOfAtkt, dataSource: AdmissionConstantData.BacklogNo, compulsoryFlag: !resultDeclared, greyedOut: !resultDeclared)
                rowDs.append(atkt)
                
                
                let recordSectionDataSource = AcademicSectionDataSource(type: .recordsData, attachedObj: rowDs)
                _dataSource.append(recordSectionDataSource)
                rowDs.removeAll()

                
            }//for loop ends
            
            //add new record add button
            
        }
        
        return _dataSource
    }
    
    func removeRecordAtIndexPath(at indexpath:IndexPath, completetion: @escaping () -> ()){
        if let academicInfo = AdmissionAcademicManager.shared.recordData, dataSource[indexpath.section].headerType == .recordsData{
            if academicInfo.academicRecord?.result?.count == 1{
                AdmissionAcademicManager.shared.recordData?.academicRecord?.result?.removeAll()
            }else{
                AdmissionAcademicManager.shared.recordData?.academicRecord?.result?.remove(at: indexpath.section-1) //-1 as the first section is used bt admission info
            }
            self.makeDataSource()
            completetion()
        }
    }
    
    func addNewAcademicRecord(completetion: @escaping () -> ()){
        let record = Result()
        if AdmissionAcademicManager.shared.recordData?.academicRecord?.result == nil{
            AdmissionAcademicManager.shared.recordData?.academicRecord?.result = [Result]()
            AdmissionAcademicManager.shared.recordData?.academicRecord?.result?.append(record)
        }else{
            AdmissionAcademicManager.shared.recordData?.academicRecord?.result?.append(record)
        }
        self.makeDataSource()
        completetion()
    }
}
