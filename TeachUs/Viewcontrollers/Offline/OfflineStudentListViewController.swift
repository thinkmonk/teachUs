//
//  OfflineStudentListViewController.swift
//  TeachUs
//
//  Created by ios on 7/21/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa

class OfflineStudentListViewController: BaseViewController {
    
    var selectedCollege:Offline_Class_list!
    var arrayStudentsDetails:[Offline_Student_list] = []
    var arrayDataSource:[AttendanceDatasource] = []
    var defaultAttendanceForAllStudents:Bool = true
    var datePicker: ViewDatePicker!
    var toTimePicker: ViewDatePicker!
    var fromTimePicker: ViewDatePicker!
    var calenderFloatingView:ViewCalenderTop!
    var viewConfirmAttendance:ViewConfirmAttendance!
    var markedAttendanceId:NSNumber!
    private var previousOpenProfileIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    private var currentOpenProfileIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    var parameters = [String:Any]()
    let disposeBag = DisposeBag()
    var isDefaultAttencdanceChanged:Bool = true
    var numberOfLectures = Variable<Int>(1)

    
    @IBOutlet weak var tableStudentList: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var topConstraintButtonSubmit: NSLayoutConstraint!
    
    
    //TODO:- COMAPRE textfield value of the cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ReachabilityManager.shared.pauseMonitoring()
        if(selectedCollege != nil)
        {
            self.title = selectedCollege.course_name!
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func viewDidBecomeActive(){
        #if DEBUG
            print("viewDidBecomeActive")
        #endif

        ReachabilityManager.shared.pauseMonitoring()
    }
    
    func getEnrolledStudentsList(){
        self.arrayStudentsDetails = self.selectedCollege.student_list!
        if (Int((self.arrayStudentsDetails.first?.roll_number)!)) != nil{
            self.arrayStudentsDetails.sort(by: {Int($0.roll_number!)! < Int($1.roll_number!)!})
        }
        else{
//            self.arrayStudentsDetails.sort(by: {$0.studentFullName < $1.studentFullName})
            self.arrayStudentsDetails.sort( by: {$0.roll_number!.localizedStandardCompare($1.roll_number!) == .orderedAscending})

        }
        if(self.arrayStudentsDetails.count > 0){
            self.setUpTableView()
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
        
        //Add students name
        if(self.isDefaultAttencdanceChanged){
            OfflineAttendanceManager.sharedAttendanceManager.arrayStudents.value.removeAll()
            self.isDefaultAttencdanceChanged = false
            for student in arrayStudentsDetails{
                let studentAttendance:MarkStudentAttendance = MarkStudentAttendance(offlineStudentDetail: student, self.defaultAttendanceForAllStudents)
                let studentDetailDataSource = AttendanceDatasource(celType: .studentProfile, attachedObject: studentAttendance)
                studentDetailDataSource.isSelected = false
                OfflineAttendanceManager.sharedAttendanceManager.arrayStudents.value.append(studentAttendance)
                
                arrayDataSource.append(studentDetailDataSource)
                
            }
        }else{
            for student in OfflineAttendanceManager.sharedAttendanceManager.arrayStudents.value{
                let studentAttendance:MarkStudentAttendance = MarkStudentAttendance(offlineStudentDetail:student.offlineStudent!, student.isPrsent!)
                let studentDetailDataSource = AttendanceDatasource(celType: .studentProfile, attachedObject: studentAttendance)
                studentDetailDataSource.isSelected = false
//                                AttendanceManager.sharedAttendanceManager.arrayStudents.value.append(studentAttendance)
                arrayDataSource.append(studentDetailDataSource)
            }
        }
        self.addCalenderValues()
        self.tableStudentList.reloadData()
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
            if(self.toTimePicker != nil && self.fromTimePicker != nil && self.datePicker != nil){
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
            let presentStudents = OfflineAttendanceManager.sharedAttendanceManager.arrayStudents.value.filter{$0.isPrsent == true}
            viewConfirmAttendance.labelStudentCount.text = "\(presentStudents.count)/\(OfflineAttendanceManager.sharedAttendanceManager.arrayStudents.value.count)"
            viewConfirmAttendance.showView(inView: UIApplication.shared.keyWindow!)
        }
    }
}

//MARK:- table view Delegate
extension OfflineStudentListViewController: UITableViewDelegate, UITableViewDataSource{
    
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
            let presentStudents = OfflineAttendanceManager.sharedAttendanceManager.arrayStudents.value.filter{$0.isPrsent == true}
            cell.labelAttendanceCount.text = "\(presentStudents.count)"
            cell.labelPresent.text = presentStudents.count <= 1 ? "PRESENT":"PRESENTS"
            
            cell.selectionStyle = .none
            
            return cell
            
        case .studentProfile:
            
            let cell : AttendanceStudentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.AttendanceStudentListTableViewCellId, for: indexPath) as! AttendanceStudentListTableViewCell
            let object:MarkStudentAttendance = cellDataSource.attachedObject! as! MarkStudentAttendance
            cell.labelName.text = object.offlineStudent?.studentFullName
            cell.labelRollNumber.text = "\(object.offlineStudent?.roll_number! ?? "NA")"
            cell.labelAttendanceCount.text = "NA"
            cell.labelAttendancePercent.text = "NA"
            cell.labelLastLectureAttendance.text = "NIL"
            cell.clipsToBounds = true
//            cell.imageViewProfile.imageFromServerURL(urlString: (object.student?.imageUrl!)!, defaultImage: Constants.Images.defaultMale)
            
            //TODO:  -3 is for previous sections (calender, default selection, attendance count ) <- IMPORTANT
            
            cell.buttonAttendance.isSelected = OfflineAttendanceManager.sharedAttendanceManager.arrayStudents.value[indexPath.section-3].isPrsent
            cell.buttonAttendance.addTarget(self, action: #selector(StudentsListViewController.markAttendance), for: .touchUpInside)
            cell.buttonAttendance.indexPath = indexPath
            cell.setUpCell()
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
    @objc func markAttendance(_ sender:ButtonWithIndexPath){
        if(sender.isSelected){ //-3 is for previous sections (calender, default selection, attendance count )
            OfflineAttendanceManager.sharedAttendanceManager.arrayStudents.value[sender.indexPath.section - 3].isPrsent = false
            sender.setTitle("Absent", for: .normal)
            sender.backgroundColor = UIColor.rgbColor(126, 132, 155)
            sender.setTitleColor(UIColor.white, for: .normal)
            
        }
        else{
            OfflineAttendanceManager.sharedAttendanceManager.arrayStudents.value[sender.indexPath.section - 3].isPrsent = true
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

extension OfflineStudentListViewController: DefaultAttendanceSelectionDelegate{
    func selectDefaultAttendance(_ attendance: Bool) {
        self.defaultAttendanceForAllStudents = attendance
        self.isDefaultAttencdanceChanged = true
        self.makeDataSource()
    }
}

//MARK:- Calender delegate methods

extension OfflineStudentListViewController:AttendanceCalenderTableViewCellDelegate{
    func numberOfLecturesSelected(lectures: Int) {
        self.numberOfLectures.value = lectures
        self.makeDataSource()
    }
    
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

extension OfflineStudentListViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 210 {
            self.calenderFloatingView.alpha = (scrollView.contentOffset.y/260)
            //        } else if scrollView.contentOffset.y < 320  {
        }else{
            self.calenderFloatingView.alpha = ((scrollView.contentOffset.y - 210)/260)
        }
    }
}

extension OfflineStudentListViewController:ViewConfirmAttendanceDelegate{
    
    
    func confirmAttendance() {
        self.parameters = [
            "college_code":"\(UserManager.sharedUserManager.offlineAppuserCollegeDetails.college_code!)",
            "class_id":"\(self.selectedCollege.class_id!)",
            "course_id":"\(self.selectedCollege.course_id!)",
            "subject_id":"\(self.selectedCollege.subject_id!)",
            "topics_covered":"1",
            "no_of_lecture":"\(self.numberOfLectures.value)",
            "lecture_date":"\(datePicker.postJsonDateString)",
            "from_time":"\(fromTimePicker.postJsonTimeString)",
            "to_time":"\(toTimePicker.postJsonTimeString)",
            "attendance_list":"\(OfflineAttendanceManager.sharedAttendanceManager.offlineAttendanceList)"
        ]
         self.performSegue(withIdentifier: Constants.segues.toOfflineMarkPortion, sender: self)
        /*
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.submitAttendance
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
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
         */

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constants.segues.toOfflineMarkPortion){
            let destinationVC:OfflineMarkCompletedPortionViewController = segue.destination as! OfflineMarkCompletedPortionViewController
            destinationVC.selectedCollege = self.selectedCollege
            destinationVC.attendanceParameters = self.parameters
            destinationVC.arrayDataSource = self.selectedCollege.unit_syllabus_array!
        }
        //        TODO: pass parameters here
    }
}
