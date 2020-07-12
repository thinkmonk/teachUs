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
        
        let personalInfo = AdmissionFormDataSource(detailsCell: .PersonalInfo, detailsObject: nil, dataSource:nil, isMandatory: false)
        arrayDataSource.append(personalInfo)
        
        let personalInfoObj = self.admissionData.personalInformation
        
        
        let SureName  = AdmissionFormDataSource(detailsCell: .SureName, detailsObject: personalInfoObj?.surname, dataSource:nil, isMandatory: true)
        arrayDataSource.append(SureName)
        
        let FirstName  = AdmissionFormDataSource(detailsCell: .FirstName, detailsObject: personalInfoObj?.firstName, dataSource:nil, isMandatory: true)
        arrayDataSource.append(FirstName)
        
        let FathersName  = AdmissionFormDataSource(detailsCell: .FathersName, detailsObject: personalInfoObj?.fatherName, dataSource:nil, isMandatory: true)
        arrayDataSource.append(FathersName)
        
        let MothersName  = AdmissionFormDataSource(detailsCell: .MothersName, detailsObject: personalInfoObj?.motherName, dataSource:nil, isMandatory: true)
        arrayDataSource.append(MothersName)
        
        let NameOnMarkSheet  = AdmissionFormDataSource(detailsCell: .NameOnMarkSheet, detailsObject: personalInfoObj?.fullName, dataSource:nil, isMandatory: true)
        arrayDataSource.append(NameOnMarkSheet)
        
//        let DevnagriName  = AdmissionFormDataSource(detailsCell: .DevnagriName, detailsObject: personalInfoObj?.fullNameDevnagriScript, dataSource:nil, isMandatory: true)
//        arrayDataSource.append(DevnagriName)
        
        let DOB  = AdmissionFormDataSource(detailsCell: .DOB, detailsObject: personalInfoObj?.dob, dataSource:nil, isMandatory: true)
        arrayDataSource.append(DOB)
        
        let MobileNumber  = AdmissionFormDataSource(detailsCell: .MobileNumber, detailsObject: personalInfoObj?.contact, dataSource:nil, isMandatory: false, isDisabledObj: true)
        arrayDataSource.append(MobileNumber)
        
        let EmailAddress  = AdmissionFormDataSource(detailsCell: .EmailAddress, detailsObject: personalInfoObj?.email, dataSource:nil, isMandatory: true)
        arrayDataSource.append(EmailAddress)
                
        let cateoryDs = self.admissionData.admissionCategory?.map({$0.categoryName})
        let Category  = AdmissionFormDataSource(detailsCell: .Category, detailsObject: personalInfoObj?.category, dataSource:cateoryDs, isMandatory: true)
        arrayDataSource.append(Category)
        
        let Gender  = AdmissionFormDataSource(detailsCell: .Gender, detailsObject:personalInfoObj?.gender, dataSource:AdmissionConstantData.genders, isMandatory: true)
        arrayDataSource.append(Gender)
        
        let Aadhar  = AdmissionFormDataSource(detailsCell: .Aadhar, detailsObject: personalInfoObj?.aadharCard, dataSource:nil,isMandatory: true)
        arrayDataSource.append(Aadhar)
        
        let Religiion  = AdmissionFormDataSource(detailsCell: .Religiion, detailsObject:personalInfoObj?.religion , dataSource:AdmissionConstantData.religions, isMandatory: true)
        arrayDataSource.append(Religiion)
        
        let Caste  = AdmissionFormDataSource(detailsCell: .Caste, detailsObject: personalInfoObj?.caste, dataSource:nil,isMandatory: false)
        arrayDataSource.append(Caste)
        
        let Domicile  = AdmissionFormDataSource(detailsCell: .Domicile, detailsObject:personalInfoObj?.domicileOfState , dataSource:AdmissionConstantData.states,isMandatory: true)
        arrayDataSource.append(Domicile)
        
        let Nationality  = AdmissionFormDataSource(detailsCell: .Nationality, detailsObject: personalInfoObj?.nationality, dataSource:nil,isMandatory: true)
        arrayDataSource.append(Nationality)
        
        let MotherTongue  = AdmissionFormDataSource(detailsCell: .MotherTongue, detailsObject:personalInfoObj?.motherTongue , dataSource:AdmissionConstantData.mothertongue, isMandatory: true)
        arrayDataSource.append(MotherTongue)
        
        let MaritialStatus  = AdmissionFormDataSource(detailsCell: .MaritialStatus, detailsObject:personalInfoObj?.maritalStatus , dataSource:AdmissionConstantData.maritialStatus, isMandatory: true)
        arrayDataSource.append(MaritialStatus)
        
        let BloodGroup  = AdmissionFormDataSource(detailsCell: .BloodGroup, detailsObject: personalInfoObj?.bloodGroup, dataSource:AdmissionConstantData.bloodGroup, isMandatory: false)
        arrayDataSource.append(BloodGroup)
                
        return arrayDataSource
    }
    
    func getAddressDataSource(_ isPermanent:Bool, isCopy:Bool) -> [AdmissionFormDataSource]{
        let personalInfoObj = self.admissionData.personalInformation

        var arrayDataSource = [AdmissionFormDataSource]()
        
        let headerDs = isPermanent || isCopy ? AdmissionFormDataSource(detailsCell: .PermannentAddress, detailsObject: nil, dataSource:nil, isMandatory: false) : AdmissionFormDataSource(detailsCell: .CorrespondanceAddress, detailsObject: nil, dataSource:nil, isMandatory: false)
        arrayDataSource.append(headerDs)
        
        
        let roomValue = isPermanent ? personalInfoObj?.permanentAddressRoom : personalInfoObj?.correspondenceAddressRoom
        let roomDs = AdmissionFormDataSource(detailsCell: .RoomFloorBldg, detailsObject: roomValue, dataSource:nil,isMandatory: true)
        arrayDataSource.append(roomDs)
        
        
        let areaValue = isPermanent ? personalInfoObj?.permanentAddressArea : personalInfoObj?.correspondenceAddressArea
        let areaDs = AdmissionFormDataSource(detailsCell: .AreaLandamrk, detailsObject: areaValue, dataSource:nil, isMandatory: true)
        arrayDataSource.append(areaDs)
        
        let cityValue = isPermanent ? personalInfoObj?.permanentAddressCity : personalInfoObj?.correspondenceAddressCity
        let cityDS = AdmissionFormDataSource(detailsCell: .City, detailsObject: cityValue, dataSource:nil, isMandatory: true )
        arrayDataSource.append(cityDS)
        
        let pinValue = isPermanent ? personalInfoObj?.permanentAddressPinCode : personalInfoObj?.correspondenceAddressPinCode
        let pincode = AdmissionFormDataSource(detailsCell: .PinCode, detailsObject: pinValue, dataSource:nil,  isMandatory: true )
        arrayDataSource.append(pincode)
        
        
        let stateValue = isPermanent ? personalInfoObj?.permanentAddressState : personalInfoObj?.correspondenceAddressState
        if isCopy{
            let stateDs = AdmissionFormDataSource(detailsCell: .State ,detailsObject:stateValue , dataSource:AdmissionConstantData.states, isMandatory: true )
            arrayDataSource.append(stateDs)
            
        }else{
            let stateDs = AdmissionFormDataSource(detailsCell: .State ,detailsObject:stateValue , dataSource:isPermanent ? AdmissionConstantData.states : nil, isMandatory: true, isDisabledObj: !isPermanent )
            arrayDataSource.append(stateDs)
        }
        
        let countryValue = isPermanent ? personalInfoObj?.permanentAddressCountry : personalInfoObj?.correspondenceAddressCountry
        if isCopy{
            let country = AdmissionFormDataSource(detailsCell: .Country, detailsObject: countryValue, dataSource:nil, isMandatory: true )
            arrayDataSource.append(country)
        }else{
            let country = AdmissionFormDataSource(detailsCell: .Country, detailsObject: countryValue, dataSource:nil, isMandatory: true,isDisabledObj: !isPermanent )
            arrayDataSource.append(country)
        }
        
        if isCopy{//copy address in local model as well 
            self.admissionData.personalInformation?.permanentAddressRoom    = self.admissionData.personalInformation?.correspondenceAddressRoom
            self.admissionData.personalInformation?.permanentAddressArea    = self.admissionData.personalInformation?.correspondenceAddressArea
            self.admissionData.personalInformation?.permanentAddressCity    = self.admissionData.personalInformation?.correspondenceAddressCity
            self.admissionData.personalInformation?.permanentAddressPinCode = self.admissionData.personalInformation?.correspondenceAddressPinCode
            self.admissionData.personalInformation?.permanentAddressState   = self.admissionData.personalInformation?.correspondenceAddressState
            self.admissionData.personalInformation?.permanentAddressCountry = self.admissionData.personalInformation?.correspondenceAddressCountry
        }
        
        return arrayDataSource
    }
    
    func validateData() -> Bool{
        return self.admissionData.personalInformation?.validateClassData() ?? false
    }
    
    func validateAadhar(textObj:String) -> Bool{
        return textObj.count == 12
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
