//
//  AdmissionFamilyManager.swift
//  TeachUs
//
//  Created by iOS on 05/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class AdmissionFamilyManager{
    static let shared = AdmissionFamilyManager()
    var familyData:AdmissionFamilyDetails!
    var dataSource = [FamilySectionCellData]()
    
    func makeMotherDetailsDs() -> [FamilyCellDataSource] {
        var rowDs = [FamilyCellDataSource]()
        
        // mother
        let mothertitleDs = FamilyCellDataSource(type: .fathersDetails, obj: self.familyData.familyDetailsInformation?.motherFullName, dataSource: nil, compulsoryFlag: true)
        rowDs.append(mothertitleDs)
        
        let nameDs = FamilyCellDataSource(type: .fullName, obj: self.familyData.familyDetailsInformation?.motherFullName, dataSource: nil, compulsoryFlag: true)
        rowDs.append(nameDs)

        
        let motherdob = FamilyCellDataSource(type: .DOB, obj: self.familyData.familyDetailsInformation?.motherDob, dataSource: nil, compulsoryFlag: true)
        rowDs.append(motherdob)
        
        let motherageDs = FamilyCellDataSource(type: .age , obj: self.familyData.familyDetailsInformation?.motherAge, dataSource: nil, compulsoryFlag: false)
        rowDs.append(motherageDs)
        
        
        let mothercontactNumberDs = FamilyCellDataSource(type: .contactNumber, obj: self.familyData.familyDetailsInformation?.motherContactNumber, dataSource: nil, compulsoryFlag: true)
        rowDs.append(mothercontactNumberDs)
        
        let motheremailAddressDs = FamilyCellDataSource(type: .emailAddress, obj: self.familyData.familyDetailsInformation?.motherEmail, dataSource: nil, compulsoryFlag: false)
        rowDs.append(motheremailAddressDs)
        
        let motherprofessionalDs = FamilyCellDataSource(type: .profession, obj: self.familyData.familyDetailsInformation?.motherProfession, dataSource: AdmissionConstantData.professionList, compulsoryFlag: true)
        rowDs.append(motherprofessionalDs)
        
        
//        let motherindustryDs = FamilyCellDataSource(type: .industry, obj: self.familyData.familyDetailsInformation?.motherIndustry, dataSource: nil, compulsoryFlag: true)
//        rowDs.append(motherindustryDs)
        
        
        let mothertotalIncomeDs = FamilyCellDataSource(type: .totalIncome, obj: self.familyData.familyDetailsInformation?.motherTotalIncome, dataSource: AdmissionConstantData.incomeList, compulsoryFlag: true)
        rowDs.append(mothertotalIncomeDs)
        
        
        let mothercontryofWorkDs = FamilyCellDataSource(type: .countryOfWork, obj: self.familyData.familyDetailsInformation?.motherCountry, dataSource: nil, compulsoryFlag: true)
        rowDs.append(mothercontryofWorkDs)
        return rowDs
    }
    
    func makeFatherRowDataSource()-> [FamilyCellDataSource]{
        var rowDs = [FamilyCellDataSource]()
        // father
        let titleDs = FamilyCellDataSource(type: .fathersDetails, obj: nil, dataSource: nil, compulsoryFlag: true)
        rowDs.append(titleDs)
        
        let nameDs = FamilyCellDataSource(type: .fullName, obj: self.familyData.familyDetailsInformation?.fatherFullName, dataSource: nil, compulsoryFlag: true)
        rowDs.append(nameDs)

        
        
        let dob = FamilyCellDataSource(type: .DOB, obj: self.familyData.familyDetailsInformation?.fatherDob, dataSource: nil, compulsoryFlag: true)
        rowDs.append(dob)
        
        let ageDs = FamilyCellDataSource(type: .age , obj: self.familyData.familyDetailsInformation?.fatherAge, dataSource: nil, compulsoryFlag: false)
        rowDs.append(ageDs)
        
        
        let contactNumberDs = FamilyCellDataSource(type: .contactNumber, obj: self.familyData.familyDetailsInformation?.fatherContactNumber, dataSource: nil, compulsoryFlag: true)
        rowDs.append(contactNumberDs)
        
        let emailAddressDs = FamilyCellDataSource(type: .emailAddress, obj: self.familyData.familyDetailsInformation?.fatherEmail, dataSource: nil, compulsoryFlag: false)
        rowDs.append(emailAddressDs)
        
        let professionalDs = FamilyCellDataSource(type: .profession, obj: self.familyData.familyDetailsInformation?.fatherProfession, dataSource: AdmissionConstantData.professionList, compulsoryFlag: true)
        rowDs.append(professionalDs)
        
        
//        let industryDs = FamilyCellDataSource(type: .industry, obj: self.familyData.familyDetailsInformation?.fatherIndustry, dataSource: nil, compulsoryFlag: true)
//        rowDs.append(industryDs)
        
        
        let totalIncomeDs = FamilyCellDataSource(type: .totalIncome, obj: self.familyData.familyDetailsInformation?.fatherTotalIncome, dataSource: AdmissionConstantData.incomeList, compulsoryFlag: true)
        rowDs.append(totalIncomeDs)
        
        
        let contryofWorkDs = FamilyCellDataSource(type: .countryOfWork, obj: self.familyData.familyDetailsInformation?.fatherCounty, dataSource: nil, compulsoryFlag: true)
        rowDs.append(contryofWorkDs)
        
        return rowDs
    }
    
    func makeSectionDataSurce(){
        dataSource.removeAll()
        
        
        
        let titleDs = FamilyCellDataSource(type: .FamilyDetailsSection, obj: nil, dataSource: nil, compulsoryFlag: false)
        let header  = FamilySectionCellData(type: .header, attachedObj: [titleDs])
        dataSource.append(header)
        
        
        
        let fatherDs = FamilySectionCellData(type: .father, attachedObj: self.makeFatherRowDataSource())
        dataSource.append(fatherDs)
        
        let motherDs = FamilySectionCellData(type: .mother, attachedObj: self.makeMotherDetailsDs())
        dataSource.append(motherDs)
    }
    
    func validateaAllInputData() -> Bool{
        return self.familyData.familyDetailsInformation?.isDataPresent ?? false
    }
    
    
    func sendformFourData(formId:Int,_ completion:@escaping ([String:Any]?) -> (),
                          _ failure:@escaping () -> ())
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.submitFamilyData
        var params = [String:Any]()
        do {
            let personalInfoData = try JSONEncoder().encode(self.familyData.familyDetailsInformation)
            let json = try JSONSerialization.jsonObject(with: personalInfoData, options: [])
            guard let dictionary = json as? [String : Any] else {
                LoadingActivityHUD.hideProgressHUD()
                return
            }
            params = dictionary
        } catch let error{
            print("err", error)
        }
        
        
        
        params["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        params["role_id"] = "1"
        params["admission_form_id"] = "\(formId)"
        
        manager.apiPostWithDataResponse(apiName: "Update academic form data.", parameters:params , completionHandler: { (result, code, response) in
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
