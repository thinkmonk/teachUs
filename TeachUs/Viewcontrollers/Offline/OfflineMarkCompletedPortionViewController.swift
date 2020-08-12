//
//  OfflineMarkCompletedPortionViewController.swift
//  TeachUs
//
//  Created by ios on 7/22/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreData
import RxSwift


class OfflineMarkCompletedPortionViewController:BaseViewController {
    
    @IBOutlet weak var tableviewTopics: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
//    @IBOutlet weak var labelSyllabusCompletion: UILabel!
    var selectedCollege:Offline_Class_list!
    var attendanceParameters = [String:Any]()
    var attendanceId:NSNumber!
    var syllabusData:[Offline_Unit_syllabus_array] = []
    var updatedTopicList:[[String:Any]] = []{
        didSet{
            self.buttonSubmit.isHidden = !(self.updatedTopicList.count > 0)
        }
    }
    var customTopicString = Variable<String>("")
    var doneToolbarButton:UIToolbar!
    private var myDisposeBag = DisposeBag()
    var arrayDataSource = [MarkSyllabusDataSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableviewTopics.register(UINib(nibName: "TopicDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId)
        self.tableviewTopics.register(UINib(nibName: "CustomSyllabusTopicTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.CustomSyllabusTopicTableViewCellId)

        self.title = "Syllabus Update"
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        self.tableviewTopics.estimatedRowHeight = 110
        self.tableviewTopics.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(MarkCompletedPortionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MarkCompletedPortionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        initToolbar()
        setUpRx()
        self.makeDataSource()



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
        self.tableviewTopics.alpha = 1.0
        self.buttonSubmit.isHidden = !(self.updatedTopicList.count > 0)

    }
    
    func setUpRx(){
        self.customTopicString.asObservable().subscribe(onNext: { (newValue) in
            self.buttonSubmit.isHidden = newValue.count == 0
        }).disposed(by: myDisposeBag)
    }
    
    @objc func viewDidBecomeActive(){
        #if DEBUG
            print("viewDidBecomeActive")
        #endif
        ReachabilityManager.shared.pauseMonitoring()
    }
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        if self.syllabusData.count > 0{
            for unitObj in self.syllabusData{
                let dsObj = MarkSyllabusDataSource(cellType: .Unit, attachedObject: unitObj)
                arrayDataSource.append(dsObj)
            }
            
            let otherUniObj = MarkSyllabusDataSource(cellType: .Other, attachedObject: nil)
            arrayDataSource.append(otherUniObj)
        }
        
        DispatchQueue.main.async {
            self.makeTableView()
            self.tableviewTopics.reloadData()
            self.showTableView()
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
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.submitSyllabusCovered
        var parameters = [String:Any]()
        
//        parameters["college_code"] = "\(UserManager.sharedUserManager.offlineAppuserCollegeDetails.college_code!)"
//        parameters["att_id"] = self.attendanceId!
        let topicList = ["topic_list":self.updatedTopicList]
        var requestString  =  ""
        if let theJSONData = try? JSONSerialization.data(withJSONObject: topicList,options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            requestString = theJSONText!
            print("requestString = \(theJSONText!)")
        }
        parameters["topic_list"] = requestString
        parameters["otherstopic"] = self.customTopicString.value
        
        let api:OfflineApiRequest = NSEntityDescription.insertNewObject(forEntityName: "OfflineApiRequest", into: DatabaseManager.managedContext) as! OfflineApiRequest
        api.attendanceParams = self.attendanceParameters as NSObject
        api.syllabusParams = parameters as NSObject
        DatabaseManager.saveDbContext()
        UserManager.sharedUserManager.offlineAppuserCollegeDetails.class_list?.filter({ $0.class_id == self.selectedCollege.class_id}).first?.unit_syllabus_array! = self.syllabusData
        UserManager.sharedUserManager.updateOfflineUserData()
        let alert = UIAlertController(title: nil, message: "Syllabus Recorded", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: OfflineHomeViewController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toLectureReport{
            let destinationVc:LectureReportViewController = segue.destination as! LectureReportViewController
            destinationVc.selectedAttendanceId = self.attendanceId
        }
    }
    
    
}

extension OfflineMarkCompletedPortionViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSourceObj:MarkSyllabusDataSource = arrayDataSource[indexPath.section]

        switch dataSourceObj.syallbusCellType {
        case .Unit:
            let cell:TopicDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId, for: indexPath) as! TopicDetailsTableViewCell
            guard let unitObj = dataSourceObj.attachedObject as? Offline_Unit_syllabus_array, let chapterCell = unitObj.topic_list?[indexPath.row] else{
                return cell
            }
            
            cell.labelChapterName.text = chapterCell.topic_name
            cell.labelStatus.text = chapterCell.setChapterStatus
            //        cell.buttonSetStatus.roundedBlueButton()
            cell.buttonInProgress.indexPath = indexPath
            cell.buttonCompleted.indexPath = indexPath
            cell.buttonInProgress.addTarget(self, action:#selector( OfflineMarkCompletedPortionViewController.markChapterInProgress(_:)), for: .touchUpInside)
            cell.buttonCompleted.addTarget(self, action:#selector( OfflineMarkCompletedPortionViewController.markChapterInCompleted(_:)), for: .touchUpInside)
            
            switch chapterCell.chapterStatusTheme! {
            case .Completed:
                cell.buttonCompleted.selectedGreenButton()
                cell.buttonInProgress.selectedDefaultButton()
                cell.labelStatus.textColor = UIColor.rgbColor(0.0, 143.0, 83.0) //#008F53
                cell.viewDisableCell.alpha = chapterCell.isUpdated ? 0 : 1
                break
            case .InProgress:
                cell.buttonInProgress.selectedRedButton()
                cell.buttonCompleted.selectedDefaultButton()
                cell.labelStatus.textColor = UIColor.rgbColor(299.0, 0.0, 0.0)   //#E50000
                cell.viewDisableCell.alpha = 0
                if let topicId = chapterCell.topic_id
                {
                    let topicList = ["topic_id":"\(topicId)",
                        "status":"1" ]
                    self.updateUnitListArray(list: topicList)
                    self.updatedTopicList.append(topicList)
                }
                break
            case .NotStarted:
                cell.buttonCompleted.selectedDefaultButton()
                cell.buttonInProgress.selectedDefaultButton()
                cell.labelStatus.textColor = UIColor.rgbColor(126.0, 132.0, 155.0) //#7E849B
                cell.viewDisableCell.alpha = 0
                break
            }
            cell.selectionStyle = .none
            return cell
            
        case .Other:
            let cell:CustomSyllabusTopicTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.CustomSyllabusTopicTableViewCellId, for: indexPath) as! CustomSyllabusTopicTableViewCell
            cell.textFieldTopicInput.rx.text.map{ $0 ?? ""}.bind(to: self.customTopicString).disposed(by: cell.myCellDisposeBag)
            cell.selectionStyle = .none
            cell.textFieldTopicInput.inputAccessoryView = doneToolbarButton
            return cell
            
        case .none:
            return UITableViewCell()
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSourceObj:MarkSyllabusDataSource = arrayDataSource[section]
        switch dataSourceObj.syallbusCellType {
        case .Unit:
            return dataSourceObj.rowCount
        case .Other: return 1
        case .none: return 0
        }
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dataSourceObj:MarkSyllabusDataSource = arrayDataSource[section]
        switch dataSourceObj.syallbusCellType {
        case.Unit:
            
            let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewTopics.width(), height: 44))
            headerView.backgroundColor = Constants.colors.themeLightBlue
            
            let labelView:UILabel  = UILabel(frame: CGRect(x: 15, y: 0, width: self.tableviewTopics.width(), height: 44))
            labelView.center.y = headerView.centerY()
            guard let unitObj = dataSourceObj.attachedObject as? Offline_Unit_syllabus_array else{
                return nil
            }
            labelView.text = unitObj.unit_name
            labelView.textColor = UIColor.rgbColor(51, 51, 51)
            headerView.addSubview(labelView)
            return headerView
            
        default:return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    @objc func markChapterInProgress(_ sender: ButtonWithIndexPath){
        guard let indexpath = sender.indexPath,
            let chapterObj = self.syllabusData[(indexpath.section)].topic_list?[(indexpath.row)] else {
                return
        }
        if( chapterObj.status != "1"){
            chapterObj.setChapterStatus = "In Progress"
            chapterObj.status = "1"
            chapterObj.chapterStatusTheme = .InProgress
            chapterObj.isUpdated = true
            let topicList = ["topic_id":"\(chapterObj.topic_id ?? "")",
                "status":"1" ] //status 2 is for completed topic / 1 is for inprogress
            self.updateUnitListArray(list: topicList)
            self.updatedTopicList.append(topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }else{//Not Started
            chapterObj.setChapterStatus = "Not Started"
            chapterObj.chapterStatusTheme = .NotStarted
            chapterObj.status = "0"
            chapterObj.isUpdated = true
            let topicList = ["topic_id":"\(chapterObj.topic_id ?? "")",
                "status":"1" ]
            self.updateUnitListArray(list: topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }
        
    }
    
    @objc func markChapterInCompleted(_ sender: ButtonWithIndexPath){
        guard let indexpath = sender.indexPath,
            let chapterObj = self.syllabusData[(indexpath.section)].topic_list?[(indexpath.row)] else {
                return
        }
        if( chapterObj.status != "2"){
            chapterObj.setChapterStatus = "Completed"
            chapterObj.chapterStatusTheme = .Completed
            chapterObj.status = "2"
            chapterObj.isUpdated = true
            let topicList = ["topic_id":"\(chapterObj.topic_id ?? "")",
                "status":"2" ] //status 2 is for completed topic / 1 is for inprogress
            self.updateUnitListArray(list: topicList)
            self.updatedTopicList.append(topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }else{//Not Started
            chapterObj.setChapterStatus = "Not Started"
            chapterObj.chapterStatusTheme = .NotStarted
            chapterObj.status = "0"
            chapterObj.isUpdated = true
            let topicList = ["topic_id":"\(chapterObj.topic_id ?? "")",
                "status":"1" ]
            self.updateUnitListArray(list: topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }
    }
    
    func updateUnitListArray(list:[String:String]){
        for i in 0..<updatedTopicList.count{
            let topic = updatedTopicList[i]
            let tempCurrentTopic = topic["topic_id"] as! String
            let tempOuterTopic = list["topic_id"]
            if(tempCurrentTopic == tempOuterTopic){
                updatedTopicList.remove(at: i)
                return
            }
        }
    }
    
}
//MARK:- Keyboard delegate methods
extension OfflineMarkCompletedPortionViewController{
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            let newContentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            self.tableviewTopics.contentInset = newContentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let newContentInsets = UIEdgeInsets.zero
        self.tableviewTopics.contentInset = newContentInsets
    }
    
    func initToolbar(){
        doneToolbarButton = UIToolbar(frame: CGRect(x: 0, y: 0, width:  view.width(), height: 50))
        doneToolbarButton.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(OfflineMarkCompletedPortionViewController.doneButtonAction))

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbarButton.items = items
        doneToolbarButton.sizeToFit()

    }
    

    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }

}
