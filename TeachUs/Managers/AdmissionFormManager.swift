//
//  AdmissionFormManager.swift
//  TeachUs
//
//  Created by iOS on 30/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class AdmissionFormManager{
    var admissionData:AdmissionData!
    static var shared = AdmissionFormManager()
    
    func makePersonalInfoDataSource() -> [AdmissionFormDataSource]{
        var arrayDataSource = [AdmissionFormDataSource]()
        
        let personalInfo = AdmissionFormDataSource(detailsCell: .PersonalInfo, detailsObject: nil, dataSource:nil)
        arrayDataSource.append(personalInfo)
        
        let personalInfoObj = self.admissionData.personalInformation
        
        
        let SureName  = AdmissionFormDataSource(detailsCell: .SureName, detailsObject: personalInfoObj?.surname, dataSource:nil)
        arrayDataSource.append(SureName)
        
        let FirstName  = AdmissionFormDataSource(detailsCell: .FirstName, detailsObject: personalInfoObj?.firstName, dataSource:nil)
        arrayDataSource.append(FirstName)
        
        let FathersName  = AdmissionFormDataSource(detailsCell: .FathersName, detailsObject: personalInfoObj?.fatherName, dataSource:nil)
        arrayDataSource.append(FathersName)
        
        let MothersName  = AdmissionFormDataSource(detailsCell: .MothersName, detailsObject: personalInfoObj?.motherName, dataSource:nil)
        arrayDataSource.append(MothersName)
        
        let NameOnMarkSheet  = AdmissionFormDataSource(detailsCell: .NameOnMarkSheet, detailsObject: personalInfoObj?.fullName, dataSource:nil)
        arrayDataSource.append(NameOnMarkSheet)
        
        let DevnagriName  = AdmissionFormDataSource(detailsCell: .DevnagriName, detailsObject: personalInfoObj?.fullNameDevnagriScript, dataSource:nil)
        arrayDataSource.append(DevnagriName)
        
        let DOB  = AdmissionFormDataSource(detailsCell: .DOB, detailsObject: personalInfoObj?.dob, dataSource:nil)
        arrayDataSource.append(DOB)
        
        let MobileNumber  = AdmissionFormDataSource(detailsCell: .MobileNumber, detailsObject: personalInfoObj?.contact, dataSource:nil)
        arrayDataSource.append(MobileNumber)
        
        let EmailAddress  = AdmissionFormDataSource(detailsCell: .EmailAddress, detailsObject: personalInfoObj?.email, dataSource:nil)
        arrayDataSource.append(EmailAddress)
                
        let cateoryDs = self.admissionData.admissionCategory?.map({$0.categoryName})
        let Category  = AdmissionFormDataSource(detailsCell: .Category, detailsObject: personalInfoObj?.category, dataSource:cateoryDs)
        arrayDataSource.append(Category)
        
        let Gender  = AdmissionFormDataSource(detailsCell: .Gender, detailsObject:personalInfoObj?.gender, dataSource:AdmissionConstantData.genders)
        arrayDataSource.append(Gender)
        
        let Aadhar  = AdmissionFormDataSource(detailsCell: .Aadhar, detailsObject: personalInfoObj?.aadharCard, dataSource:nil)
        arrayDataSource.append(Aadhar)
        
        let Religiion  = AdmissionFormDataSource(detailsCell: .Religiion, detailsObject:personalInfoObj?.religion , dataSource:AdmissionConstantData.religions)
        arrayDataSource.append(Religiion)
        
        let Caste  = AdmissionFormDataSource(detailsCell: .Caste, detailsObject: personalInfoObj?.caste, dataSource:nil)
        arrayDataSource.append(Caste)
        
        let Domicile  = AdmissionFormDataSource(detailsCell: .Domicile, detailsObject:personalInfoObj?.domicileOfState , dataSource:AdmissionConstantData.states)
        arrayDataSource.append(Domicile)
        
        let Nationality  = AdmissionFormDataSource(detailsCell: .Nationality, detailsObject: personalInfoObj?.nationality, dataSource:nil)
        arrayDataSource.append(Nationality)
        
        let MotherTongue  = AdmissionFormDataSource(detailsCell: .MotherTongue, detailsObject:personalInfoObj?.motherTongue , dataSource:AdmissionConstantData.mothertongue)
        arrayDataSource.append(MotherTongue)
        
        let MaritialStatus  = AdmissionFormDataSource(detailsCell: .MaritialStatus, detailsObject:personalInfoObj?.maritalStatus , dataSource:AdmissionConstantData.maritialStatus)
        arrayDataSource.append(MaritialStatus)
        
        let BloodGroup  = AdmissionFormDataSource(detailsCell: .BloodGroup, detailsObject: personalInfoObj?.bloodGroup, dataSource:AdmissionConstantData.bloodGroup)
        arrayDataSource.append(BloodGroup)
                
        return arrayDataSource
    }
    
    func getAddressDataSource(_ isPermanent:Bool, isCopy:Bool) -> [AdmissionFormDataSource]{
        let personalInfoObj = self.admissionData.personalInformation

        var arrayDataSource = [AdmissionFormDataSource]()
        
        let headerDs = isPermanent || isCopy ? AdmissionFormDataSource(detailsCell: .PermannentAddress, detailsObject: nil, dataSource:nil) : AdmissionFormDataSource(detailsCell: .CorrespondanceAddress, detailsObject: nil, dataSource:nil)
        arrayDataSource.append(headerDs)
        
        
        let roomValue = isPermanent ? personalInfoObj?.permanentAddressRoom : personalInfoObj?.correspondenceAddressRoom
        let roomDs = AdmissionFormDataSource(detailsCell: .RoomFloorBldg, detailsObject: roomValue, dataSource:nil)
        arrayDataSource.append(roomDs)
        
        
        let areaValue = isPermanent ? personalInfoObj?.permanentAddressArea : personalInfoObj?.correspondenceAddressArea
        let areaDs = AdmissionFormDataSource(detailsCell: .AreaLandamrk, detailsObject: areaValue, dataSource:nil)
        arrayDataSource.append(areaDs)
        
        let cityValue = isPermanent ? personalInfoObj?.permanentAddressCity : personalInfoObj?.correspondenceAddressCity
        let cityDS = AdmissionFormDataSource(detailsCell: .City, detailsObject: cityValue, dataSource:nil)
        arrayDataSource.append(cityDS)
        
        let pinValue = isPermanent ? personalInfoObj?.permanentAddressPinCode : personalInfoObj?.correspondenceAddressPinCode
        let pincode = AdmissionFormDataSource(detailsCell: .PinCode, detailsObject: pinValue, dataSource:nil)
        arrayDataSource.append(pincode)
        
        let stateValue = isPermanent ? personalInfoObj?.permanentAddressState : personalInfoObj?.correspondenceAddressState
        let stateDs = AdmissionFormDataSource(detailsCell: .State ,detailsObject:stateValue , dataSource:AdmissionConstantData.states)
        arrayDataSource.append(stateDs)
        
        let countryValue = isPermanent ? personalInfoObj?.permanentAddressCountry : personalInfoObj?.correspondenceAddressCountry
        let country = AdmissionFormDataSource(detailsCell: .Country, detailsObject: countryValue, dataSource:nil)
        arrayDataSource.append(country)
        
        return arrayDataSource
    }
    
    func validateData() -> Bool{
        return self.admissionData.personalInformation?.validateClassData() ?? false
    }
    
    func sendFormOneData(_ completion:@escaping ([String:Any]?) -> (),
                         _ failure:@escaping () -> ())
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.submitStudentInfo
        var params = [String:Any]()
        do {
            let personalInfoData = try JSONEncoder().encode(self.admissionData.personalInformation)
            let json = try JSONSerialization.jsonObject(with: personalInfoData, options: [])
            guard let dictionary = json as? [String : Any] else {
                return
            }
            params = dictionary
        } catch let error{
            print("err", error)
        }
        params["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        params["role_id"] = "1"

        manager.apiPostWithDataResponse(apiName: "Submit Studetn data for admission", parameters:params , completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do {
                let decoded = try JSONSerialization.jsonObject(with: response, options: [])
                if let dictFromJSON = decoded as? [String:Any] {
                    completion(dictFromJSON)
                }
            } catch{
                print("parsing error \(error)")
                completion([:])
            }
        }) { (error, code, message) in
            failure()
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
}


class AdmissioSubjectManager {
    static let shared = AdmissioSubjectManager()
    var subjectData:AdmissioSubjectnData!
    
    func getProgramSelectionDataSource() -> [AdmisionSubjectDataSource]{
        var dataSource = [AdmisionSubjectDataSource]()
        
        let programheader = AdmisionSubjectDataSource(detailsCell: .programHeader, detailsObject: nil, dataSource: nil)
        dataSource.append(programheader)
        
        let streamData = self.subjectData.admissionForm?.map({$0.specilaization})
        let selectStream = AdmisionSubjectDataSource(detailsCell: .steam, detailsObject: nil, dataSource: streamData)
        dataSource.append(selectStream)
        return dataSource
    }
    
    func getAllProgramDatasource() -> [AdmisionSubjectDataSource]{
        var dataSource = [AdmisionSubjectDataSource]()
        
        let programheader = AdmisionSubjectDataSource(detailsCell: .programHeader, detailsObject: nil, dataSource: nil)
        dataSource.append(programheader)
        
        let streamData = self.subjectData.admissionForm?.map({$0.specilaization})
        let selectStream = AdmisionSubjectDataSource(detailsCell: .steam, detailsObject: nil, dataSource: streamData)
        dataSource.append(selectStream)
        
        let lavelDs = AdmisionSubjectDataSource(detailsCell: .level, detailsObject: nil, dataSource: nil)
        dataSource.append(lavelDs)
        
        let courseDs = AdmisionSubjectDataSource(detailsCell: .course, detailsObject: nil, dataSource: nil)
        dataSource.append(courseDs)
        
        let yearDs = AdmisionSubjectDataSource(detailsCell: .academicYear, detailsObject: nil, dataSource: nil)
        dataSource.append(yearDs)
        
        
        return dataSource
    }
}
