//
//  EditProfilePictureViewController.swift
//  TeachUs
//
//  Created by ios on 3/13/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import MobileCoreServices


protocol editProfilePictureDelegate {
   func  profileEdited()
}


class EditProfilePictureViewController: BaseViewController{
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var buttonUploadProfilePic: UIButton!
    @IBOutlet weak var buttonSelectPhotoFromGallery: UIButton!
    @IBOutlet weak var buttonSelectPhotoFromCamera: UIButton!
    let picker = UIImagePickerController()
    var delegate:editProfilePictureDelegate?
    var profileImageUrl:String = UserManager.sharedUserManager.appUserDetails.profilePicUrl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonUploadProfilePic.alpha = 0
        picker.delegate = self

        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.buttonUploadProfilePic.makeEdgesRounded()
        self.imageViewProfilePic.imageFromServerURL(urlString: profileImageUrl, defaultImage: Constants.Images.defaultProfessor)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func photofromLibrary(_ sender: Any) {
//        let authStatus = checkPhotoLibraryAuthorisation()
//        if(authStatus){
//            //        self.present(picker, animated: true, completion: nil)
//        }
//        else{
//
//        }
//        
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeImage as String]
            self.present(picker, animated: true, completion: nil)
        }
        else{
            self.showAlterWithTitle("Oops!", alertMessage: "Photo Library Access Not Provided")

        }
        
    }
    
    @IBAction func takePhoto(_ sender: Any) {
//        let authStatus = checkCameraAuthorisation()
//        if(authStatus){
//            picker.allowsEditing = false
//            picker.sourceType = UIImagePickerControllerSourceType.camera
//            picker.cameraCaptureMode = .photo
//            picker.modalPresentationStyle = .fullScreen
//            self.present(picker, animated: true, completion: nil)
//        }
//        else{
//            self.showAlterWithTitle("Oops!", alertMessage: "Camera Access Not Provided")
//        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            self.present(picker, animated: true, completion: nil)
        }
        else{
            self.showAlterWithTitle("Oops!", alertMessage: "Camera Access Not Provided")

        }
        
        
        
    }
    
    
    @IBAction func closeProfilePictureView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func uploadPic(_ sender: Any) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        var profileImage = self.imageViewProfilePic.image
        let imageSizeKB = profileImage?.getSizeInKb()
        print("size of image in KB: %f ", Double(imageSizeKB!))
        if(imageSizeKB! >= 500.0){
            do {
                try self.imageViewProfilePic.image?.compressImage(400, completion: { (image, compressRatio) in
                    print(image.size)
//                    profileIm = UIImageJPEGRepresentation(image, compressRatio)
//                    base64data = imageData?.base64EncodedString()
                    profileImage = image
                })
            } catch {
                print("Error")
            }
//           profileImage = profileImage!.compressImagge()
            print("compressed image size = \(profileImage?.getSizeInKb() ?? 0)")
        }
        let imageData:NSData = UIImageJPEGRepresentation(profileImage!, 1)! as NSData

//        let imageData:NSData = UIImagePNGRepresentation(profileImage!)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        let parameters = ["profile":"\(strBase64)"]
        let manager = NetworkHandler()
        manager.url = URLConstants.Login.updateUserProfile
        manager.apiPost(apiName: " Update user profile", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if (code == 200){
                UserManager.sharedUserManager.appUserDetails.profilePicUrl  = response["profile"] as? String
                self.dismiss(animated: true, completion: {
                    if self.delegate != nil{
                        self.delegate?.profileEdited()
                    }
                })
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
}
    
    func checkPhotoLibraryAuthorisation() -> Bool{
        var authStatus:Bool = false
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
           authStatus = true
        }
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            authStatus = false
        }
        else if (status == PHAuthorizationStatus.notDetermined) {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    authStatus = true
                }
                else {
                    authStatus = false
                }
            })
        }
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
            authStatus = false
        }
        return authStatus
    }
    
    
    func checkCameraAuthorisation() -> Bool{
        var authStatus:Bool = false
        if(AVCaptureDevice.authorizationStatus(for: .video) == .authorized){
            authStatus = true
        }
        else if(AVCaptureDevice.authorizationStatus(for: .video) == .denied){
            authStatus = false
        }
        else if (AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined){
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    authStatus = true
                } else {
                    authStatus = false
                }
            })
        }
        else if  (AVCaptureDevice.authorizationStatus(for: .video) == .restricted){
            authStatus = false
        }
        return authStatus
    }
    
}



extension EditProfilePictureViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        self.imageViewProfilePic.contentMode = .scaleAspectFit //3
        self.imageViewProfilePic.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
        self.buttonUploadProfilePic.alpha = 1
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
