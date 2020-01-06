//
//  AddNewNoticeViewController.swift
//  TeachUs
//
//  Created by ios on 6/2/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import FirebaseStorage
import MobileCoreServices
import RxSwift
import RxCocoa
import Photos

protocol AddNewNoticeDelegate:class {
    func viewDismissed(isNoticeAdded:Bool?)
}

class AddNewNoticeViewController: BaseViewController {
    
    @IBOutlet weak var viewAddNoticeWrapper: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var viewTilteBg: UIView!
    @IBOutlet weak var textfieldNoticeTitle: UITextField!
    @IBOutlet weak var viewDescriptionBg: UIView!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var buttonAddNotice: UIButton!
    @IBOutlet weak var labelClassNames: UILabel!
    @IBOutlet weak var buttonSelectClass: UIButton!
    @IBOutlet weak var buttonPreviewNotice: UIButton!
    @IBOutlet weak var roleSwitch: UISwitch!
    @IBOutlet weak var labelAttachmentText: UILabel!
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    weak var documentPicker:UIDocumentPickerViewController!
//    var chosenFile:URL?
//    var chosenImage:UIImage?
    var viewClassList : ViewClassSelection!
    let storage = Storage.storage()
    weak var delegate:AddNewNoticeDelegate?
    
    var noticeTitle = Variable<String>("")
    var noticeDescription = Variable<String>("")
    var chosenImage = Variable<UIImage?>(nil)
    var chosenFile =  Variable<URL?>(URL(string: ""))
    var myDisposeBag = DisposeBag()
    var noticeAddedFlag:Bool? = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewNoticeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewNoticeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.initClassSelectionView()
        self.buttonPreviewNotice.isHidden = true
        imagePicker?.delegate = self
        self.setUpDefaultValues()
        self.setUpRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAddNoticeWrapper.makeEdgesRounded()
        self.viewDescriptionBg.makeEdgesRounded()
        self.viewTilteBg.makeEdgesRounded()
        self.buttonPreviewNotice.roundedRedButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        #if DEBUG
        print("AddNewNoticeViewController deinited")
        #endif
    }
    
    func initClassSelectionView(){
        self.viewClassList = ViewClassSelection.instanceFromNib() as? ViewClassSelection
        self.viewClassList.delegate = self
    }
    
    func setUpRx(){
        self.textfieldNoticeTitle.rx.text.map{$0 ?? ""}.bind(to: self.noticeTitle).disposed(by: myDisposeBag)
        self.textViewDescription.rx.text.map{$0 ?? ""}.bind(to: self.noticeDescription).disposed(by: myDisposeBag)
        
        
        
        var isValid : Observable<Bool> {
            return Observable.combineLatest(self.noticeTitle.asObservable(), self.noticeDescription.asObservable(), self.chosenFile.asObservable(), self.chosenImage.asObservable()){ title, description, file, image in
                UserDefaults.standard.set(title, forKey: Constants.UserDefaults.noticeTitle)
                UserDefaults.standard.set(description, forKey: Constants.UserDefaults.noticeDescription)
                return title.count > 2 && description.count > 2
            }
        }
        
        isValid.asObservable().subscribe(onNext: {[weak self] (isValid) in
            self?.buttonPreviewNotice.isHidden = !isValid
        }).disposed(by: myDisposeBag)
        
    }
    
    func setUpDefaultValues(){
        if let defaultTitle = UserDefaults.standard.value(forKey: Constants.UserDefaults.noticeTitle) as? String{
            self.textfieldNoticeTitle.text = defaultTitle
            self.noticeTitle.value = defaultTitle
        }
            
        if let defaultDesc = UserDefaults.standard.value(forKey: Constants.UserDefaults.noticeDescription) as? String{
            self.textViewDescription.text = defaultDesc
            self.noticeDescription.value = defaultDesc
        }
        
        if let defaultImageName = UserDefaults.standard.value(forKey: Constants.UserDefaults.noticeImageName) as? String, !defaultImageName.isEmpty{
            labelAttachmentText.text = defaultImageName
        }
        
        if let defaultImageData = UserDefaults.standard.object(forKey: Constants.UserDefaults.noticeImage) as? Data{
            self.chosenImage.value = UIImage(data: defaultImageData)
            self.chosenFile.value = nil
        }
        
        if let documentURL = UserDefaults.standard.url(forKey: Constants.UserDefaults.noticeFile),
            let documentName = UserDefaults.standard.string(forKey: Constants.UserDefaults.noticeFileName),
            !documentName.isEmpty{
            self.chosenFile.value = documentURL
            self.labelAttachmentText.text = documentName
            self.chosenImage.value = nil
        }

    }
    
    func clearUSerdefaults(){
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.noticeTitle)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.noticeDescription)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.noticeImage)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.noticeImageName)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.noticeFile)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.noticeFileName)

    }
    
    @IBAction func acctionDissmissView(_ sender: Any?) {
        self.dismiss(animated: true, completion: { [weak self] in
            if self?.delegate != nil{
                self?.delegate?.viewDismissed(isNoticeAdded: self?.noticeAddedFlag)
            }
        })
    }
    
    @IBAction func actionUploadNotice(_ sender: Any) {
        if self.chosenFile.value == nil && self.chosenImage.value == nil{
            let parameters = [
                "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                "class_id":"\(CollegeClassManager.sharedManager.getSelectedClassList)",
                "title":self.textfieldNoticeTitle.text?.addingPercentEncoding(withAllowedCharacters: .letters) ?? "",
                "description":"\(self.textViewDescription.text?.addingPercentEncoding(withAllowedCharacters: .letters) ?? "")",
                "doc":"",
                "file_name":"",
                "role_id": self.roleSwitch.isOn ? "2,3" : "1,3",
                "doc_size":""
            ]
            self.postProfessorNotes(parameters)

        }else{
            let switchStatus = self.roleSwitch.isOn
            self.uploadFileToFirebase(completion: {[weak self] (fileURL, fileSize, fileName)  in
                let parameters = [
                    "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                    "class_id":"\(CollegeClassManager.sharedManager.getSelectedClassList)",
                    "title":self?.textfieldNoticeTitle.text?.addingPercentEncoding(withAllowedCharacters: .letters) ?? "",
                    "description":"\(self?.textViewDescription.text?.addingPercentEncoding(withAllowedCharacters: .letters) ?? "")",
                    "doc":fileURL.absoluteString,
                    "file_name":"\(fileName)",
                    "role_id": switchStatus ? "2,3" : "1,3",
                    "doc_size":"\(fileSize)"
                ]
                self?.postProfessorNotes(parameters)
            }) { [weak self](errorMessage) in
                self?.showAlertWithTitle("Error", alertMessage: errorMessage)
            }
        }
    }
    
    private func postProfessorNotes(_ params:[String:Any]){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeUploadNotice
        manager.apiPostWithDataResponse(apiName: "Upload Notice", parameters:params, completionHandler: {[weak self] (result, code, response) in
            
            self?.showAlertWithTitle("Success", alertMessage: "Notice added!")
            self?.chosenImage.value = nil
            self?.chosenFile.value = nil
            self?.noticeAddedFlag = true
            DispatchQueue.main.async {
                self?.clearUSerdefaults()
            }
            LoadingActivityHUD.hideProgressHUD()
            self?.acctionDissmissView(nil)
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    @IBAction func actionShowClassList(_ sender: Any) {
        self.view.endEditing(true)
        if (CollegeClassManager.sharedManager.selectedClassArray.count > 0){
            self.viewClassList.setUpView(array: CollegeClassManager.sharedManager.selectedClassArray, isAdminScreenFlag: false)
            self.viewClassList.frame = CGRect(x: 0.0, y: 0.0, width: self.view.width(), height: self.view.height())
            self.view.addSubview(self.viewClassList)
        }
    }
    
    @IBAction func actionUploadDocument(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose Notes", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
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
        
        let documentAction = UIAlertAction(title: "Document", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openDocumentPicker()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.addAction(documentAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker!, animated: true, completion: nil)
        }else{
            self.showAlertWithTitle("Oops!", alertMessage: "Camera Access Not Provided")
            
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary), let picker = imagePicker{
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }else{
            self.showAlertWithTitle("Oops!", alertMessage: "Photo Library Access Not Provided")
        }
    }
    
    func openDocumentPicker(){
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeItem]
        self.documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(self.documentPicker, animated: true, completion: nil)
    }
    
    func uploadFileToFirebase(completion:@escaping(_ fileUrl:URL, _ filesize:String,_ fileName:String) -> Void,
                              failure:@escaping(_ message:String) -> Void)
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        if let mobilenumber = UserManager.sharedUserManager.appUserDetails.contact{
            
            let storageRef = storage.reference()
            let filePathReference = storageRef.child("\(mobilenumber)/Notice/")
            if let selectedImage = self.chosenImage.value,let jpedData = UIImageJPEGRepresentation(selectedImage, 1){
                let fileNameRef = filePathReference.child("\(Int64(Date().timeIntervalSince1970 * 1000)).jpg")
                let uploadTask = fileNameRef.putData(jpedData, metadata: nil) { (metadata, error) in
                    LoadingActivityHUD.hideProgressHUD()
                    fileNameRef.downloadURL { (url, error) in
                        guard let metadata = metadata else {
                            failure("Unable to upload")
                            return
                        }
                        guard let downloadURL = url else {
                            failure("Unable to upload")
                            return
                        }
                        completion(downloadURL,"\(metadata.size)",fileNameRef.name)
                    }
                }
                uploadTask.observe(.progress) { snapshot in
                    // A progress event occured
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                        / Double(snapshot.progress!.totalUnitCount)
                    print("\(percentComplete)% uploaded ")
                }
            }
            
            if let selectedFile = self.chosenFile.value{
                let fileNameRef = filePathReference.child("\(selectedFile.lastPathComponent)")
                let uploadTask = fileNameRef.putFile(from: selectedFile, metadata: nil) { metadata, error in
                    LoadingActivityHUD.hideProgressHUD()
                    fileNameRef.downloadURL { (url, error) in
                        guard let metadata = metadata else {
                            failure("Unable to upload")
                            return
                        }
                        guard let downloadURL = url else {
                            failure("Unable to upload")
                            return
                        }
                        
                        if let errorObject = error {
                            print("errorObject \(errorObject.localizedDescription)")
                            failure("Unable to upload")
                        }
                        completion(downloadURL, "\(metadata.size)", fileNameRef.name)
                    }
                }
                uploadTask.observe(.progress) { snapshot in
                    // A progress event occured
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                        / Double(snapshot.progress!.totalUnitCount)
                    print("\(percentComplete)% uploaded ")
                }
            }
        }
    }
}


extension AddNewNoticeViewController{
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            if(self.viewAddNoticeWrapper != nil){
                if((self.buttonPreviewNotice.origin().y + self.viewAddNoticeWrapper.origin().y) >= (self.view.height()-keyboardSize.height) && self.view.frame.origin.y == 0)
                {
                    self.view.frame.origin.y -= keyboardSize.height/2
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


extension AddNewNoticeViewController:UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.chosenFile.value = myURL
        UserDefaults.standard.set(myURL, forKey: Constants.UserDefaults.noticeFile)
        UserDefaults.standard.set(myURL.lastPathComponent, forKey: Constants.UserDefaults.noticeFileName)
        self.labelAttachmentText.text = myURL.lastPathComponent
        self.chosenImage.value = nil
        print("import result : \(myURL)")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.chosenFile.value = url
        UserDefaults.standard.set(url, forKey: Constants.UserDefaults.noticeFile)
        UserDefaults.standard.set(url.lastPathComponent, forKey: Constants.UserDefaults.noticeFileName)
        self.labelAttachmentText.text = url.lastPathComponent
        self.chosenImage.value = nil
        print("import result : \(url)")

    }
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        self.documentPicker.dismiss(animated: true, completion: nil)
    }
}

extension AddNewNoticeViewController:ViewClassSelectionDelegate{
    func classViewDismissed() {
        self.viewClassList.removeFromSuperview()
        print("class dismissed")
    }
}


extension AddNewNoticeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.chosenImage.value = image
            self.chosenFile.value = nil//save selected image to user defaults
            
            let data = UIImagePNGRepresentation(image)
            UserDefaults.standard.setValue(data, forKey: Constants.UserDefaults.noticeImage)
        }
        
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                labelAttachmentText.text = assetResources.first!.originalFilename
                print(assetResources.first!.originalFilename)
                UserDefaults.standard.setValue(assetResources.first!.originalFilename, forKey: Constants.UserDefaults.noticeImageName)

            }
        } else {
            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                print(assetResources.first!.originalFilename)
                labelAttachmentText.text = assetResources.first!.originalFilename
                UserDefaults.standard.setValue(assetResources.first!.originalFilename, forKey: Constants.UserDefaults.noticeImageName)

            }
        }
        
        if let videoURL = info["UIImagePickerControllerMediaURL"] as? URL{
            print("videoURL \(videoURL)")
            
            var fileAttributes: [FileAttributeKey : Any]? = nil
            do {
                fileAttributes = try FileManager.default.attributesOfItem(atPath: videoURL.path)
            } catch let attributesError {
                print(attributesError.localizedDescription)
            }
            let fileSizeNumber = fileAttributes?[.size] as? NSNumber
            let fileSize: Int64 = fileSizeNumber?.int64Value ?? 0
            if fileSize > 26214400{
                self.showAlertWithTitle("ERROR", alertMessage: "File size should be less than 25mb")
            }else{
                self.chosenFile.value  = videoURL
            }
            print(String(format: "SIZE OF VIDEO: %0.2f Mb", Float(fileSize) / 1024 / 1024))
        }
        
        imagePicker?.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }
}
