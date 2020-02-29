//
//  StudentsAttendanceViewController.swift
//  TeachUs
//
//  Created by ios on 11/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import RxCocoa
import RxSwift

class StudentsListViewController: BaseViewController {
    
    var selectedCollege:College!
    var arrayStudentsDetails:[EnrolledStudentDetail] = []
    var arraySearchStudentDetails = [EnrolledStudentDetail]()
    var arrayDataSource:[AttendanceDatasource] = []
    var datePicker: ViewDatePicker!
    var toTimePicker: ViewDatePicker!
    var fromTimePicker: ViewDatePicker!
    var calenderFloatingView:ViewCalenderTop!
    var viewConfirmAttendance:ViewConfirmAttendance!
    var markedAttendanceId:NSNumber!
    private var previousOpenProfileIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    private var currentOpenProfileIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    var isDefaultAttencdanceChanged:Bool = true
    var parameters:[String:Any] = [:]
    var syllabusData:SyllabusStatusData!
    var numberOfLectures = Variable<Int>(1)

    let searchBarStudents = UISearchBar()
    var searchText:String = ""
    
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var tableStudentList: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var topConstraintButtonSubmit: NSLayoutConstraint!
    var defaultbuttonIndexpath:Int?
    
    //TODO:- COMAPRE textfield value of the cell
    
    //For Edit Attendance flow
    var isEditAttendanceFlow:Bool = false
    var selectedAttendanceId:Int?
    var lectureDetails:EditAttendanceLectureInfo!
    var previousLectureAttendanceList:LastLectureAttendance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isEditAttendanceFlow{
            self.getListForAttendanceEdit()
        }else{
            if(selectedCollege != nil)
            {
                self.title = selectedCollege.subjectName!
                let dataQueue = OperationQueue()
                dataQueue.addOperation {
                    self.getEnrolledStudentsList()
                }
                dataQueue.addOperation {
                    self.getTopics()
                }
                dataQueue.waitUntilAllOperationsAreFinished()
            }
        }
        
        self.tableStudentList.register(UINib(nibName: "AttendanceCalenderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.AttendanceCalenderTableViewCellId)
        self.tableStudentList.register(UINib(nibName: "AttendanceStudentListTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.AttendanceStudentListTableViewCellId)
        self.tableStudentList.register(UINib(nibName: "DefaultSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.DefaultSelectionTableViewCellId)
        self.tableStudentList.register(UINib(nibName: "AttendanceCountTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.AttendanceCountTableViewCellId)
        setUpcalenderView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(StudentsListViewController.showSearchBar(_:)))
        searchBarStudents.delegate = self
        self.setUpKeyboardObservers()
        
    }
    var isSearchBarShown:Bool = false
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
        self.addColorToNavBarText(color: UIColor.white)
        self.buttonSubmit.themeRedButton()
        self.buttonSubmit.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ReachabilityManager.shared.pauseMonitoring()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func showSearchBar(_ sender: Any) {
        searchBarStudents.sizeToFit()
        if !isSearchBarShown{
            isSearchBarShown.toggle()
            navigationItem.titleView = searchBarStudents
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(StudentsListViewController.showSearchBar(_:)))
            if let indexScrolled = self.defaultbuttonIndexpath{
                let indexpathValue = IndexPath(row: 0, section: indexScrolled)
                self.tableStudentList.scrollToRow(at: indexpathValue, at: .top, animated: true)
            }
            self.searchBarStudents.becomeFirstResponder()
        }else{
            isSearchBarShown.toggle()
            self.searchText = ""
            self.searchBarStudents.text = ""
            navigationItem.titleView = nil
            self.searchBarStudents.resignFirstResponder()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(StudentsListViewController.showSearchBar(_:)))
            self.tableStudentList.setContentOffset(.zero, animated: true)
            self.makeDataSource()
        }
        
    }
    
    func setUpKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(StudentsListViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StudentsListViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func getListForAttendanceEdit(){
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getEditAttendanceData
        DispatchQueue.main.async {
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        }
        
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "attendance_id":"\(self.selectedAttendanceId ?? 0)"
        ]
        manager.apiPost(apiName: "Get Edit Attendance data", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                if let lectureInfo = response["lecture_info"] as? [String:Any]{
                    self.lectureDetails = Mapper<EditAttendanceLectureInfo>().map(JSON:lectureInfo)
                    
                }
                
                if let studentDetailArray = response["attendance_data"] as? [[String:Any]]{
                    for student in studentDetailArray{
                        let studentDetail = Mapper<EnrolledStudentDetail>().map(JSON: student)
                        self.arrayStudentsDetails.append(studentDetail!)
                    }
                }
                
                if (Int((self.arrayStudentsDetails.first?.studentRollNo)!)) != nil{
                    self.arrayStudentsDetails.sort(by: {Int($0.studentRollNo!)! < Int($1.studentRollNo!)!})
                }
                else{
                    self.arrayStudentsDetails.sort( by: {$0.studentRollNo!.localizedStandardCompare($1.studentRollNo!) == .orderedAscending})
                    
                }
                if(self.arrayStudentsDetails.count > 0){
                    self.numberOfLectures.value = Int(self.lectureDetails.numberOfLectures) ?? 1
                    self.initDatPicker()
                    self.initTimePickers()
                    self.setUpTableView()
                }
            }
            else{
                self.showErrorAlert(ErrorType.ServerCallFailed, retry: { (retry) in
                    if(retry){
                        self.getListForAttendanceEdit()
                    }
                })
            }
            
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
        
    }
    
    func getEnrolledStudentsList(){
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getStudentList
        DispatchQueue.main.async {
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        }
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id":"\(self.selectedCollege.classId!)",
            "subject_id":"\(self.selectedCollege.subjectId!)"
        ]
        manager.apiPost(apiName: "Get student list", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                let studentDetailArray = response["student_list"] as! [[String:Any]]
                for student in studentDetailArray{
                    let studentDetail = Mapper<EnrolledStudentDetail>().map(JSON: student)
                    self.arrayStudentsDetails.append(studentDetail!)
                }
                
                
                if let student = self.arrayStudentsDetails.first{
                    if (Int(student.studentRollNo!) != nil){
                        self.arrayStudentsDetails.sort(by: {(Int($0.studentRollNo ?? "") ?? 0) < (Int($1.studentRollNo ?? "") ?? 0)})

                    }else{
                        self.arrayStudentsDetails.sort( by: {$0.studentRollNo!.localizedStandardCompare($1.studentRollNo ?? "") == .orderedAscending})

                    }
                }
                
                if(self.arrayStudentsDetails.count > 0){
                    self.initDatPicker()
                    self.setUpTableView()
                }
            }
            else{
                self.showErrorAlert(ErrorType.ServerCallFailed, retry: { (retry) in
                    if(retry){
                        self.getEnrolledStudentsList()
                    }
                })
            }
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
    }
    
    func getTopics(){
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getSyllabusSuubjectDetails
        var parameters = [String:Any]()
        parameters["subject_id"] = "\(selectedCollege.subjectId!)"
        parameters["class_id"] = "\(selectedCollege.classId!)"
        parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        DispatchQueue.main.async {
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        }
    
        
        
        manager.apiPostWithDataResponse(apiName: "Get topics for professor", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
            do{
                let decoder = JSONDecoder()
                self.syllabusData = try decoder.decode(SyllabusStatusData.self, from: response)
            }
            catch let error{
                print("err", error)
            }
            }else{
                self.showErrorAlert(ErrorType.ServerCallFailed, retry: { (retry) in
                    if(retry){
                        self.getTopics()
                    }
                })
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlertWithTitle("Error", alertMessage: message)
            
        }
    }
    
    
    func setUpTableView(){
        self.tableStudentList.delegate = self
        self.tableStudentList.dataSource = self
        self.makeDataSource()
    }
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        let calenderDataSource = AttendanceDatasource(celType: .calender, attachedObject: nil)
        calenderDataSource.isSelected = false
        arrayDataSource.append(calenderDataSource)
        
        let defaultSelectionDataSource = AttendanceDatasource(celType: .defaultSelection, attachedObject: nil)
        defaultSelectionDataSource.isSelected = false
        arrayDataSource.append(defaultSelectionDataSource)
        
        let presentCountDataSource = AttendanceDatasource(celType: .attendanceCount, attachedObject: nil)
        presentCountDataSource.isSelected = false
        arrayDataSource.append(presentCountDataSource)
        self.defaultbuttonIndexpath = self.arrayDataSource.count-1 //minus 1 as per array notation, count return real numbers starting from 1.
        //Add students name
        var arrayEnrolledStudents = [EnrolledStudentDetail]()
        if !self.searchText.isEmpty{
           arrayEnrolledStudents = arraySearchStudentDetails
        }else{
            arrayEnrolledStudents = self.arrayStudentsDetails
        }
        
        if(self.isDefaultAttencdanceChanged){
            self.isDefaultAttencdanceChanged = false
            AttendanceManager.sharedAttendanceManager.arrayStudents.value.removeAll()
            
            for student in arrayEnrolledStudents{
                var studentAttendance:MarkStudentAttendance!
                if(self.isEditAttendanceFlow){
                    let status = Int(student.attendanceStatus ?? "0") ?? 0
                    studentAttendance = MarkStudentAttendance(student, status.boolValue)

                }else{
                    studentAttendance = MarkStudentAttendance(student, AttendanceManager.sharedAttendanceManager.defaultAttendanceForAllStudents)
                }
                let studentDetailDataSource = AttendanceDatasource(celType: .studentProfile, attachedObject: studentAttendance)
                studentDetailDataSource.isSelected = false
                AttendanceManager.sharedAttendanceManager.arrayStudents.value.append(studentAttendance)
                arrayDataSource.append(studentDetailDataSource)
            }
        }else{
            for student in AttendanceManager.sharedAttendanceManager.arrayStudents.value{
                if let studentObject = student.student{
                    if arrayEnrolledStudents.contains(where: {$0.studentId == studentObject.studentId}) && !self.searchText.isEmpty{
                        let studentAttendance:MarkStudentAttendance = MarkStudentAttendance(studentObject, student.isPrsent!)
                        let studentDetailDataSource = AttendanceDatasource(celType: .studentProfile, attachedObject: studentAttendance)
                        studentDetailDataSource.isSelected = false
                        //                AttendanceManager.sharedAttendanceManager.arrayStudents.value.append(studentAttendance)
                        arrayDataSource.append(studentDetailDataSource)
                        
                    }else if self.searchText.isEmpty{
                        let studentAttendance:MarkStudentAttendance = MarkStudentAttendance(studentObject, student.isPrsent!)
                        let studentDetailDataSource = AttendanceDatasource(celType: .studentProfile, attachedObject: studentAttendance)
                        studentDetailDataSource.isSelected = false
                        //                AttendanceManager.sharedAttendanceManager.arrayStudents.value.append(studentAttendance)
                        arrayDataSource.append(studentDetailDataSource)
                    }
                }
            }
        }
        self.addCalenderValues()
        
        DispatchQueue.main.async {
            self.tableStudentList.reloadData()
        }
    }
    
    func setUpcalenderView(){
        calenderFloatingView = ViewCalenderTop.instanceFromNib() as? ViewCalenderTop
        
        let y = (navBarHeight) + statusBarHeight
        calenderFloatingView.frame = CGRect(x: 0.0, y: (y), width: self.view.width(), height: 60.0)
        self.view.addSubview(calenderFloatingView)
        self.addCalenderValues()
        self.calenderFloatingView.alpha = 0
        
    }
    func addCalenderValues(){
        if(calenderFloatingView != nil){
            if(self.toTimePicker != nil && self.fromTimePicker != nil && self.numberOfLectures.value != nil && self.datePicker != nil){
                calenderFloatingView.labelDate.text = "\(self.datePicker.dateString)"
                calenderFloatingView.labelTime.text = "From \(self.fromTimePicker.timeString) to \(self.toTimePicker.timeString) "
                calenderFloatingView.labelNumberOfLectures.text = "Number of lectures: \(self.numberOfLectures.value)"
            }
            
        }
    }
    
    func checkLectureTiming() -> Bool{
        let difference = Calendar.current.dateComponents([.hour, .minute], from: self.fromTimePicker.picker.date, to: self.toTimePicker.picker.date)
        #if DEBUG
        print(difference)
        #endif
        if(difference.hour! > 0 || difference.minute! > 0){
            return true
        }else{
            self.showAlertWithTitle("Wrong Date Range", alertMessage: "From time should be lesser than to time!")
        }
        return false
    }
    
    @IBAction func submitAttendance(_ sender: UIButton) {
        if(self.checkLectureTiming()){
            Vibration.warning.vibrate()
            if(viewConfirmAttendance == nil){
                viewConfirmAttendance = ViewConfirmAttendance.instanceFromNib() as? ViewConfirmAttendance
                viewConfirmAttendance.delegate = self
            }
            let presentStudents = AttendanceManager.sharedAttendanceManager.arrayStudents.value.filter{$0.isPrsent == true}
            viewConfirmAttendance.labelStudentCount.text = "\(presentStudents.count)/\(AttendanceManager.sharedAttendanceManager.arrayStudents.value.count)"
            viewConfirmAttendance.showView(inView: UIApplication.shared.keyWindow!)
        }
    }
    
    private func checkForDuplicateAttendance(_ completion:@escaping(_ success:Bool) -> Void){
        
        
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.duplicateAttendanceCheck
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id":"\(self.selectedCollege.classId!)",
            "subject_id":"\(self.selectedCollege.subjectId!)",
            "from_time":"\(fromTimePicker.postJsonTimeString)",
            "to_time":"\(toTimePicker.postJsonTimeString)",
            "lecture_date":"\(datePicker.postJsonDateString)",
            "course_id":"\(self.selectedCollege.courseId!)",
        ]
        
        manager.apiPost(apiName: "Check for duplicate Attendance entry" , parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 406){
                if let responseMessage = response["message"] as? String{
                    if responseMessage.caseInsensitiveCompare("Duplicate data entry") == ComparisonResult.orderedSame{
                        let alert = UIAlertController(title: nil, message: responseMessage, preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                            completion(true)

                            
                        }))
                        // show the alert
                        self.present(alert, animated: true, completion:nil)
                        
                    }else{
                        completion(false)
                    }
                }
            }else{
                completion(false)
            }
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlertWithTitle(nil, alertMessage: errorMessage)
            completion(false)
        }
    }
    
    private func submitEditedAttendance(){
//        let manager = NetworkHandler()
//        manager.url = URLConstants.ProfessorURL.submitEditedAttendace
//        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "attendance_id":"\(self.selectedAttendanceId ?? 0)",
            "students":"\(AttendanceManager.sharedAttendanceManager.attendanceList)",
            "from_time":"\(fromTimePicker.postJsonTimeString)",
            "to_time":"\(toTimePicker.postJsonTimeString)",
            "lecture_date":"\(datePicker.postJsonDateString)",
            "no_of_lecture":"\(self.numberOfLectures.value)"
        ]
        
        
        let alert = UIAlertController(title: nil, message: "Attendance Recorded", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            self.performSegue(withIdentifier: Constants.segues.markPortionCompleted, sender: self)
        }))
        self.present(alert, animated: true, completion:nil)
        
        /*
        manager.apiPost(apiName: "Edit attendance for id \(self.selectedAttendanceId ?? 0)", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                
                let alert = UIAlertController(title: nil, message: response["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                    
                }))
                // show the alert
                self.present(alert, animated: true, completion:nil)
            }
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlertWithTitle(nil, alertMessage: errorMessage)
        }
 */
    }
}

//MARK:- table view Delegate
extension StudentsListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDataSource = arrayDataSource[indexPath.section]
        switch cellDataSource.AttendanceCellType! {
        case .calender:
            let cell:AttendanceCalenderTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.AttendanceCalenderTableViewCellId, for: indexPath) as! AttendanceCalenderTableViewCell
            cell.buttonEdit.addTarget(self, action: #selector(StudentsListViewController.showDatePicker), for: .touchUpInside)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(StudentsListViewController.showDatePicker))
            tap.numberOfTapsRequired = 1
            cell.labelDate.tag = indexPath.row
            cell.labelDate.isUserInteractionEnabled = true
            cell.labelDate.addGestureRecognizer(tap)
            
            if(self.datePicker != nil){
                cell.labelDate.text = "\(self.datePicker.dateString)"
            }
            
            //To time
            cell.buttonToTime.addTarget(self, action: #selector(StudentsListViewController.showToTimePicker), for: .touchUpInside)
            let toTimeTap = UITapGestureRecognizer(target: self, action: #selector(StudentsListViewController.showToTimePicker))
            tap.numberOfTapsRequired = 1
            cell.textFieldToTime.tag = indexPath.row
            cell.textFieldToTime.isUserInteractionEnabled = true
            cell.textFieldToTime.addGestureRecognizer(toTimeTap)
            if(self.toTimePicker != nil){
                cell.textFieldToTime.text =  "\(self.toTimePicker.timeString)"
            }
            
            //from time
            cell.buttonFromTime.addTarget(self, action: #selector(StudentsListViewController.showFromTimePicker), for: .touchUpInside)
            let fromTimeTap = UITapGestureRecognizer(target: self, action: #selector(StudentsListViewController.showFromTimePicker))
            tap.numberOfTapsRequired = 1
            cell.textFieldFromTime.tag = indexPath.row
            cell.textFieldFromTime.isUserInteractionEnabled = true
            cell.textFieldFromTime.addGestureRecognizer(fromTimeTap)
            if(self.fromTimePicker != nil){
                cell.textFieldFromTime.text =  "\(self.fromTimePicker.timeString)"
            }
            
            // number of lectures
            
            cell.numberOflecturesTaken = self.numberOfLectures.value
            tap.numberOfTapsRequired = 1
            
            cell.delegate = self
            cell.setUpRx()
            cell.selectionStyle = .none
            return cell
            
        case .defaultSelection:
            let cell:DefaultSelectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.DefaultSelectionTableViewCellId, for: indexPath) as! DefaultSelectionTableViewCell
            cell.buttonFetchPreviAttendance.isHidden = isEditAttendanceFlow
            
            cell.delegate = self
            cell.selectionStyle = .none
            cell.performPresentButtonUIChanges()
            return cell
            
        case .attendanceCount:
            let cell:AttendanceCountTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.AttendanceCountTableViewCellId, for: indexPath) as! AttendanceCountTableViewCell
            let presentStudents = AttendanceManager.sharedAttendanceManager.arrayStudents.value.filter{$0.isPrsent == true}
            cell.labelAttendanceCount.text = "\(presentStudents.count)"
            cell.labelPresent.text = presentStudents.count <= 1 ? "PRESENT":"PRESENTS"
            
            cell.selectionStyle = .none
            
            return cell
            
        case .studentProfile:
            
            let cell : AttendanceStudentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.AttendanceStudentListTableViewCellId, for: indexPath) as! AttendanceStudentListTableViewCell
            if let enrolledStudent = cellDataSource.attachedObject as? MarkStudentAttendance,
                let object = AttendanceManager.sharedAttendanceManager.arrayStudents.value.filter({$0.student?.studentId == enrolledStudent.student?.studentId}).first{
                
                cell.labelName.attributedText = object.student?.studentName?.addColorForString(self.searchText, stringColor: Constants.colors.themeRed)
                cell.labelRollNumber.attributedText = object.student?.studentRollNo?.addColorForString(self.searchText, stringColor: Constants.colors.themeRed)
                cell.labelAttendanceCount.text = "\(object.student?.totalLecture ?? "NA")"
                cell.labelAttendancePercent.text = "\(object.student?.percentage ?? "NA") %"
                cell.labelLastLectureAttendance.text = object.student?.lastLectureAttendance != nil ? object.student?.lastLectureAttendance! : "NIL"
                cell.clipsToBounds = true
                if(!(object.student?.imageUrl?.isEmpty ?? false)){
                    cell.imageViewProfile.imageFromServerURL(urlString: (object.student?.imageUrl!)!, defaultImage: Constants.Images.defaultMale)
                }else{
                    cell.imageViewProfile.image = UIImage(named: Constants.Images.defaultMale)
                }
                cell.buttonAttendance.isSelected = object.isPrsent
                cell.buttonAttendance.indexPath = indexPath
                cell.buttonAttendance.addTarget(self, action: #selector(StudentsListViewController.markAttendance), for: .touchUpInside)
                print("adding value for \(object.student?.studentRollNo ?? "") value \(object.isPrsent ?? false)")
                cell.setUpCell()
                cell.imageViewProfile.callback = {
                    self.imageTapped(view: cell.imageViewProfile)
                }
                cell.selectionStyle = .none
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellDataSource = arrayDataSource[indexPath.section]
        switch cellDataSource.AttendanceCellType! {
        case .calender:
            return 208
            
        case .defaultSelection:
            return 50
            
        case .attendanceCount:
            return 40
            
        case .studentProfile:
            if(indexPath.section == currentOpenProfileIndexPath.section)
            {
                return 200
            }
            else{
                return 100
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellDataSource = arrayDataSource[indexPath.section]
        
        if(cellDataSource.AttendanceCellType! == .studentProfile){
            if(currentOpenProfileIndexPath == indexPath){
                currentOpenProfileIndexPath = IndexPath(row: -1, section: 0)
                let cell:AttendanceStudentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.AttendanceStudentListTableViewCellId, for: indexPath) as! AttendanceStudentListTableViewCell
                tableView.beginUpdates()
                cell.isExpanded = false
                tableView.endUpdates()
            }
            else{
                self.currentOpenProfileIndexPath = indexPath
                let cell:AttendanceStudentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.AttendanceStudentListTableViewCellId, for: indexPath) as! AttendanceStudentListTableViewCell
                tableView.beginUpdates()
                cell.isExpanded = true
                tableView.endUpdates()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellDataSource = arrayDataSource[section]
        switch cellDataSource.AttendanceCellType! {
            
        case .defaultSelection,
             .attendanceCount:
            return 0
            
        default:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.width(), height: 0))
        headerView.backgroundColor = UIColor.clear
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == arrayDataSource.count-1){
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.width(), height: 0))
        footer.backgroundColor = UIColor.clear
        return footer
    }
    
    //MARK:- Picker view methods for number and date.
    
    
    func initDatPicker(){
        if(datePicker == nil){
            datePicker = ViewDatePicker.instanceFromNib() as? ViewDatePicker
            datePicker.setUpPicker(type: .date)
            datePicker.buttonOk.addTarget(self, action: #selector(StudentsListViewController.dismissDatePicker), for: .touchUpInside)
            if self.isEditAttendanceFlow{
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd" //2018-12-01
                let lectureDate = formatter.date(from: self.lectureDetails.lectureDate)
                datePicker.picker.date = lectureDate ?? Date()
                datePicker.picker.minimumDate = NSCalendar.current.date(byAdding: .month, value: -6, to: lectureDate ?? Date())
                datePicker.picker.maximumDate = NSCalendar.current.date(byAdding: .month, value: 0, to: lectureDate ?? Date())
            }else{
                datePicker.picker.minimumDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
                datePicker.picker.maximumDate = NSCalendar.current.date(byAdding: .month, value: 0, to: Date())
            }
        }
    }
    
    @objc func showDatePicker(){
        datePicker.showView(inView: self.view)
    }
    
    //MARK:- Time picker methods
    
    func initTimePickers(){
        if self.isEditAttendanceFlow{
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm" //7:22 Am
            let lectureFromTime = formatter.date(from: self.lectureDetails.fromTime)
            let lectureToTime = formatter.date(from: self.lectureDetails.toTime)
            
            //Set Up from time
            if(fromTimePicker == nil){
                self.initFromTimePicker()
                self.fromTimePicker.picker.date = lectureFromTime ?? Date()
            }else{
                self.fromTimePicker.picker.date = lectureFromTime ?? Date()
            }
            
            //Set Up to time
            if (toTimePicker == nil)
            {
                self.initToTimePicker()
                self.toTimePicker.picker.date = lectureToTime ?? Date()
            }else{
                self.toTimePicker.picker.date = lectureToTime ?? Date()
            }
        }
    }
    
    func initFromTimePicker(){
        fromTimePicker = ViewDatePicker.instanceFromNib() as? ViewDatePicker
        fromTimePicker.setUpPicker(type: .time)
        fromTimePicker.buttonOk.addTarget(self, action: #selector(StudentsListViewController.dismissFromTimePicker), for: .touchUpInside)

    }
    
    func initToTimePicker(){
        toTimePicker = ViewDatePicker.instanceFromNib() as? ViewDatePicker
        toTimePicker.setUpPicker(type: .time)
        toTimePicker.buttonOk.addTarget(self, action: #selector(StudentsListViewController.dismissToTimePicker), for: .touchUpInside)
    }
    
    @objc func showFromTimePicker(){
        if(fromTimePicker == nil){
            self.initFromTimePicker()
            fromTimePicker.showView(inView: self.view)
        }else{
            fromTimePicker.showView(inView: self.view)
        }
    }
    
    @objc func showToTimePicker(){
        if(toTimePicker == nil){
            self.initToTimePicker()
            if self.fromTimePicker != nil{
                
                self.toTimePicker.picker.date = NSCalendar.current.date(byAdding: .hour, value: 1, to: self.fromTimePicker.picker.date ) ?? Date()
            }else{
                self.toTimePicker.picker.date = Date()
            }
            toTimePicker.showView(inView: self.view)
            
        }else{
            self.toTimePicker.picker.date = NSCalendar.current.date(byAdding: .hour, value: 1, to: self.fromTimePicker.picker.date ) ?? Date()
            toTimePicker.showView(inView: self.view)
        }
    }
    
    @objc func dismissFromTimePicker(){
        if(fromTimePicker != nil)
        {
            fromTimePicker.alpha = 0
            fromTimePicker.removeFromSuperview()
            self.makeDataSource()

        }
    }
    @objc func dismissToTimePicker(){
        if(toTimePicker != nil){
            toTimePicker.alpha = 0
            toTimePicker.removeFromSuperview()
            self.makeDataSource()

        }
    }
    @objc func dismissDatePicker(){
        if(datePicker != nil){
            datePicker.alpha = 0
            datePicker.removeFromSuperview()
            self.makeDataSource()
        }
    }

    
    //MARK:- Mark attendance for a student
    @objc func markAttendance(_ sender:ButtonWithIndexPath)
    {
        let cellDs = self.arrayDataSource[sender.indexPath.section]
        if let enrolledStudent = cellDs.attachedObject as? MarkStudentAttendance,
            let studentObject = AttendanceManager.sharedAttendanceManager.arrayStudents.value.filter({$0.student?.studentId == enrolledStudent.student?.studentId}).first
        {
            if sender.isSelected{
                studentObject.isPrsent = false
                sender.setTitle("Absent", for: .normal)
                sender.backgroundColor = UIColor.rgbColor(126, 132, 155)
                sender.setTitleColor(UIColor.white, for: .normal)
            }
            else{
                studentObject.isPrsent = true
                sender.setTitle("Present", for: .selected)
                sender.backgroundColor = UIColor.rgbColor(198, 0, 60)
                sender.setTitleColor(UIColor.white, for: .selected)
                
            }
        }
        sender.isSelected.toggle()
        let indexPath = IndexPath(row: 0, section: 2)
        self.tableStudentList.reloadRows(at: [indexPath], with: .fade)
    }
}


//MARK:- Default Attendance Selection Delegate

extension StudentsListViewController:DefaultAttendanceSelectionDelegate, UIAdaptivePresentationControllerDelegate, GridViewDelegate{
    func gridDismissed() {
        tableStudentList.reloadData()
    }
    
    func showGridView() {
        if let gridViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.viewControllerId.rollNumberGridVC) as? StudentListGridViewController{
//            var holderFrame = self.view.frame
//            holderFrame.origin.y += self.calenderFloatingView.bottom()
//            holderFrame.size.height -= self.calenderFloatingView.height()
//            if let indexScrolled = self.defaultbuttonIndexpath{
//                let indexpathValue = IndexPath(row: 0, section: indexScrolled)
//                self.tableStudentList.scrollToRow(at: indexpathValue, at: .top, animated: true)
//            }
            gridViewController.delegate = self
            gridViewController.presentationController?.delegate = self
            self.present(gridViewController, animated: true, completion: nil)
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        tableStudentList.reloadData()
    }
    
    fileprivate func addPreviousLectureAttendanceValue() {
        for student in AttendanceManager.sharedAttendanceManager.arrayStudents.value{
            if let previousValue = self.previousLectureAttendanceList?.lastAttendanceDetail.filter({
                $0.studentID == student.student?.studentId
            }).first{
                student.isPrsent = previousValue.attStatus == "1" ? true : false
            }
        }
        self.makeDataSource()
    }
    
    func getPreviousLectureAttendance() {
        if self.previousLectureAttendanceList  == nil{
            let manager = NetworkHandler()
            manager.url = URLConstants.ProfessorURL.getPreviousLecture
            DispatchQueue.main.async {
                LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
            }
            
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let datestring = dateFormatter.string(from: currentDate)
            
            let parameters = [
                "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                "class_id":"\(self.selectedCollege?.classId ?? "")",
                "subject_id": "\(self.selectedCollege?.subjectId ?? "")",
                "date":"\(datestring)"
            ]
            manager.apiPostWithDataResponse(apiName: "Get Last lecture Attendance data", parameters:parameters, completionHandler: { (result, code, response) in
                LoadingActivityHUD.hideProgressHUD()
                if(code == 200){
                    //                LastLectureAttendance.swift
                    do{
                        let myDecoder = JSONDecoder()
                        self.previousLectureAttendanceList = try myDecoder.decode(LastLectureAttendance.self, from: response)
                        self.addPreviousLectureAttendanceValue()
                    } catch let error{
                        print(error)
                    }
                }
                else{
                    self.showErrorAlert(ErrorType.ServerCallFailed, retry: { (retry) in
                        if(retry){
                            self.getListForAttendanceEdit()
                        }
                    })
                }
                
            }) { (error, code, errorMessage) in
                LoadingActivityHUD.hideProgressHUD()
                print(errorMessage)
            }
        }else{
            self.addPreviousLectureAttendanceValue()
        }
    }
    
    func selectDefaultAttendance(_ attendance: Bool) {
        AttendanceManager.sharedAttendanceManager.defaultAttendanceForAllStudents = attendance
        self.isDefaultAttencdanceChanged = true
        self.makeDataSource()
    }
}

//MARK:- Calender delegate methods

extension StudentsListViewController:AttendanceCalenderTableViewCellDelegate{
    func numberOfLecturesSelected(lectures: Int) {
        self.numberOfLectures.value = lectures
        self.makeDataSource()
    }
    
    func showSubmit() {
        self.buttonSubmit.isHidden = false
        self.topConstraintButtonSubmit.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.topConstraintButtonSubmit.constant -= self.buttonSubmit.height()
        }
    }
    
    func hideSubmit() {
        self.topConstraintButtonSubmit.constant = -self.buttonSubmit.height()
        UIView.animate(withDuration: 0.3) {
            self.topConstraintButtonSubmit.constant = 0
            self.buttonSubmit.isHidden = true
        }
    }
}

//MARK:- UIScrollViewDelegate
extension StudentsListViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 210 {
            self.calenderFloatingView.alpha = (scrollView.contentOffset.y/260)
            //        } else if scrollView.contentOffset.y < 320  {
        }else{
            self.calenderFloatingView.alpha = ((scrollView.contentOffset.y - 210)/260)
        }
    }
}


//MARK:- ViewConfirmAttendanceDelegate
extension StudentsListViewController:ViewConfirmAttendanceDelegate{
    
    internal func confirmAttendance(){
        if self.isEditAttendanceFlow{
            self.submitEditedAttendance()
            
        }else{
            self.checkForDuplicateAttendance { (isAttendancePresent) in
                if !isAttendancePresent{
                    self.parameters = [
                        "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                        "class_id":"\(self.selectedCollege.classId!)",
                        "course_id":"\(self.selectedCollege.courseId!)",
                        "subject_id":"\(self.selectedCollege.subjectId!)",
                        "topics_covered":"1",
                        "no_of_lecture":"\(self.numberOfLectures.value)",
                        "lecture_date":"\(self.datePicker.postJsonDateString)",
                        "from_time":"\(self.fromTimePicker.postJsonTimeString)",
                        "to_time":"\(self.toTimePicker.postJsonTimeString)",
                        "attendance_list":"\(AttendanceManager.sharedAttendanceManager.attendanceList)"
                    ]
                    
                    let alert = UIAlertController(title: nil, message: "Attendance Recorded", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                        self.performSegue(withIdentifier: Constants.segues.markPortionCompleted, sender: self)
                    }))
                    self.present(alert, animated: true, completion:nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constants.segues.markPortionCompleted){
            let destinationVC:MarkCompletedPortionViewController = segue.destination as! MarkCompletedPortionViewController
            destinationVC.syllabusData          = self.syllabusData
            destinationVC.selectedCollege       = self.selectedCollege
            destinationVC.attendanceId          = self.isEditAttendanceFlow ? NSNumber(integerLiteral: self.selectedAttendanceId ?? 0) : self.markedAttendanceId
            destinationVC.isEditAttendanceFlow  = self.isEditAttendanceFlow
            destinationVC.attendanceParameters  = self.parameters
            destinationVC.lectureDetails        = self.lectureDetails
        }
    }
}

//MARK:- UISearchBarDelegate
extension StudentsListViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText = \(searchText)")
        self.searchText = searchText
        arraySearchStudentDetails = self.arrayStudentsDetails.filter({ (enrolledStudentObject) -> Bool in
            return (enrolledStudentObject.studentName?.lowercased().contains(self.searchText.lowercased()) ?? false ) || (enrolledStudentObject.studentRollNo?.contains(self.searchText.lowercased()) ?? false)
        })
        print("arraySearchStudentDetails \(arraySearchStudentDetails.count)")
        self.makeDataSource()
    }
}

//MARK:- Keyboard delegate methods
extension StudentsListViewController{
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            let newContentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            self.tableStudentList.contentInset = newContentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let newContentInsets = UIEdgeInsets.zero
        self.tableStudentList.contentInset = newContentInsets
    }
}
