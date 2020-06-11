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
        
        let MobileNumber  = AdmissionFormDataSource(detailsCell: .MobileNumber, detailsObject: personalInfoObj?.contact, dataSource:nil, isMandatory: false)
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
        let stateDs = AdmissionFormDataSource(detailsCell: .State ,detailsObject:stateValue , dataSource:AdmissionConstantData.states, isMandatory: true )
        arrayDataSource.append(stateDs)
        
        let countryValue = isPermanent ? personalInfoObj?.permanentAddressCountry : personalInfoObj?.correspondenceAddressCountry
        let country = AdmissionFormDataSource(detailsCell: .Country, detailsObject: countryValue, dataSource:nil, isMandatory: true )
        arrayDataSource.append(country)
        
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
    
    func validateAadhar() -> Bool{
        return self.admissionData.personalInformation?.aadharCard?.count == 12
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


class AdmissionSubjectManager {
    static let shared = AdmissionSubjectManager()
    var subjectData:AdmissioSubjectData!
    /// this will be linked with the UI
    var subjectFormData = AdmissionSubjectFormForAPI() //for UI
    
    var selectedStream:AdmissionForm!
    
    
    func getProgramSelectionDataSource() -> [AdmissionSubjectDataSource]{
        var dataSource = [AdmissionSubjectDataSource]()
        
        let programheader = AdmissionSubjectDataSource(detailsCell: .programHeader, detailsObject: nil, dataSource: nil)
        dataSource.append(programheader)
        
        let streamData = self.subjectData.admissionForm?.map({$0.specilaization ?? ""})
        if ((streamData?.count ?? 0) > 1){
            let selectStream = AdmissionSubjectDataSource(detailsCell: .steam, detailsObject: nil, dataSource: streamData)
            dataSource.append(selectStream)

        }else{
            let selectStream = AdmissionSubjectDataSource(detailsCell: .subjectDetails(streamData?.first ?? ""), detailsObject: nil, dataSource: streamData)
            dataSource.append(selectStream)
        }
        return dataSource
    }
    
    fileprivate func getDataSourceForSY(_ dataSource: inout [AdmissionSubjectDataSource]) {
        //SY FLOW
        
        let sem3Compulsary = self.getCompulsarySubject(data: self.selectedStream.defaultSubjectList?.semester3?.subjectList ?? [])
        let sem3CompulsaryStringDs = sem3Compulsary.map({$0.subjectName})
                let compulsarySubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("Compulsary Sem 3 subjects"), detailsObject: nil, dataSource: sem3CompulsaryStringDs)
        dataSource.append(compulsarySubjectDs)
        
        
        let sem3Optional = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester3?.subjectList ?? [])
        let sem3OptionalStringDs = sem3Optional.map({$0.subjectName})
        let optionalSubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("Optional Sem 3 subjects"), detailsObject: nil, dataSource: sem3OptionalStringDs)
        dataSource.append(optionalSubjectDs)
        
        let sem4Compulsary = self.getCompulsarySubject(data: self.selectedStream.defaultSubjectList?.semester4?.subjectList ?? [])
        let sem4CompulsaryStringDs = sem4Compulsary.map({$0.subjectName})
        let compulsarysem4ubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("Compulsary Sem 4 subjects"), detailsObject: nil, dataSource: sem4CompulsaryStringDs)
        dataSource.append(compulsarysem4ubjectDs)
        
        
        let sem4Optional = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester4?.subjectList ?? [])
        let sem4OptionalStringDs = sem4Optional.map({$0.subjectName})
        let compulsarysem4SubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("Optional Sem 4 subjects"), detailsObject: nil, dataSource: sem4OptionalStringDs)
        dataSource.append(compulsarysem4SubjectDs)
    }
    
    fileprivate func getDataSourceForTY(_ dataSource: inout [AdmissionSubjectDataSource]) {
        //TY FLOW
        
        let sem5Compulsary = self.getCompulsarySubject(data: self.selectedStream.defaultSubjectList?.semester5?.subjectList ?? [])
        let sem5CompulsaryStringDs = sem5Compulsary.map({$0.subjectName})
        let compulsarySubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("Compulsary Sem 5 subjects"), detailsObject: nil, dataSource: sem5CompulsaryStringDs)
        dataSource.append(compulsarySubjectDs)
        
        //add subject to api form obj
        self.selectedStream.subjectSelected?.semester5?.subjectList?.forEach({ (obj) in
            var form = AdmissionFormSubject()
            form.semester = obj.semester
            form.subjectName = obj.subjectName
            form.subjectId = obj.subjectId
            form.preference = obj.preference
            self.subjectFormData.subject?.append(form)
        })

        
        
        
        for _ in 0..<(Int(self.selectedStream.defaultSubjectList?.semester5?.optionalSubjectCount ?? "") ?? 0){
            
            let sem5Optional = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester5?.subjectList ?? [])
//            let sem5OptionalStringDs = sem5Optional.map({$0.subjectName})
            
            var form = AdmissionFormSubject()
            //add empty form obbject which willl be filled when user makes selection from dropdoown
            form.semester = sem5Optional.first?.semester
            let optionalSubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectSelectCell("Optional Sem 5 subjects"), detailsObject: form, dataSource: sem5Optional)
            dataSource.append(optionalSubjectDs)
            self.subjectFormData.subject?.append(form)
            
            
        }
        
        let sem6Compulsary = self.getCompulsarySubject(data: self.selectedStream.defaultSubjectList?.semester6?.subjectList ?? [])
        let sem6CompulsaryStringDs = sem6Compulsary.map({$0.subjectName})
        let compulsarysem6ubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("Compulsary Sem 6 subjectsc"), detailsObject: nil, dataSource: sem6CompulsaryStringDs)
        dataSource.append(compulsarysem6ubjectDs)
        //add subject to api form obj
        self.selectedStream.subjectSelected?.semester6?.subjectList?.forEach({ (obj) in
            var form = AdmissionFormSubject()
            form.semester = obj.semester
            form.subjectName = obj.subjectName
            form.subjectId = obj.subjectId
            form.preference = obj.preference
            self.subjectFormData.subject?.append(form)
        })

        
        
        
        
        for _ in 0..<(Int(self.selectedStream.defaultSubjectList?.semester6?.optionalSubjectCount ?? "") ?? 0){
            let sem6Optional = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester6?.subjectList ?? [])
//            let sem6OptionalStringDs = sem6Optional.map({$0.subjectName})
            var form = AdmissionFormSubject()
            //add empty form obbject which willl be filled when user makes selection from dropdoown
            form.semester = sem6Optional.first?.semester
            self.subjectFormData.subject?.append(form)
            let compulsarysem6SubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectSelectCell("Optional Sem 6 subjects"), detailsObject: form, dataSource: sem6Optional)
            dataSource.append(compulsarysem6SubjectDs)

        }
    }

    
    func getAllProgramDatasource() -> [AdmissionSubjectDataSource]{
        var dataSource = [AdmissionSubjectDataSource]()
        
        let programheader = AdmissionSubjectDataSource(detailsCell: .programHeader, detailsObject: nil, dataSource: nil)
        dataSource.append(programheader)
        
        let streamData = self.subjectData.admissionForm?.map({$0.specilaization})
        let selectStream = AdmissionSubjectDataSource(detailsCell: .steam, detailsObject: nil, dataSource: streamData)
        dataSource.append(selectStream)
        
        let lavelDs = AdmissionSubjectDataSource(detailsCell: .level, detailsObject: self.selectedStream.level, dataSource: nil)
        dataSource.append(lavelDs)
        
        let courseDs = AdmissionSubjectDataSource(detailsCell: .course, detailsObject: self.selectedStream.courseFullName, dataSource: nil)
        dataSource.append(courseDs)
        
        let yearDs = AdmissionSubjectDataSource(detailsCell: .academicYear, detailsObject: self.selectedStream.className, dataSource: nil)
        dataSource.append(yearDs)
        
        let subjectHeader = AdmissionSubjectDataSource(detailsCell: .subjectHeader, detailsObject: nil, dataSource: nil)
        dataSource.append(subjectHeader)
        
        if !(self.selectedStream.isPreferenceFlow?.boolValue() ?? false){//Stream Flow
            if self.selectedStream.defaultSubjectList?.semester5 != nil{ //TY FLOW
                getDataSourceForTY(&dataSource)
            }
            else{//second Year
                getDataSourceForSY(&dataSource)
            }
        }else{
            //Preference Flow
            //sem - 3
            //compulsary Subject
            self.subjectFormData.subject = [AdmissionFormSubject]()
            let sem3Compulsary = self.getCompulsarySubject(data: self.selectedStream.subjectSelected?.semester3?.subjectList ?? [])
            let sem3CompulsaryStringDs = sem3Compulsary.map({$0.subjectName})
            
            for subject in sem3Compulsary{//FORM DATA FOR API
                var form = AdmissionFormSubject()
                form.semester       = subject.semester
                form.subjectName    = subject.subjectName
                form.subjectId      = subject.subjectId
                form.preference     = subject.preference
                self.subjectFormData.subject?.append(form)
            }
            let compulsarySubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("Compulsary Sem 3 subjects"), detailsObject: nil, dataSource: sem3CompulsaryStringDs)
            dataSource.append(compulsarySubjectDs)
            
            //optional subject based on preferences
            if let count = Int(self.selectedStream.subjectSelected?.semester3?.maxPreferenceCount ?? "0"),let optionalSubjectCount = Int(self.selectedStream.subjectSelected?.semester3?.optionalSubjectCount ?? "0")
            {
                var preferenceCounter = 0
                for optionalSub in 0..<optionalSubjectCount{
                    for i in 0..<count{
                        let optionalSUbjectLIst = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester3?.subjectList ?? [])
                        //                        let sem3OptionalStringDs = optionalSUbjectLIst.map({$0.subjectName})
                        //form data for api
                        var form = AdmissionFormSubject()
                        if self.selectedStream.subjectSelected?.semester3?.preferenceList != nil{
                            let thisFormObj = self.selectedStream.subjectSelected?.semester3?.preferenceList?.filter({  prefrenceSubject in
                                if let selectedSubSem = prefrenceSubject.semester, let preference = Int(prefrenceSubject.preference ?? "0"), let defaultSem = optionalSUbjectLIst.first?.semester{
                                    return selectedSubSem == defaultSem && preference == (preferenceCounter + 1)
                                }
                                return false
                            }).first
                            //add info if received from the server
                            form.semester       = thisFormObj?.semester
                            form.subjectName    = thisFormObj?.subjectName
                        }
                        form.preference = "\(preferenceCounter+1)"
                        form.semester = optionalSUbjectLIst.first?.semester //will help in comparing samme prferences from same semesters
                        preferenceCounter += 1
                        self.subjectFormData.subject?.append(form)
//                        let cellText = form.subjectName ?? "Optional Subject \(optionalSub + 1), Preference \(i+1)"
                        let optionalSubjectDS = AdmissionSubjectDataSource(detailsCell: .subjectSelectCell("Optional Subject \(optionalSub + 1), Preference \(i+1)"), detailsObject: form, dataSource: optionalSUbjectLIst) //add form obj in ds and maipulate it when the poreference is selected
                        dataSource.append(optionalSubjectDS)
                    }
                }
            }
            
            //sem - 4
            //compulsary Subject
            let sem4Compulsary = self.getCompulsarySubject(data: self.selectedStream.subjectSelected?.semester4?.subjectList ?? [])
            let sem4CompulsaryStringDs = sem4Compulsary.map({$0.subjectName})
            for subject in sem4Compulsary{//FORM DATA FOR API
                var form = AdmissionFormSubject()
                form.semester       = subject.semester
                form.subjectName    = subject.subjectName
                form.subjectId      = subject.subjectId
                form.preference     = subject.preference
                self.subjectFormData.subject?.append(form)
            }
            let compulsarySem4SubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("Compulsary Sem 4 subjects"), detailsObject: nil, dataSource: sem4CompulsaryStringDs)
            dataSource.append(compulsarySem4SubjectDs)
            
            //optional subject based on preferences
            if let count = Int(self.selectedStream.subjectSelected?.semester4?.maxPreferenceCount ?? "0"),let optionalSubjectCount = Int(self.selectedStream.subjectSelected?.semester3?.optionalSubjectCount ?? "0"){
                var preferenceCounter = 0
                for optionalSub in 0..<optionalSubjectCount{
                    for i in 0..<count{
                        let optionalSUbjectLIst = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester4?.subjectList ?? [])
//                        let sem4OptionalStringDs = optionalSUbjectLIst.map({$0.subjectName})
                        //form data for api
                        var form = AdmissionFormSubject()
                        if self.selectedStream.subjectSelected?.semester4?.preferenceList != nil{
                            let thisFormObj = self.selectedStream.subjectSelected?.semester4?.preferenceList?.filter({  prefrenceSubject in
                                if let selectedSubSem = prefrenceSubject.semester, let preference = Int(prefrenceSubject.preference ?? "0"), let defaultSem = optionalSUbjectLIst.first?.semester{
                                    return selectedSubSem == defaultSem && preference == (preferenceCounter + 1)
                                }
                                return false
                            }).first
                            //add info if received from the server
                            form.semester       = thisFormObj?.semester
                            form.subjectName    = thisFormObj?.subjectName
                        }
                        form.preference = "\(preferenceCounter+1)"
                        form.semester = optionalSUbjectLIst.first?.semester //will help in comparing samme prferences from same semesters
                        preferenceCounter += 1
                        self.subjectFormData.subject?.append(form)
//                        let cellText = form.subjectName ?? "Optional Subject \(optionalSub + 1), Preference \(i+1)"
                        let optionalSubjectDS = AdmissionSubjectDataSource(detailsCell: .subjectSelectCell("Optional Subject \(optionalSub + 1), Preference \(i+1)"), detailsObject: form, dataSource: optionalSUbjectLIst)
                        dataSource.append(optionalSubjectDS)
                    }
                }
            }
        }
        
        
        return dataSource
    }
    
    
    
    func getClassMasterId(selection:Int) -> Int
    {
        if let form = self.subjectData.admissionForm?[selection], let masterId = form.classMasterId{
            return Int(masterId) ?? 0
            
        }
        return 0
    }
    
    func prepareAPIData(){//ONLY FOR API, N0 UI CHANGES INVOLVED
        self.subjectFormData.level          = self.selectedStream.level
        self.subjectFormData.academicYesr   = self.selectedStream.className
        self.subjectFormData.className      = self.selectedStream.className
        self.subjectFormData.collegeClassId = self.selectedStream.classMasterId
        self.subjectFormData.courseFullName = self.selectedStream.courseFullName
        if !(self.selectedStream.isPreferenceFlow?.boolValue() ?? false){ //Sream Flow
            self.subjectFormData.subject = [AdmissionFormSubject]()
            
            if !(self.selectedStream.defaultSubjectList?.semester5 != nil){
                self.selectedStream.subjectSelected?.semester3?.subjectList?.forEach({ (obj) in
                    var form = AdmissionFormSubject()
                    form.semester = obj.semester
                    form.subjectName = obj.subjectName
                    form.subjectId = obj.subjectId
                    form.preference = obj.preference
                    self.subjectFormData.subject?.append(form)
                })
                
                selectedStream.subjectSelected?.semester4?.subjectList?.forEach({ (obj) in
                    var form = AdmissionFormSubject()
                    form.semester = obj.semester
                    form.subjectName = obj.subjectName
                    form.subjectId = obj.subjectId
                    form.preference = obj.preference
                    self.subjectFormData.subject?.append(form)
                })
            }
        }
        else{
            /*
            //Preference flow
            self.subjectFormData.subject = [AdmissionFormSubject]()
            //Compulsary subject SEM 3
            let compulsarySubjectSem3 = self.getCompulsarySubject(data: self.selectedStream.defaultSubjectList?.semester3?.subjectList ?? [])
            for subjet in compulsarySubjectSem3{
                var form = AdmissionFormSubject()
                form.semester       = subjet.semester
                form.subjectName    = subjet.subjectName
                form.subjectId      = subjet.subjectId
                form.preference     = subjet.preference
                self.subjectFormData.subject?.append(form)
            }
            
            //OPTIONAL SUBJECT SEM 3
            if let sem3PreferenceCount  = Int(self.selectedStream.subjectSelected?.semester3?.maxPreferenceCount ?? "0"), let sem3OptionalSubCount = Int(self.selectedStream.subjectSelected?.semester3?.optionalSubjectCount ?? "0"){
                let preferenceCount = sem3PreferenceCount * sem3OptionalSubCount
                for i in 0..<preferenceCount{
                    var form = AdmissionFormSubject()
                    form.preference = "\(i+1)"
                    self.subjectFormData.subject?.append(form)
                }
            }

            //Compulsary subject SEM 4
            let compulsarySubjectSem4 = self.getCompulsarySubject(data: self.selectedStream.defaultSubjectList?.semester4?.subjectList ?? [])
            for subjet in compulsarySubjectSem4{
                var form = AdmissionFormSubject()
                form.semester       = subjet.semester
                form.subjectName    = subjet.subjectName
                form.subjectId      = subjet.subjectId
                form.preference     = subjet.preference
                self.subjectFormData.subject?.append(form)
            }

            //OPTIONAL SUBJECT SEM 4
            if let sem4PreferenceCount  = Int(self.selectedStream.subjectSelected?.semester4?.maxPreferenceCount ?? "0"), let sem4OptionalSubCount = Int(self.selectedStream.subjectSelected?.semester4?.optionalSubjectCount ?? "0"){
                let preferenceCount = sem4PreferenceCount * sem4OptionalSubCount
                for i in 0..<preferenceCount{
                    var form = AdmissionFormSubject()
                    form.preference = "\(i+1)"
                    self.subjectFormData.subject?.append(form)
                }
            }
            */
        }
    }
    
    
    func copyDefaultSubjectToSelectedSubject(){
        var sem3Data = self.selectedStream.defaultSubjectList?.semester3
        var sem4Data = self.selectedStream.defaultSubjectList?.semester4
        sem3Data?.preferenceList = self.selectedStream.subjectSelected?.semester3?.preferenceList
        sem4Data?.preferenceList = self.selectedStream.subjectSelected?.semester4?.preferenceList
        self.selectedStream.subjectSelected?.semester3 = AdmissionSemester()
        self.selectedStream.subjectSelected?.semester4 = AdmissionSemester()
        self.selectedStream.subjectSelected?.semester3 = sem3Data
        self.selectedStream.subjectSelected?.semester4 = sem4Data
    }
    
    func getSubjectStringArrayy(data:[AdmnissionSubjectList], isCompulsary:Bool) -> [String]{
        return [String]()
    }
    
    func getCompulsarySubject(data:[AdmnissionSubjectList]) -> [AdmnissionSubjectList]{
        return data.filter({$0.mandatory ?? "" ==  "1"})
    }
    
    func getOptionalSubject(data:[AdmnissionSubjectList]) -> [AdmnissionSubjectList]{
        return data.filter({$0.mandatory ?? "" ==  "0"})
    }
    
    func isDataValid() -> Bool{
        if !(selectedStream.isPreferenceFlow?.boolValue() ?? true){
            return true
        }else{
            return self.subjectFormData.subject?.contains(where: { (subject) -> Bool in
                return subject.preference != nil
            }) ?? false
        }
    }
    
    func sendFormtwoData(_ completion:@escaping ([String:Any]?) -> (),
                         _ failure:@escaping () -> ())
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.submitCampusDetails
        var params = [String:Any]()
        do {
            let personalInfoData = try JSONEncoder().encode(self.subjectFormData)
            let json = try JSONSerialization.jsonObject(with: personalInfoData, options: [])
            guard let dictionary = json as? [String : Any] else {
                return
            }
            params = dictionary
            var subjectArray = [[String:Any]]()
            for subject in self.subjectFormData.subject ?? []{
                var subjectParams:[String:Any] = ["semester":"\(subject.semester ?? "")"]
                subjectParams["subject_id"] = subject.subjectId ?? ""
                subjectParams["subject_name"] = subject.subjectName ?? ""
                subjectParams["preference"] = subject.preference ?? "0"
                subjectArray.append(subjectParams)
            }
            
            let subjectList = subjectArray
            var requestText = ""
            if let theJSONData = try? JSONSerialization.data(withJSONObject: subjectList,options: []){
                let theJSONText = String(data: theJSONData,encoding: .ascii)
                requestText = theJSONText ?? "NA"
                print("requestString = \(theJSONText!)")
            }
            
            params["subject"] = requestText
            
        } catch let error{
            print("err", error)
        }
        params["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        params["role_id"] = "1"
        params["admission_form_id"] = "\(AdmissionBaseManager.shared.formID ?? 0)"

        manager.apiPostWithDataResponse(apiName: "Submit seubject selection data for admission", parameters:params , completionHandler: { (result, code, response) in
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
