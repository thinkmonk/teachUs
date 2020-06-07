//
//  AdmissionBaseManager.swift
//  TeachUs
//
//  Created by iOS on 07/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class AdmissionBaseManager{
    static let shared = AdmissionBaseManager()
    var formID : Int!
    
    func getAdmissionPDFDetails(completion:@escaping (_ details:AdmissionPdfDetails) -> (),
                                failure:@escaping(String) -> ()){
        if let window = UIApplication.shared.keyWindow{
            LoadingActivityHUD.showProgressHUD(view: window)
        }
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.getSavedData
        let params = ["college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"1",
            "admission_form_id":"\(String(describing: self.formID))"]
        manager.apiPostWithDataResponse(apiName: "Update academic form data.", parameters:params , completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                let data = try decoder.decode(AdmissionPdfDetails.self, from: response)
                completion(data)
            } catch let error{
                print("err", error.localizedDescription)
                failure(error.localizedDescription)
                
            }
        }) { (error, code, message) in
            failure(message)
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
}
