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
    var chosenFile:URL?
    var chosenImage:UIImage?
    let storage = Storage.storage()

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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewTextfieldBg.makeEdgesRounded()
        self.buttonUploadNotes.themeRedButton()
        self.viewHeaderWrapper.makeEdgesRounded()
        imagePicker?.delegate = self
    }
    
    @IBAction func actionUploadNotes(_ sender: Any) {
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
        manager.apiPostWithDataResponse(apiName: "Get Notes Details", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.noteListData = try decoder.decode(NotesSubjectDetails.self, from: response)
                DispatchQueue.main.async {
                    self.tableViewNotesDetails.reloadData()
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
                let webView = UIWebView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height))
                webView.loadRequest(URLRequest(url: URL(fileURLWithPath: filePath)))
                let pdfVC = BaseViewController() //create a view controller for view only purpose
                pdfVC.view.addSubview(webView)
                pdfVC.title = "\(URL(string: fileUrl)?.lastPathComponent ?? "")"
                self.navigationController?.pushViewController(pdfVC, animated: true)
                pdfVC.addGradientToNavBar()
            }else{// save file
                GlobalFunction.downloadFileAndSaveToDisk(fileUrl: imageURL, customName: notesObejct.generatedFileName ?? "TeachUs\(Date())") { (success) in
                    DispatchQueue.main.async {
                        self.tableViewNotesDetails.reloadRows(at: [sender.indexPath], with: .fade)
                    }
                }
            }
            
        }
    }
    
    @objc func deleteNote(_ sender:ButtonWithIndexPath){
        if let notesObejct = self.noteListData?.notesList?[sender.indexPath.section]{
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
            let manager = NetworkHandler()
            manager.url = URLConstants.ProfessorURL.deleteNotes
            let parameters = [
                "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                "notes_id" :notesObejct.notesID ?? ""
            ]
            manager.apiPost(apiName: "delete notes \(notesObejct.title ?? "")", parameters: parameters, completionHandler: { (success, code, response) in
                LoadingActivityHUD.hideProgressHUD()
                if let status = response["status"] as? Int, status == 200, let message = response["message"] as? String{
                    self.getNotes()
                    self.showAlterWithTitle("Success", alertMessage:message)
                }
            }) { (success, code, errormessage) in
                LoadingActivityHUD.hideProgressHUD()
                print(errormessage)
            }
            
        }
    }
    
    @IBAction func uploadFileToFireBase(_ sender: UIButton){
        // Create a root reference
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        if let mobilenumber = UserManager.sharedUserManager.appUserDetails.contact{
            
            let storageRef = storage.reference()
            let filePathReference = storageRef.child("\(mobilenumber)/Notes/")
            if let selectedImage = self.chosenImage,let jpedData = UIImageJPEGRepresentation(selectedImage, 1){
                let fileNameRef = filePathReference.child("\(Date().timeIntervalSince1970).jpg")
                let uploadTask = fileNameRef.putData(jpedData, metadata: nil) { (metadata, error) in
                    LoadingActivityHUD.hideProgressHUD()
                    fileNameRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        print("Image Uploaded, url is \(downloadURL)")
                    }
                }
                uploadTask.observe(.progress) { snapshot in
                    // A progress event occured
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                        / Double(snapshot.progress!.totalUnitCount)
                    print("\(percentComplete)% uploaded ")
                }
            }
            
            if let selectedFile = self.chosenFile{
                let fileNameRef = filePathReference.child("\(selectedFile.lastPathComponent)")
                let uploadTask = fileNameRef.putFile(from: selectedFile, metadata: nil) { metadata, error in
                    LoadingActivityHUD.hideProgressHUD()
                    fileNameRef.downloadURL { (url, error) in
                        if let downloadURL = url {
                            print("download url = \(downloadURL)")
                        }
                        if let errorObject = error {
                                print("errorObject \(errorObject.localizedDescription)")
                        }
                        
                        
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
        LoadingActivityHUD.hideProgressHUD()
        
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
            self.showAlterWithTitle("Oops!", alertMessage: "Camera Access Not Provided")
            
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker!, animated: true, completion: nil)
        }else{
            self.showAlterWithTitle("Oops!", alertMessage: "Photo LIbrary Access Not Provided")
        }
    }
    
    func openDocumentPicker(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
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
        self.chosenFile = myURL
        self.chosenImage = nil
        self.labelFileName.text = self.chosenFile?.lastPathComponent ?? ""
        print("import result : \(myURL)")
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
        self.chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.chosenFile = nil
        self.labelFileName.text = "Image selected"
        imagePicker?.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }
}
