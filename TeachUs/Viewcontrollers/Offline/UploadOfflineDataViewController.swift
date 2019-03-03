//
//  UploadOfflineDataViewController.swift
//  TeachUs
//
//  Created by ios on 8/4/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class UploadOfflineDataViewController: BaseViewController {

    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var viewProgressbar: UIProgressView!
    var arrayApiReqestParameters = [OfflineApiRequest]()
    var markedAttendanceId:NSNumber!
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOffineData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initOffineData(){
        let dataResponse = DatabaseManager.getEntitesForEntityName(name: "OfflineApiRequest")
        for data in dataResponse{
            let dataTransformable:OfflineApiRequest = (data as? OfflineApiRequest)!
            arrayApiReqestParameters.append(dataTransformable)
            print(dataTransformable.attendanceParams!)
            print(dataTransformable.syllabusParams!)
        }
//        self.markAttendance()
        self.markSyllabusAndAttendance()
    }
    

    func markAttendance(){
        self.labelStatus.text = "Uploading data \(currentIndex+1) of \(self.arrayApiReqestParameters.count)"
        self.viewProgressbar.progress = Float(currentIndex/self.arrayApiReqestParameters.count)
        let dataTransformable:OfflineApiRequest = arrayApiReqestParameters[currentIndex]
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.submitAttendance
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let parameters = dataTransformable.attendanceParams as? [String:Any]
        manager.apiPost(apiName: "Mark student attendance", parameters:parameters!, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                
                let alert = UIAlertController(title: nil, message: response["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.markedAttendanceId = response["att_id"] as! NSNumber
                    self.submitSyllabus()
                }))
                // show the alert
                self.present(alert, animated: true, completion:nil)
            }
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlterWithTitle(nil, alertMessage: errorMessage)
        }
    }
    
    
    func submitSyllabus(){
        let dataTransformable:OfflineApiRequest = arrayApiReqestParameters[currentIndex]
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.submitSyllabusCovered
        var parameters = dataTransformable.syllabusParams as? [String:Any]
        parameters!["att_id"] = self.markedAttendanceId!
        manager.apiPost(apiName: "mark syllabus professor", parameters: parameters!, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let status = response["status"] as? NSNumber else{
                return
            }
            if (status == 200){
                    if(self.currentIndex < self.arrayApiReqestParameters.count-1){
                        self.currentIndex += 1
                        self.markAttendance()
                    }
                    else if(self.currentIndex == (self.arrayApiReqestParameters.count - 1)){
                        let alert = UIAlertController(title: nil, message: response["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                            
                            self.dismiss(animated: true, completion: {
                                DatabaseManager.deleteAllEntitiesForEntityName(name: "OfflineApiRequest")
                                DatabaseManager.saveDbContext()
                                NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
                            })
                        }))
                        self.present(alert, animated: true, completion:nil)
                    }
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    func markSyllabusAndAttendance(){
        self.labelStatus.text = "Uploading data \(currentIndex+1) of \(self.arrayApiReqestParameters.count)"
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.mergedAttendanceAndSyllabus
        let dataTransformable:OfflineApiRequest = arrayApiReqestParameters[currentIndex]
        var parameters = dataTransformable.attendanceParams as? [String:Any]
        let syllabusParamets = dataTransformable.syllabusParams as? [String:Any]
        parameters!["topic_list"] = syllabusParamets!["topic_list"]

        
        manager.apiPost(apiName: "mark syllabus professor", parameters: parameters!, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let status = response["status"] as? NSNumber else{
                return
            }
            if (status == 200){
                if(self.currentIndex < self.arrayApiReqestParameters.count-1){
                    self.currentIndex += 1
                    self.markSyllabusAndAttendance()
                }
                else if(self.currentIndex == (self.arrayApiReqestParameters.count - 1)){
                    let alert = UIAlertController(title: nil, message: response["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                        
                        self.dismiss(animated: true, completion: {
                            DatabaseManager.deleteAllEntitiesForEntityName(name: "OfflineApiRequest")
                            DatabaseManager.saveDbContext()
                            NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
                        })
                    }))
                    self.present(alert, animated: true, completion:nil)
                }
            }else{
                if(self.currentIndex < self.arrayApiReqestParameters.count-1){
                    self.currentIndex += 1
                    self.markSyllabusAndAttendance()
                }else{
                    self.dismiss(animated: true, completion: {
                        DatabaseManager.deleteAllEntitiesForEntityName(name: "OfflineApiRequest")
                        DatabaseManager.saveDbContext()
                        NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
                    })
                }
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
