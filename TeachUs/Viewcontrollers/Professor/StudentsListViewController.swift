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
    var arrayDataSource:[AttendanceDatasource] = []
    var defaultAttendanceForAllStudents:Bool = true
    var datePicker: ViewDatePicker!
    var toTimePicker: ViewDatePicker!
    var fromTimePicker: ViewDatePicker!
    var numberPicker:ViewNumberPicker!
    var calenderFloatingView:ViewCalenderTop!
    var viewConfirmAttendance:ViewConfirmAttendance!
    var markedAttendanceId:NSNumber!
    private var previousOpenProfileIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    private var currentOpenProfileIndexPath: IndexPath = IndexPath(row: -1, section: 0)

    let disposeBag = DisposeBag()
    

    @IBOutlet weak var tableStudentList: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var topConstraintButtonSubmit: NSLayoutConstraint!
    
    
    //TODO:- COMAPRE textfield value of the cell
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedCollege != nil)
        {
            self.title = selectedCollege.subjectName!
            self.getEnrolledStudentsList()
        }
        
        self.tableStudentList.register(UINib(nibName: "AttendanceCalenderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.AttendanceCalenderTableViewCellId)
        self.tableStudentList.register(UINib(nibName: "AttendanceStudentListTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.AttendanceStudentListTableViewCellId)
        self.tableStudentList.register(UINib(nibName: "DefaultSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.DefaultSelectionTableViewCellId)
        self.tableStudentList.register(UINib(nibName: "AttendanceCountTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.AttendanceCountTableViewCellId)
        setUpcalenderView()
        initDatPicker()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
        self.addColorToNavBarText(color: UIColor.white)
        self.buttonSubmit.themeRedButton()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getEnrolledStudentsList(){
        /*
        let manager = NetworkHandler()
        //"http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus/teacher/getEnrolledStudentList/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?professorId=1&subjectId=1"
        
        manager.url = URLConstants.BaseUrl.baseURL + self.subject.enrolledStudentListUrl!
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGet(apiName: "Get enrolled Students", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                
                let studentDetailArray = response["studentDetail"] as! [[String:Any]]
                for student in studentDetailArray{
                    let studentDetail = Mapper<EnrolledStudentDetail>().map(JSON: student)
                    self.arrayStudentsDetails.append(studentDetail!)
                }
                if(self.arrayStudentsDetails.count > 0){
                    self.setUpTableView()
                }
            }
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
 */
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getStudentList
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
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
                if(self.arrayStudentsDetails.count > 0){
                    self.setUpTableView()
                }
            }
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
    }
 
    
    func setUpTableView(){
        print("Yoo")
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
        AttendanceManager.sharedAttendanceManager.arrayStudents.value.removeAll()
        for student in arrayStudentsDetails{
            let studentAttendance:MarkStudentAttendance = MarkStudentAttendance(student, self.defaultAttendanceForAllStudents)
            let studentDetailDataSource = AttendanceDatasource(celType: .studentProfile, attachedObject: studentAttendance)
            studentDetailDataSource.isSelected = false
            AttendanceManager.sharedAttendanceManager.arrayStudents.value.append(studentAttendance)

            arrayDataSource.append(studentDetailDataSource)

        }
        self.addCalenderValues()
        self.tableStudentList.reloadData()
    }
    
    func setUpcalenderView(){
        calenderFloatingView = ViewCalenderTop.instanceFromNib() as! ViewCalenderTop
        
        let y = (navBarHeight) + statusBarHeight
        calenderFloatingView.frame = CGRect(x: 0.0, y: (y), width: self.view.width(), height: 60.0)
        self.view.addSubview(calenderFloatingView)
        self.addCalenderValues()
        self.calenderFloatingView.alpha = 0
        
    }
    func addCalenderValues(){
        if(calenderFloatingView != nil){
            if(self.toTimePicker != nil && self.fromTimePicker != nil && self.numberPicker != nil && self.datePicker != nil){
                calenderFloatingView.labelDate.text = "\(self.datePicker.dateString)"
                calenderFloatingView.labelTime.text = "From \(self.fromTimePicker.timeString) to \(self.toTimePicker.timeString) "
                calenderFloatingView.labelNumberOfLectures.text = "Number of lectures: \(self.numberPicker.selectedValue.value)"
            }

        }
    }
    
    func checkLectureTiming() -> Bool{
        if(self.fromTimePicker.picker.date < self.toTimePicker.picker.date){
            return true
        }else{
            self.showAlterWithTitle("Wrong Date Range", alertMessage: "From time should be lesser than to time!")
        }
        return false
    }
    
    @IBAction func submitAttendance(_ sender: UIButton) {
        if(self.checkLectureTiming()){
            if(viewConfirmAttendance == nil){
                viewConfirmAttendance = ViewConfirmAttendance.instanceFromNib() as! ViewConfirmAttendance
                viewConfirmAttendance.delegate = self
            }
            let presentStudents = AttendanceManager.sharedAttendanceManager.arrayStudents.value.filter{$0.isPrsent == true}
            viewConfirmAttendance.labelStudentCount.text = "\(presentStudents.count)"
            viewConfirmAttendance.showView(inView: UIApplication.shared.keyWindow!)
        }
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
            let toTimeTap = UITapGestureRecognizer(target: self, action: #selector(StudentsListViewController.showToTimePicker))
            tap.numberOfTapsRequired = 1
            cell.textFieldToTime.tag = indexPath.row
            cell.textFieldToTime.isUserInteractionEnabled = true
            cell.textFieldToTime.addGestureRecognizer(toTimeTap)
            if(self.toTimePicker != nil){
                cell.textFieldToTime.text =  "\(self.toTimePicker.timeString)"
            }

            //from time
            let fromTimeTap = UITapGestureRecognizer(target: self, action: #selector(StudentsListViewController.showFromTimePicker))
            tap.numberOfTapsRequired = 1
            cell.textFieldFromTime.tag = indexPath.row
            cell.textFieldFromTime.isUserInteractionEnabled = true
            cell.textFieldFromTime.addGestureRecognizer(fromTimeTap)
            if(self.fromTimePicker != nil){
                cell.textFieldFromTime.text =  "\(self.fromTimePicker.timeString)"
            }
            
            // number of lectures
            let numberPickerTap = UITapGestureRecognizer(target: self, action: #selector(StudentsListViewController.showNumberPicker))
            tap.numberOfTapsRequired = 1
            cell.textFieldNumberOfLectures.tag = indexPath.row
            cell.textFieldNumberOfLectures.isUserInteractionEnabled = true
            cell.textFieldNumberOfLectures.addGestureRecognizer(numberPickerTap)
            if(self.numberPicker != nil){
                cell.textFieldNumberOfLectures.text =  "\(self.numberPicker.selectedValue.value)"
            }
            cell.delegate = self
            cell.setUpRx()
            cell.selectionStyle = .none
            return cell
            
        case .defaultSelection:
            let cell:DefaultSelectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.DefaultSelectionTableViewCellId, for: indexPath) as! DefaultSelectionTableViewCell

            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .attendanceCount:
            let cell:AttendanceCountTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.AttendanceCountTableViewCellId, for: indexPath) as! AttendanceCountTableViewCell
            let presentStudents = AttendanceManager.sharedAttendanceManager.arrayStudents.value.filter{$0.isPrsent == true}
            cell.labelAttendanceCount.text = "\(presentStudents.count)"

            cell.selectionStyle = .none

            return cell
            
        case .studentProfile:
            
            let cell : AttendanceStudentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.AttendanceStudentListTableViewCellId, for: indexPath) as! AttendanceStudentListTableViewCell
            let object:MarkStudentAttendance = cellDataSource.attachedObject! as! MarkStudentAttendance
            cell.labelName.text = object.student?.studentName
            cell.labelRollNumber.text = "\(object.student?.studentRollNo! ?? "NA")"
            cell.labelAttendanceCount.text = "\(object.student?.totalLecture! ?? "NA")"
            cell.labelAttendancePercent.text = "\(object.student?.percentage! ?? "NA") %"
            cell.labelLastLectureAttendance.text = object.student?.lastLectureAttendance != nil ? object.student?.lastLectureAttendance! : "NIL"
            cell.clipsToBounds = true
            cell.imageViewProfile.imageFromServerURL(urlString: (object.student?.imageUrl!)!, defaultImage: Constants.Images.defaultMale)
            
            //TODO:  -3 is for previous sections (calender, default selection, attendance count ) <- IMPORTANT
            
            cell.buttonAttendance.isSelected = AttendanceManager.sharedAttendanceManager.arrayStudents.value[indexPath.section-3].isPrsent
            cell.buttonAttendance.addTarget(self, action: #selector(StudentsListViewController.markAttendance), for: .touchUpInside)
            cell.buttonAttendance.indexPath = indexPath
            cell.setUpCell()
//            cell.setUpRx()
//            if(currentOpenProfileIndexPath != nil)
//            {
//                if(currentOpenProfileIndexPath.section == indexPath.section){
//                    cell.isExpanded = true
//                    cell.viewAttendanceDetails.alpha = 1
//                }else{
//                    cell.isExpanded = false
//                    cell.viewAttendanceDetails.alpha = 0
//                }
//            }else{
//                cell.isExpanded = false
//                cell.viewAttendanceDetails.alpha = 0
//            }
            cell.selectionStyle = .none
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
    
    //MARK:- Picker view methods for number and date.
    
    
    func initDatPicker(){
        if(datePicker == nil){
            datePicker = ViewDatePicker.instanceFromNib() as! ViewDatePicker
            datePicker.setUpPicker(type: .date)
            datePicker.buttonOk.addTarget(self, action: #selector(StudentsListViewController.dismissDatePicker), for: .touchUpInside)
            
            datePicker.picker.minimumDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
            datePicker.picker.maximumDate = NSCalendar.current.date(byAdding: .month, value: 0, to: Date())
        }
    }
    
    @objc func showDatePicker(){
            datePicker.showView(inView: self.view)
    }
    
    @objc func showFromTimePicker(){
        if(fromTimePicker == nil){
            fromTimePicker = ViewDatePicker.instanceFromNib() as! ViewDatePicker
            fromTimePicker.setUpPicker(type: .time)
            fromTimePicker.showView(inView: self.view)
            fromTimePicker.buttonOk.addTarget(self, action: #selector(StudentsListViewController.dismissFromTimePicker), for: .touchUpInside)
        }else{
            fromTimePicker.showView(inView: self.view)
        }
    }
    
    @objc func showToTimePicker(){
        if(toTimePicker == nil){
            toTimePicker = ViewDatePicker.instanceFromNib() as! ViewDatePicker
            toTimePicker.setUpPicker(type: .time)
            toTimePicker.showView(inView: self.view)
            toTimePicker.buttonOk.addTarget(self, action: #selector(StudentsListViewController.dismissToTimePicker), for: .touchUpInside)

        }else{
            toTimePicker.showView(inView: self.view)
        }
    }
    
    @objc func showNumberPicker(){
        if(numberPicker == nil){
            numberPicker = ViewNumberPicker.instanceFromNib() as! ViewNumberPicker
            numberPicker.setUpPicker()
            numberPicker.showView(inView: self.view)
            numberPicker.buttonOk.addTarget(self, action: #selector(StudentsListViewController.dismissNumberPicker), for: .touchUpInside)
            
        }else{
            numberPicker.showView(inView: self.view)
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
    
    @objc func dismissNumberPicker(){
        if(numberPicker != nil){
            numberPicker.alpha = 0
            numberPicker.removeFromSuperview()
            self.makeDataSource()
        }
    }
    
    //MARK:- Mark attendance for a student
    @objc func markAttendance(_ sender:ButtonWithIndexPath){
        if(sender.isSelected){ //-3 is for previous sections (calender, default selection, attendance count )
            AttendanceManager.sharedAttendanceManager.arrayStudents.value[sender.indexPath.section - 3].isPrsent = false
            sender.setTitle("Absent", for: .normal)
            sender.backgroundColor = UIColor.rgbColor(126, 132, 155)
            sender.setTitleColor(UIColor.white, for: .normal)
            
        }
        else{
            AttendanceManager.sharedAttendanceManager.arrayStudents.value[sender.indexPath.section - 3].isPrsent = true
            sender.setTitle("Present", for: .selected)
            sender.backgroundColor = UIColor.rgbColor(198, 0, 60)
            sender.setTitleColor(UIColor.white, for: .selected)
        }
        sender.isSelected = !sender.isSelected
        let indexPath = IndexPath(row: 0, section: 2)
        self.tableStudentList.reloadRows(at: [indexPath], with: .fade)
    }
}


//MARK:- Default Attendance Selection Delegate

extension StudentsListViewController:DefaultAttendanceSelectionDelegate{
    func selectDefaultAttendance(_ attendance: Bool) {
        self.defaultAttendanceForAllStudents = attendance
        self.makeDataSource()
    }
}

//MARK:- Calender delegate methods

extension StudentsListViewController:AttendanceCalenderTableViewCellDelegate{
    func showSubmit() {
        self.topConstraintButtonSubmit.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.topConstraintButtonSubmit.constant -= self.buttonSubmit.height()
        }
    }
    
    func hideSubmit() {
        self.topConstraintButtonSubmit.constant = -self.buttonSubmit.height()
        UIView.animate(withDuration: 0.3) {
            self.topConstraintButtonSubmit.constant = 0
        }
    }
}

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

extension StudentsListViewController:ViewConfirmAttendanceDelegate{
    
    
    func confirmAttendance() {
        /*
        self.performSegue(withIdentifier: Constants.segues.markPortionCompleted, sender: self)
 */
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.submitAttendance
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id":"\(self.selectedCollege.classId!)",
            "course_id":"\(self.selectedCollege.courseId!)",
            "subject_id":"\(self.selectedCollege.subjectId!)",
            "topics_covered":"1",
            "no_of_lecture":"\(self.numberPicker.selectedValue.value)",
            "lecture_date":"\(datePicker.postJsonDateString)",
            "from_time":"\(fromTimePicker.postJsonTimeString)",
            "to_time":"\(toTimePicker.postJsonTimeString)",
            "attendance_list":"\(AttendanceManager.sharedAttendanceManager.attendanceList)"
        ]
        
//        self.markedAttendanceId = 5
//        self.performSegue(withIdentifier: Constants.segues.markPortionCompleted, sender: self)

        
        manager.apiPost(apiName: "Mark student attendance", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                
                let alert = UIAlertController(title: nil, message: response["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.markedAttendanceId = response["att_id"] as! NSNumber
                    self.performSegue(withIdentifier: Constants.segues.markPortionCompleted, sender: self)

//                    for controller in self.navigationController!.viewControllers as Array {
//                        self.markedAttendanceId = response["att_id"]
//                        self.performSegue(withIdentifier: Constants.segues.markPortionCompleted, sender: self)
//                        if controller.isKind(of: HomeViewController.self) {
//                            self.navigationController!.popToViewController(controller, animated: true)
//                            break
//                        }
//                    }
                }))
                // show the alert
                self.present(alert, animated: true, completion:nil)
            }
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlterWithTitle(nil, alertMessage: errorMessage)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constants.segues.markPortionCompleted){
            let destinationVC:MarkCompletedPortionViewController = segue.destination as! MarkCompletedPortionViewController
            destinationVC.selectedCollege = self.selectedCollege
            destinationVC.attendanceId = self.markedAttendanceId
        }
    }
}
