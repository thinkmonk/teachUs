//
//  ProfessorNotesDetailstViewController.swift
//  TeachUs
//
//  Created by ios on 5/28/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseStorage
import  WebKit
import RxCocoa
import RxSwift
import Photos

class ProfessorNotesDetailstViewController: BaseViewController {

    @IBOutlet weak var tableViewNotesDetails: UITableView!
    @IBOutlet weak var viewHeaderWrapper: UIView!
    @IBOutlet weak var viewTextfieldBg: UIView!
    @IBOutlet weak var buttonAttachFile: UIButton!
    @IBOutlet weak var labelFileName: UILabel!
    @IBOutlet weak var textfiledName: UITextField!
    @IBOutlet weak var buttonUploadNotes: UIButton!
    let nibCollegeListCell = "notesDetailsTableViewCell"
    var imagePicker:UIImagePickerController?=UIImagePickerController()
//    var chosenFile:URL?
//    var chosenImage:UIImage?
    let storage = Storage.storage()
    
    var noticeTitle = Variable<String>("")
    var chosenImage = Variable<UIImage?>(UIImage())
    var chosenFile =  Variable<URL?>(URL(string: ""))
    var myDisposeBag = DisposeBag()


    var selectedNotesSubject:SubjectList!
    var noteListData : NotesSubjectDetails?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        self.getNotes()

        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableViewNotesDetails.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.notesDetailsCellId)
        self.tableViewNotesDetails.delegate = self
        self.tableViewNotesDetails.dataSource = self
        self.tableViewNotesDetails.estimatedRowHeight = 20
        self.tableViewNotesDetails.rowHeight = UITableViewAutomaticDimension
        imagePicker?.delegate = self
        self.buttonUploadNotes.isHidden = true
        setUpDefaultValues()
        self.setUpRx()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        #if DEBUG
        print("ProfessorNotesDetailstViewController deinited")
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewTextfieldBg.makeEdgesRounded()
        self.buttonUploadNotes.roundedRedButton()
        self.viewHeaderWrapper.makeEdgesRounded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setUpDefaultValues(){
        if let defaultTitle = UserDefaults.standard.value(forKey: Constants.UserDefaults.notesTitle) as? String{
            self.textfiledName.text = defaultTitle
            self.noticeTitle.value = defaultTitle
        }
        
        if let defaultImageData = UserDefaults.standard.object(forKey: Constants.UserDefaults.notesImage) as? Data{
            self.chosenImage.value = UIImage(data: defaultImageData)
            labelFileName.text = "Image selected"
            self.chosenFile.value = nil
        }
        
        if let defaultImageName = UserDefaults.standard.value(forKey: Constants.UserDefaults.notesImageName) as? String, !defaultImageName.isEmpty{
            labelFileName.text = defaultImageName
        }
        
        if let documentURL = UserDefaults.standard.url(forKey: Constants.UserDefaults.notesFile),
            let documentName = UserDefaults.standard.string(forKey: Constants.UserDefaults.notesFileName),
            !documentName.isEmpty{
            self.chosenFile.value = documentURL
            self.labelFileName.text = documentName
            self.chosenImage.value = nil
        }

    }

    func clearUSerdefaults(){
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.notesTitle)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.notesImage)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.notesImageName)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.notesFile)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.notesFileName)
    }
    
    
    func setUpRx(){
        self.textfiledName.rx.text.map{$0 ?? ""}.bind(to: self.noticeTitle).disposed(by: myDisposeBag)
        
        var isValid : Observable<Bool> {
            return Observable.combineLatest(self.noticeTitle.asObservable(), self.chosenFile.asObservable(), self.chosenImage.asObservable()){ [weak self] title, file, image in
                UserDefaults.standard.set(title, forKey: Constants.UserDefaults.notesTitle)
                return title.count > 2 && (self?.chosenImage.value != nil || self?.chosenFile.value != nil)
            }
        }
        
        isValid.asObservable().subscribe(onNext: {[weak self] (isValid) in
            self?.buttonUploadNotes.isHidden = !isValid
        }).disposed(by: myDisposeBag)
        
    }
    
    @IBAction func actionUploadNotes(_ sender: Any) {
        view.endEditing(true)
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
    
    func getNotes()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getNotesDetails
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "subject_id" :self.selectedNotesSubject.subjectID ?? "",
            "class_id":self.selectedNotesSubject.classID ?? ""
        ]
        manager.apiPostWithDataResponse(apiName: "Get Notes Details", parameters:parameters, completionHandler: {[weak self] (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self?.noteListData = try decoder.decode(NotesSubjectDetails.self, from: response)
                DispatchQueue.main.async {
                    self?.tableViewNotesDetails.reloadData()
                }
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    @objc func downloadNotes(_ sender:ButtonWithIndexPath){
        if let notesObejct = self.noteListData?.notesList?[sender.indexPath.section], let fileUrl = notesObejct.filePath{
            let imageURL = "\(fileUrl)"
            if let filePath = GlobalFunction.checkIfFileExisits(fileUrl: imageURL, name:notesObejct.generatedFileName ?? ""){
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.viewControllerId.documentsVC) as! DocumentsViewController
                viewController.filepath = filePath
                viewController.fileURL = imageURL
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{// save file
                LoadingActivityHUD.showProgressHUD(view: self.view)
                GlobalFunction.downloadFileAndSaveToDisk(fileUrl: imageURL, customName: notesObejct.generatedFileName ?? "TeachUs\(Date())") { [weak self] (success) in
                    DispatchQueue.main.async {
                        self?.tableViewNotesDetails.reloadRows(at: [sender.indexPath], with: .fade)
                        LoadingActivityHUD.hideProgressHUD()

                    }
                }
            }
            
        }
    }
    
    @objc func deleteNote(_ sender:ButtonWithIndexPath)
    {
        let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete the selected notes", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {[weak self] (_) in
            if let notesObejct = self?.noteListData?.notesList?[sender.indexPath.section], let mobilenumber = UserManager.sharedUserManager.appUserDetails.contact{
                let storageRef = self?.storage.reference()
                let filePathReference = storageRef?.child("\(mobilenumber)/Notes/\(notesObejct.originalFileName ?? "")")
                LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
                
                filePathReference?.delete { error in
                    if let error = error {
                        self?.showAlertWithTitle("Error", alertMessage: "\(error.localizedDescription)")
                    } else {
                        let manager = NetworkHandler()
                        manager.url = URLConstants.ProfessorURL.deleteNotes
                        let parameters = [
                            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                            "notes_id" :notesObejct.notesID ?? ""
                        ]
                        manager.apiPost(apiName: "delete notes \(notesObejct.title ?? "")", parameters: parameters, completionHandler: { (success, code, response) in
                            LoadingActivityHUD.hideProgressHUD()
                            if let status = response["status"] as? Int, status == 200, let message = response["message"] as? String{
                                self?.getNotes()
                                self?.showAlertWithTitle("Success", alertMessage:message)
                            }
                        }) { (success, code, errormessage) in
                            LoadingActivityHUD.hideProgressHUD()
                            print(errormessage)
                        }                }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionUploadNotesToServer(_ sender:UIButton){
        self.uploadFileToFirebase(completion: {[weak self] (fileURL, fileSize, fileName)  in
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
            let manager = NetworkHandler()
            manager.url = URLConstants.ProfessorURL.uploadNotes
            let parameters = [
                "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                "subject_id" :self?.selectedNotesSubject.subjectID ?? "",
                "class_id":self?.selectedNotesSubject.classID ?? "",
                "title":self?.textfiledName.text?.addingPercentEncoding(withAllowedCharacters: .letters) ?? "",
                "doc":fileURL.absoluteString,
                "file_name":fileName,
                "doc_size":fileSize
            ]
            manager.apiPost(apiName: "Upload nOtes", parameters:parameters, completionHandler: { (result, code, response) in
                if let status = response["status"] as? Int, status == 200, let message = response["message"] as? String{
                    self?.showAlertWithTitle("Success", alertMessage: message)
                    self?.textfiledName.text  = ""
                    self?.labelFileName.text = "File Name"
                    self?.chosenImage.value = nil
                    self?.chosenFile.value = nil
                    self?.clearUSerdefaults()
                    self?.getNotes()
                }
                LoadingActivityHUD.hideProgressHUD()
            }) { (error, code, message) in
                print(message)
                LoadingActivityHUD.hideProgressHUD()
            }
        }) {[weak self] (errorMessage) in
            self?.showAlertWithTitle("Error", alertMessage: errorMessage)
        }
    }
    
    func uploadFileToFirebase(completion:@escaping(_ fileUrl:URL, _ filesize:String,_ fileName:String) -> Void,
                              failure:@escaping(_ message:String) -> Void){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        if let mobilenumber = UserManager.sharedUserManager.appUserDetails.contact{
            
            let storageRef = storage.reference()
            let filePathReference = storageRef.child("\(mobilenumber)/Notes/")
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


extension ProfessorNotesDetailstViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.noteListData?.notesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:notesDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.notesDetailsCellId) as! notesDetailsTableViewCell
        if let notes = self.noteListData?.notesList?[indexPath.section]{
            cell.setUpNotes(notesData: notes)
            cell.buttonDownloadNotes.addTarget(self, action: #selector(ProfessorNotesDetailstViewController.downloadNotes(_:)), for: .touchUpInside)
            cell.buttonDeleteNotes.addTarget(self, action: #selector(ProfessorNotesDetailstViewController.deleteNote(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.buttonDeleteNotes.indexPath = indexPath
            cell.buttonDownloadNotes.indexPath = indexPath

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewNotesDetails.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView

    }
    
}

extension ProfessorNotesDetailstViewController{
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
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker?.mediaTypes = ["public.image", "public.movie"]
            self.present(imagePicker!, animated: true, completion: nil)
        }else{
            self.showAlertWithTitle("Oops!", alertMessage: "Photo LIbrary Access Not Provided")
        }
    }
    
    func openDocumentPicker(){
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeItem]
        let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}

extension ProfessorNotesDetailstViewController:UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.chosenFile.value = myURL
        self.chosenImage.value = nil
        self.labelFileName.text = self.chosenFile.value?.lastPathComponent ?? ""
        UserDefaults.standard.set(myURL, forKey: Constants.UserDefaults.notesFile)
        UserDefaults.standard.set(myURL.lastPathComponent, forKey: Constants.UserDefaults.notesFileName)

        print("import result : \(myURL)")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.chosenFile.value = url
        self.chosenImage.value = nil
        self.labelFileName.text = self.chosenFile.value?.lastPathComponent ?? ""
        UserDefaults.standard.set(url, forKey: Constants.UserDefaults.notesFile)
        UserDefaults.standard.set(url.lastPathComponent, forKey: Constants.UserDefaults.notesFileName)
        print("import result : \(url)")
        
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}

extension ProfessorNotesDetailstViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.chosenImage.value = image
            self.chosenFile.value = nil
            self.labelFileName.text = "Image selected"
            let data = UIImagePNGRepresentation(image)
            UserDefaults.standard.setValue(data, forKey: Constants.UserDefaults.notesImage)
            
            if #available(iOS 11.0, *) {
                if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
                    let assetResources = PHAssetResource.assetResources(for: asset)
                    labelFileName.text = assetResources.first!.originalFilename
                    print(assetResources.first!.originalFilename)
                    UserDefaults.standard.setValue(assetResources.first!.originalFilename, forKey: Constants.UserDefaults.notesImageName)

                }
            } else {
                if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                    let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                    print(assetResources.first!.originalFilename)
                    labelFileName.text = assetResources.first!.originalFilename
                    UserDefaults.standard.setValue(assetResources.first!.originalFilename, forKey: Constants.UserDefaults.notesImageName)

                }
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
                self.chosenFile.value = videoURL
                self.labelFileName.text = "Video selected"
            }
            print(String(format: "SIZE OF VIDEO: %0.2f Mb", Float(fileSize) / 1024 / 1024))
        }
        
        imagePicker?.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }
}
