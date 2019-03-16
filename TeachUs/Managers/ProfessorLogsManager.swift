//
//  ProfessorLogsManager.swift
//  TeachUs
//
//  Created by ios on 3/16/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
class ProfessorLogsManager{
    static let sharedManager  = ProfessorLogsManager()
    var collegeProfessorList:CollegeProfessorList?
    
    
    func getAllProfessorlist(completion: @escaping(_ isPresent:Bool) -> Void){
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getProfessorListForACollege
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        var parameters:[String:Any] = [:]
        parameters["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"

        manager.apiPostWithDataResponse(apiName: "Get Professor List for college logs", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                do{
                    let decoder = JSONDecoder()
                    self.collegeProfessorList = try decoder.decode(CollegeProfessorList.self, from: response)
                    self.collegeProfessorList?.professorSubjects.sort(by: { $0.professorName! < $1.professorName! })
                    completion(true)
                }
                catch let error{
                    print("err", error)
                    completion(false)
                }
            }
            else{
                completion(false)
                print("Error in fetching data")
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
}
