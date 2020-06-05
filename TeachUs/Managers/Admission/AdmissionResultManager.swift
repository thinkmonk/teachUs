//
//  AdmissionAcademicManager.swift
//  TeachUs
//
//  Created by iOS on 01/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class AdmissionResultManager{
    static var shared = AdmissionResultManager()
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

                let resultDeclard = AcademicRowDataSource(type: .resultDeclared, obj: resultObj.resultStatus, dataSource: AdmissionConstantData.In_house, compulsoryFlag: true, greyedOut: false)
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
        if let academicInfo = AdmissionResultManager.shared.recordData, dataSource[indexpath.section].headerType == .recordsData{
            if academicInfo.academicRecord?.result?.count == 1{
                AdmissionResultManager.shared.recordData?.academicRecord?.result?.removeAll()
            }else{
                AdmissionResultManager.shared.recordData?.academicRecord?.result?.remove(at: indexpath.section-1) //-1 as the first section is used bt admission info
            }
            self.makeDataSource()
            completetion()
        }
    }
    
    func addNewAcademicRecord(completetion: @escaping () -> ()){
        let record = Result()
        if AdmissionResultManager.shared.recordData?.academicRecord?.result == nil{
            AdmissionResultManager.shared.recordData?.academicRecord?.result = [Result]()
            AdmissionResultManager.shared.recordData?.academicRecord?.result?.append(record)
        }else{
            AdmissionResultManager.shared.recordData?.academicRecord?.result?.append(record)
        }
        self.makeDataSource()
        completetion()
    }
    
    func validateaAllInputData() -> Bool{
        return self.recordData?.academicRecord?.isDataPresent ?? false
    }
    
    func sendFormThreeData(formId:Int,_ completion:@escaping ([String:Any]?) -> (),
                         _ failure:@escaping () -> ())
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.submitAcademicRecordForm
        var params = [String:Any]()
        do {
            let personalInfoData = try JSONEncoder().encode(self.recordData?.academicRecord)
            let json = try JSONSerialization.jsonObject(with: personalInfoData, options: [])
            guard let dictionary = json as? [String : Any] else {
                LoadingActivityHUD.hideProgressHUD()
                return
            }
            params = dictionary
            var resultArray = [[String:Any]]()
            for result in self.recordData?.academicRecord?.result ?? []{
//                let resultData = try JSONEncoder().encode(result)
//                            let json = try JSONSerialization.jsonObject(with: resultData, options: [])
//                guard let dictionary = json as? [String : Any] else {
//                    print("Yeh b fata")
//                    return
//                }
                let resultParams:[String:Any] = [
                    "academic_year" : "First Year",
                    "marks" : "7.00",
                    "credit_earned" : "20",
                    "grade":"B+",
                    "passing_month":"April",
                    "passing_year":"2019",
                    "no_of_atkt":"0",
                    "result_status":"False",
                    "academic_semester":2,
                ]
                resultArray.append(resultParams)
            }
            
            params["result"] = resultArray
            params["in_house"] = "False"
        } catch let error{
            print("err", error)
        }
        
        
        
        
        
        
        /*
        //reports conversion
        do{
            let resultData = try JSONEncoder().encode(self.recordData?.academicRecord?.result)
                let jsonData = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let `jsonData` = jsonData, let jsonString = String(data: jsonData as! Data, encoding: .utf8){
                    params["result"] = jsonString
                }
//            guard let dictionary = json as? [String : Any] else {
//                LoadingActivityHUD.hideProgressHUD()
//                return
//            }
//            var requestString  =  ""
//            if let theJSONData = try? JSONSerialization.data(withJSONObject: dictionary,options: []) {
//                let theJSONText = String(data: theJSONData,encoding: .ascii)
//                requestString = theJSONText!
//                print("requestString = \(theJSONText!)")
//                params["result"] = requestString
//            }
            
        }
        catch let error{
            print("err", error.localizedDescription)
        }
        */
        
        /*
        var jsonString = [Data]()
        if let resultObj = self.recordData?.academicRecord?.result{
            for result in resultObj{
                jsonString.append(getJSON(for: result))
            }
        }
        let jsonOBj = jsonString
        params["result"] = "\([jsonOBj])"
        */
        params["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        params["role_id"] = "1"
        params["admission_form_id"] = "\(formId)"

        manager.apiPostWithDataResponse(apiName: "Update academic form data.", parameters:params , completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
//            do {
//                let decoded = try JSONSerialization.jsonObject(with: response, options: [])
//                if let dictFromJSON = decoded as? [String:Any] {
//                    completion(dictFromJSON)
//                }
//            } catch{
//                print("parsing error \(error)")
//                completion([:])
//            }
        }) { (error, code, message) in
            failure()
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func getJSON(for dataObj:Result) -> Data{
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(dataObj)
            return jsonData
            
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            print(json ?? "")
        }
        catch let error{
            print("err", error.localizedDescription)
        }
        return Data()
    }
    
}
