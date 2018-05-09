//
//  MarkCompletedPortionViewController.swift
//  TeachUs
//
//  Created by ios on 11/17/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

enum SyllabusCompletetionType {
    case NotStarted
    case Completed
    case InProgress
}


class MarkCompletedPortionViewController: BaseViewController {

    @IBOutlet weak var tableviewTopics: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var subjectId:String?
    var arrayDataSource:[Unit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableviewTopics.register(UINib(nibName: "TopicDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId)

        self.getTopics()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
        self.addColorToNavBarText(color: .white)
        self.buttonSubmit.themeRedButton()
        self.tableviewTopics.alpha = 0.0
    }
    
    func getTopics(){
        let manager = NetworkHandler()
        

        //http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus/teacher/getTopics/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?professorId=1&subjectId=2
//        manager.url = URLConstants.TecacherURL.getTopics +
//                    "\(UserManager.sharedUserManager.getAccessToken())" +
//                    "==?professorId=\(UserManager.sharedUserManager.getUserId())" +
//                    "&subjectId=\(self.subjectId!)"

        
        manager.url = URLConstants.ProfessorURL.topicList
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGet(apiName: "Get topics for professor", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let topics = response["topicWise"] as? [[String:Any]] else{
                return
            }

            for topic in topics{
                let tempTopic = Mapper<Unit>().map(JSON: topic)
                self.arrayDataSource.append(tempTopic!)
            }
            self.makeTableView()
            self.tableviewTopics.reloadData()
            self.showTableView()
            
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
         
    }
    
    func makeTableView(){
        self.tableviewTopics.delegate = self
        self.tableviewTopics.dataSource = self
    }
    func showTableView(){
        self.tableviewTopics.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableviewTopics.alpha = 1.0
            self.tableviewTopics.transform = CGAffineTransform.identity
        }
    }

    
    
    @IBAction func submitSyllabusStatus(_ sender: Any) {
        
    }
    

}

extension MarkCompletedPortionViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopicDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId, for: indexPath) as! TopicDetailsTableViewCell
        
        let chapterCell:Chapter = self.arrayDataSource[indexPath.section].topicArray![indexPath.row]
        cell.labelChapterNumber.text = "Add Chapter number"
        cell.labelChapterName.text = chapterCell.chapterName
        cell.labelStatus.text = chapterCell.setChapterStatus
//        cell.buttonSetStatus.roundedBlueButton()
        cell.buttonInProgress.indexPath = indexPath
        cell.buttonCompleted.indexPath = indexPath
        cell.buttonInProgress.addTarget(self, action:#selector( MarkCompletedPortionViewController.markChapterInProgress(_:)), for: .touchUpInside)
        cell.buttonCompleted.addTarget(self, action:#selector( MarkCompletedPortionViewController.markChapterInCompleted(_:)), for: .touchUpInside)
        
        switch chapterCell.chapterStatusTheme! {
        case .Completed:
            cell.buttonCompleted.selectedGreenButton()
            cell.buttonInProgress.selectedDefaultButton()
            cell.labelStatus.textColor = UIColor.green
            break
        case .InProgress:
            cell.buttonInProgress.selectedRedButton()
            cell.buttonCompleted.selectedDefaultButton()
            cell.labelStatus.textColor = UIColor.red
            break
        case .NotStarted:
            cell.buttonCompleted.selectedDefaultButton()
            cell.buttonInProgress.selectedDefaultButton()
            cell.labelStatus.textColor = UIColor.yellow
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrayDataSource[section].topicArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.arrayDataSource[section].unitName
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    @objc func markChapterInProgress(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].setChapterStatus = "In Progress"
        self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterStatusTheme = .InProgress
        self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)

        
    }
    @objc func markChapterInCompleted(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].setChapterStatus = "Completed"
        self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterStatusTheme = .Completed
        self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
    }

}
