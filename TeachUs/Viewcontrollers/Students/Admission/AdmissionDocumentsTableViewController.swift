//
//  AdmissionDocumentsTableViewController.swift
//  TeachUs
//
//  Created by iOS on 06/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices


class AdmissionDocumentsTableViewController: BaseTableViewController {

    var imagePicker:UIImagePickerController = UIImagePickerController()
    var curentCellIndexPath:IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AdmissionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionHeader)
        self.tableView.register(UINib(nibName: "AdmissionDocumentPicketTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.documentsImageCell)

        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = true
        self.tableView.separatorStyle = .none


        addRightBarButton()
        getRecordData()

    }
    
    func getRecordData(){
        self.title = "Page 5/5"
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.getDocuments
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id": "\(1)",
            "admission_form_id":"\(AdmissionBaseManager.shared.formID ?? 0)",
        ]
        
        manager.apiPostWithDataResponse(apiName: "get docuemnts data", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                let data = try decoder.decode(AdmissionDocuments.self, from: response)
                AdmissionDocumentsManager.shared.docuemtnsData = data
                AdmissionDocumentsManager.shared.makeDataSource()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func addRightBarButton(){
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20 ))
        rightButton.setTitle("Proceed", for: .normal)
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rightButton.addTarget(self, action: #selector(proceedAction), for: .touchUpInside)
        
        // Bar button item
        let bellButtomItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItems  = [bellButtomItem]
        
    }
    
    @objc func proceedAction(){
        self.view.endEditing(true)
        
        
        if (AdmissionDocumentsManager.shared.validateaAllInputData()){
            self.showAlertWithTitleAndCompletionHandlers("Confirm submission", alertMessage: "Are you sure you want to submit the admission form? \n \n You won't be able to edit it afterwards", okButtonString: "Confirm", canelString: "Recheck", okAction: {
                AdmissionDocumentsManager.shared.uploadDocumentstoServer(formId: AdmissionBaseManager.shared.formID, { (dict) in
                    if let message  = dict?["message"] as? String{
                        self.showAlertWithOKTitleAndCompletionHandlers("Success", alertMessage: message, okButtonString: "OK") {//go to status view controller
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: AdmissionStatusViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                    }
                }) {
                    self.showAlertWithTitle("Failed", alertMessage: "Please Retry")
                }
            }) {
                //cancel clicked do nothing.
            }
        }else{
            self.showAlertWithTitle("Failed", alertMessage: "Please fill up all the required text fields")
        }
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AdmissionDocumentsManager.shared.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ds = AdmissionDocumentsManager.shared.dataSource[indexPath.row]
        
        switch ds.cellType {
        case .dcoumentsTitle:
            let cell:AdmissionHeaderTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionHeader, for: indexPath) as! AdmissionHeaderTableViewCell
            cell.setUp(dsObj: ds)
            return cell
            
        case .photo,
             .signatue://
            let cell:AdmissionDocumentPicketTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.documentsImageCell, for: indexPath) as! AdmissionDocumentPicketTableViewCell
            cell.buttonUploadImage.indexPath = indexPath
            cell.buttondeleteData.indexPath = indexPath
            cell.setUpData(dsObj: ds)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ds = AdmissionDocumentsManager.shared.dataSource[indexPath.row]
        if ds.cellType == .photo || ds.cellType == .signatue{
            if ds.attachedObject != nil{
                return 300
            }
        }else if ds.cellType == .dcoumentsTitle{
            return 60
        }
        return 100
    }

}

extension AdmissionDocumentsTableViewController{
    func actionUploadDocument(_ sender: Any?) {
        let alert:UIAlertController=UIAlertController(title: "Choose documents", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }else{
            self.showAlertWithTitle("Oops!", alertMessage: "Camera Access Not Provided")
            
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            self.showAlertWithTitle("Oops!", alertMessage: "Photo Library Access Not Provided")
        }
    }
}


extension AdmissionDocumentsTableViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let cellDataSource = AdmissionDocumentsManager.shared.dataSource[curentCellIndexPath.row]
            cellDataSource.setValues(value: image)
            self.tableView.reloadRows(at: [curentCellIndexPath], with: .fade)
            
            let data = UIImagePNGRepresentation(image)
            UserDefaults.standard.setValue(data, forKey: Constants.UserDefaults.noticeImage)
        }
        
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
//                labelAttachmentText.text = assetResources.first!.originalFilename
                print(assetResources.first!.originalFilename)
                UserDefaults.standard.setValue(assetResources.first!.originalFilename, forKey: Constants.UserDefaults.noticeImageName)

            }
        } else {
            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                print(assetResources.first!.originalFilename)
//                labelAttachmentText.text = assetResources.first!.originalFilename
                UserDefaults.standard.setValue(assetResources.first!.originalFilename, forKey: Constants.UserDefaults.noticeImageName)

            }
        }
        imagePicker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


extension AdmissionDocumentsTableViewController:DocumentPickerDelegate{
    func uploadImage(sender: ButtonWithIndexPath) {
        if let indexPath = sender.indexPath{
            curentCellIndexPath = indexPath
            self.actionUploadDocument(nil)
        }
    }
    
    func deleteImage(sender: ButtonWithIndexPath) {
        if let indexPath = sender.indexPath{
            curentCellIndexPath = indexPath
            let cellDataSource = AdmissionDocumentsManager.shared.dataSource[curentCellIndexPath.row]
            cellDataSource.attachedObject = nil
            self.tableView.reloadRows(at: [curentCellIndexPath], with: .fade)
        }
    }
}
