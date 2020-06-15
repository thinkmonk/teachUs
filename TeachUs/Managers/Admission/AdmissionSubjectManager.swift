//
//  AdmissionSubjectManager.swift
//  TeachUs
//
//  Created by iOS on 15/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class AdmissionSubjectManager {
    static let shared = AdmissionSubjectManager()
    var subjectData:AdmissioSubjectData!
    /// this will be linked with the UI
    var subjectFormData = AdmissionSubjectFormForAPI() //for UI
    var shouldDisableStreamSelection:Bool = false

    var selectedStream:AdmissionForm!
    
    
    func getProgramSelectionDataSource() -> [AdmissionSubjectDataSource]{
        var dataSource = [AdmissionSubjectDataSource]()
        
        let programheader = AdmissionSubjectDataSource(detailsCell: .programHeader, detailsObject: nil, dataSource: nil)
        dataSource.append(programheader)
        
        let streamData = self.subjectData.admissionForm?.map({$0.specilaization ?? ""})
        if ((streamData?.count ?? 0) > 1){
            let selectStream = AdmissionSubjectDataSource(detailsCell: .steam, detailsObject: nil, dataSource: streamData, shouldDisableObj: self.shouldDisableStreamSelection)
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
        if sem3CompulsaryStringDs.count > 0 {
            let compulsarySubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("List of compulsary subjects (semester 3)"), detailsObject: nil, dataSource: sem3CompulsaryStringDs, placeholder: "\(sem3CompulsaryStringDs.count) Subjects")
            dataSource.append(compulsarySubjectDs)
        }
        
        
        let sem3Optional = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester3?.subjectList ?? [])
        let sem3OptionalStringDs = sem3Optional.map({$0.subjectName})
        if sem3OptionalStringDs.count > 0{
            let optionalSubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("List of optional subjects (semester 3)"), detailsObject: nil, dataSource: sem3OptionalStringDs, placeholder: "\(sem3OptionalStringDs.count) Subjects")
            dataSource.append(optionalSubjectDs)
        }
        
        let sem4Compulsary = self.getCompulsarySubject(data: self.selectedStream.defaultSubjectList?.semester4?.subjectList ?? [])
        let sem4CompulsaryStringDs = sem4Compulsary.map({$0.subjectName})
        if sem4CompulsaryStringDs.count > 0{
            let compulsarysem4ubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("List of compulsary subjects (semester 4)"), detailsObject: nil, dataSource: sem4CompulsaryStringDs, placeholder: "\(sem4CompulsaryStringDs.count) Subjects")
            dataSource.append(compulsarysem4ubjectDs)
        }
        
        
        let sem4Optional = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester4?.subjectList ?? [])
        let sem4OptionalStringDs = sem4Optional.map({$0.subjectName})
        if sem4OptionalStringDs.count > 0{
            let compulsarysem4SubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("List of optional subjects (semester 4)"), detailsObject: nil, dataSource: sem4OptionalStringDs, placeholder: "\(sem4OptionalStringDs.count) Subjects")
            dataSource.append(compulsarysem4SubjectDs)
        }
    }
    
    fileprivate func getDataSourceForTY(_ dataSource: inout [AdmissionSubjectDataSource]) {
        //TY FLOW
        //will be same for selected and default.
        let sem5Compulsary = self.getCompulsarySubject(data: self.selectedStream.defaultSubjectList?.semester5?.subjectList ?? [])
        let sem5CompulsaryStringDs = sem5Compulsary.map({$0.subjectName})
        let compulsarySubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("List of compulsary subjects (semester 5)"), detailsObject: nil, dataSource: sem5CompulsaryStringDs, placeholder: "\(sem5CompulsaryStringDs.count) Subjects")
        dataSource.append(compulsarySubjectDs)
        
        
        sem5Compulsary.forEach({ (obj) in
            var form = AdmissionFormSubject()
            form.semester = obj.semester
            form.subjectName = obj.subjectName
            form.subjectId = obj.subjectId
            form.preference = obj.preference
            form.mandatory  = obj.mandatory
            self.subjectFormData.subject?.append(form)
        })

        let optionalSem5SubjectCount = self.selectedStream.defaultSubjectList?.semester5?.optionalSubjectCount ?? ""
        for i in 0..<(Int(optionalSem5SubjectCount) ?? 0){
            
            let sem5Optional = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester5?.subjectList ?? [])
//            let sem5OptionalStringDs = sem5Optional.map({$0.subjectName})
            
            var form = AdmissionFormSubject()
            //add empty form obbject which willl be filled when user makes selection from dropdoown
            form.semester = sem5Optional.first?.semester
            form.mandatory = sem5Optional.first?.mandatory
            form.preferenceRank = "\(i)"
            form.preference = "\(i+1)"
            
            
            //if we get selected subject from API
            if  ((self.selectedStream.subjectSelected?.semester5?.subjectList?.count ?? 0) > 0){
                let sem5SelectedOptional = self.getOptionalSubject(data: self.selectedStream.subjectSelected?.semester5?.subjectList ?? [])
                if i < sem5SelectedOptional.count{
                    let selectedSubject = sem5SelectedOptional[i]
                    form.subjectName = selectedSubject.subjectName
                    form.subjectId = selectedSubject.subjectId
                }
            }
            
            let optionalSubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectSelectCell("Semester 5 - Select optional subject \(i+1)"), detailsObject: form, dataSource: sem5Optional, placeholder: "Optional Subject \(i+1)", preferenceCountObj: "\(i)")
            dataSource.append(optionalSubjectDs)
            self.subjectFormData.subject?.append(form)
        }
        
        let sem6Compulsary = self.getCompulsarySubject(data: self.selectedStream.defaultSubjectList?.semester6?.subjectList ?? [])
        let sem6CompulsaryStringDs = sem6Compulsary.map({$0.subjectName})
        let compulsarysem6ubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("List of compulsary subjects (semester 6)"), detailsObject: nil, dataSource: sem6CompulsaryStringDs, placeholder: "\(sem6CompulsaryStringDs.count) Subjects")
        dataSource.append(compulsarysem6ubjectDs)
        //add subject to api form obj
//        self.selectedStream.defaultSubjectList?.semester6?.subjectList?.forEach({ (obj) in
//            var form = AdmissionFormSubject()
//            form.semester = obj.semester
//            form.subjectName = obj.subjectName
//            form.subjectId = obj.subjectId
//            form.preference = obj.preference
//            form.mandatory  = obj.mandatory
//            self.subjectFormData.subject?.append(form)
//        })
 
        sem6Compulsary.forEach({ (obj) in
            var form = AdmissionFormSubject()
            form.semester = obj.semester
            form.subjectName = obj.subjectName
            form.subjectId = obj.subjectId
            form.preference = obj.preference
            form.mandatory  = obj.mandatory
            self.subjectFormData.subject?.append(form)
        })

        
        let optionalSem6SubjectCount = self.selectedStream.defaultSubjectList?.semester6?.optionalSubjectCount ?? ""
        for i in 0..<(Int(optionalSem6SubjectCount) ?? 0){
            let sem6Optional = self.getOptionalSubject(data: self.selectedStream.defaultSubjectList?.semester6?.subjectList ?? [])
//            let sem6OptionalStringDs = sem6Optional.map({$0.subjectName})
            var form = AdmissionFormSubject()
            //add empty form obbject which willl be filled when user makes selection from dropdoown
            form.semester = sem6Optional.first?.semester
            form.mandatory = sem6Optional.first?.mandatory
            form.preferenceRank = "\(i)"
            form.preference = "\(i+1)"
            
            //if we get selected subject from API
            if  ((self.selectedStream.subjectSelected?.semester6?.subjectList?.count ?? 0) > 0){
                let sem6SelectedOptional = self.getOptionalSubject(data: self.selectedStream.subjectSelected?.semester6?.subjectList ?? [])
                if i < sem6SelectedOptional.count{
                    let selectedSubject = sem6SelectedOptional[i]
                    form.subjectName = selectedSubject.subjectName
                    form.subjectId = selectedSubject.subjectId
                }
            }

            
            let optionalsem6SubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectSelectCell("Semester 6 - Select optional subject \(i+1)"), detailsObject: form, dataSource: sem6Optional, placeholder: "Optional Subject \(i+1)", preferenceCountObj: "\(i)")
            dataSource.append(optionalsem6SubjectDs)
            self.subjectFormData.subject?.append(form)

        }
    }

    
    func getAllProgramDatasource() -> [AdmissionSubjectDataSource]{
        var dataSource = [AdmissionSubjectDataSource]()
        
        let programheader = AdmissionSubjectDataSource(detailsCell: .programHeader, detailsObject: nil, dataSource: nil)
        dataSource.append(programheader)
        
        let streamData = self.subjectData.admissionForm?.map({$0.specilaization})
        let selectStream = AdmissionSubjectDataSource(detailsCell: .steam, detailsObject: nil, dataSource: streamData, shouldDisableObj: self.shouldDisableStreamSelection)
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
                form.preference     = subject.preference ?? "0"
                self.subjectFormData.subject?.append(form)
            }
            let compulsarySubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("List of compulsary subjects (semester 3)"), detailsObject: nil, dataSource: sem3CompulsaryStringDs, placeholder: "\(sem3Compulsary.count) Subjects")
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
                            form.subjectId      = thisFormObj?.subjectId
                            form.semester       = thisFormObj?.semester
                            form.subjectName    = thisFormObj?.subjectName
                        }
                        form.preference = "\(preferenceCounter+1)"
                        form.semester = optionalSUbjectLIst.first?.semester //will help in comparing samme prferences from same semesters
                        preferenceCounter += 1
                        self.subjectFormData.subject?.append(form)
//                        let cellText = form.subjectName ?? "Optional Subject \(optionalSub + 1), Preference \(i+1)"
                        let optionalSubjectDS = AdmissionSubjectDataSource(detailsCell: .subjectSelectCell("Optional Subject \(optionalSub + 1), Preference \(i+1)"), detailsObject: form, dataSource: optionalSUbjectLIst, placeholder: "\(optionalSUbjectLIst.count) Subjects") //add form obj in ds and maipulate it when the poreference is selected
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
                form.preference     = subject.preference ?? "0"
                self.subjectFormData.subject?.append(form)
            }
            let compulsarySem4SubjectDs = AdmissionSubjectDataSource(detailsCell: .subjectDetails("List of compulsary subjects (semester 4)"), detailsObject: nil, dataSource: sem4CompulsaryStringDs, placeholder: "\(sem4Compulsary.count) Subjects")
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
                            form.subjectId      = thisFormObj?.subjectId
                            form.semester       = thisFormObj?.semester
                            form.subjectName    = thisFormObj?.subjectName
                        }
                        form.preference = "\(preferenceCounter+1)"
                        form.semester = optionalSUbjectLIst.first?.semester //will help in comparing samme prferences from same semesters
                        preferenceCounter += 1
                        self.subjectFormData.subject?.append(form)
//                        let cellText = form.subjectName ?? "Optional Subject \(optionalSub + 1), Preference \(i+1)"
                        let optionalSubjectDS = AdmissionSubjectDataSource(detailsCell: .subjectSelectCell("Optional Subject \(optionalSub + 1), Preference \(i+1)"), detailsObject: form, dataSource: optionalSUbjectLIst, placeholder: "\(optionalSUbjectLIst.count) Subjects")
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
            return !(self.subjectFormData.subject?.contains(where: { (subject) -> Bool in
                return (subject.preference == nil || subject.subjectId == nil || subject.subjectName == nil)
            }) ?? false)
        }
    }
    
    func checkForDuplicateSubejects(_ subjectObj:AdmnissionSubjectList) -> Bool{
        if let count = self.subjectFormData.subject?.filter({ (subjectfilerObj) -> Bool in
            return subjectfilerObj.subjectName?.lowercased() == subjectObj.subjectName?.lowercased() && subjectfilerObj.semester?.lowercased() == subjectObj.semester
        }).count{
            return count >= 1
        }
        return false
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
