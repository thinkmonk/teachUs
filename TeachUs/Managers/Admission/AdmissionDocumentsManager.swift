//
//  AdmissionDocumentsManager.swift
//  TeachUs
//
//  Created by iOS on 06/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class AdmissionDocumentsManager{
    static let shared = AdmissionDocumentsManager()
    var docuemtnsData:AdmissionDocuments!
    var dataSource = [AdmissionDocumentsRowDatasource]()
    var dispatchGroup = DispatchGroup()
    
    func makeDataSource(){
        dataSource.removeAll()
        
        let headerDs = AdmissionDocumentsRowDatasource(detailsCell: .dcoumentsTitle, detailsObject: "", dataSource: nil)
        self.dataSource.append(headerDs)
        
        let photoDs = AdmissionDocumentsRowDatasource(detailsCell: .photo, detailsObject: self.docuemtnsData.personalInformation?.photo, dataSource: nil)
        self.dataSource.append(photoDs)
        
        let signatureDs = AdmissionDocumentsRowDatasource(detailsCell: .signatue, detailsObject: self.docuemtnsData.personalInformation?.sign, dataSource: nil)
        self.dataSource.append(signatureDs)
        
    }
    
    func validateaAllInputData() -> Bool{
        for data in dataSource{
            if (data.cellType != .dcoumentsTitle && data.attachedObject == nil){
                return false
            }
        }
        return true//return true if loop is compoleted
    }
    
    func uploadDocumentstoServer(formId:Int
        ,_ completion:@escaping ([String:Any]?) -> (),
         _ failure:@escaping () -> ())
    {
        if let window = UIApplication.shared.keyWindow{
            LoadingActivityHUD.showProgressHUD(view: window)
        }
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.submitDocuments
        
        var params = [String:Any]()
        params["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        params["role_id"] = "1"
        params["admission_form_id"] = "\(formId)"
        
        
        for data in dataSource{
            if data.cellType == .photo, let image = data.attachedObject as? UIImage{
                dispatchGroup.enter()
                self.getBase64StringImage(image: image, { imageObj in
                     params["photo"] = imageObj
                    self.dispatchGroup.leave()
                })
            }
            
            if data.cellType == .signatue, let image = data.attachedObject as? UIImage{
                dispatchGroup.enter()
                self.getBase64StringImage(image: image, { imageObj in
                    params["sign"] = imageObj
                    self.dispatchGroup.leave()
                })
            }
        }
        dispatchGroup.notify(queue: .main) {
            manager.apiPostWithDataResponse(apiName: "Update document form data.", parameters:params , completionHandler: { (result, code, response) in
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
            print("compresss \(bcf.string(fromByteCount: Int64(imageData.count)))")
            DispatchQueue.main.async {
                 completion(imageData.base64EncodedString(options: .lineLength64Characters))
            }
        }
    }
}
