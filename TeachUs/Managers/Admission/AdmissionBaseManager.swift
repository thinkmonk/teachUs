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
    var formDetails:AdmissionPdfDetails!
    
    func getAdmissionPDFDetails(completion:@escaping (_ details:AdmissionPdfDetails) -> (),
                                failure:@escaping(String) -> ()){
        if let window = UIApplication.shared.keyWindow{
            LoadingActivityHUD.showProgressHUD(view: window)
        }
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.getSavedData
        let params = ["college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                        "role_id":"1"]
        manager.apiPostWithDataResponse(apiName: "Get form data.", parameters:params , completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.formDetails = try decoder.decode(AdmissionPdfDetails.self, from: response)
                completion(self.formDetails)
            } catch let error{
                print("err", error)
                failure(error.localizedDescription)
                
            }
        }) { (error, code, message) in
            failure(message)
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func emailPDF(_ emailId:String,
                   completion:@escaping ([String:Any]?) -> (),
                   failure:@escaping(String) -> ())
    {
        if let window = UIApplication.shared.keyWindow{
            LoadingActivityHUD.showProgressHUD(view: window)
        }
        
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.emailPDF
        guard let formId = self.formID else {
            return
        }
        let params = ["college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"1",
            "admission_form_id":"\(formId)",
            "email_id":"\(emailId)"]
        manager.apiPostWithDataResponse(apiName: "Email PDF to user.", parameters:params , completionHandler: { (result, code, response) in
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
            failure(message)
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func uploadTransactionDetails(_ txnId:String,
                                  _ txnImage: UIImage,
                                  completion:@escaping ([String:Any]?) -> (),
                                  failure:@escaping(String) -> ())
    {
        if let window = UIApplication.shared.keyWindow{
            LoadingActivityHUD.showProgressHUD(view: window)
        }
        
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.feePaymentDetails
        var params = ["college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"1",
            "fee_payment_transaction_id":"\(txnId)"]
        
        self.getBase64StringImage(image: txnImage) { (imageObj) in
            params["fee_payment_photo"] = imageObj
            manager.apiPostWithDataResponse(apiName: "Email PDF to user.", parameters:params , completionHandler: { (result, code, response) in
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
                failure(message)
                print(message)
                LoadingActivityHUD.hideProgressHUD()
            }
        }
        
        

    }
    
 
    private func getBase64StringImage(image:UIImage,_ completion: @escaping (String) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let imageSizeKB = image.getSizeInKb()
            print("size of image in KB: %f ", Double(imageSizeKB))
            if(imageSizeKB >= 500.0){
                do {
                    try image.compressImage(400, completion: { (image, compressRatio) in
                        print(image.size)
                    })
                } catch let error{
                    print("Error \(error.localizedDescription)")
                }
                //           profileImage = profileImage!.compressImagge()
                print("compressed image size = \(image.getSizeInKb())")
            }
            var compressionRatio:CGFloat = 1.0
            if image.getSizeInKb() > 500{
                compressionRatio = CGFloat(499.0/image.getSizeInKb()) //for a safer size taking 499.0kb as a base
            }
            let imageData:NSData = UIImageJPEGRepresentation(image, compressionRatio)! as NSData
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            print("compresss size \(bcf.string(fromByteCount: Int64(imageData.count))) ratio \(compressionRatio)")
            DispatchQueue.main.async {
                 completion(imageData.base64EncodedString(options: .lineLength64Characters))
            }
        }
    }
}
