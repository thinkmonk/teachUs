//
//  HomeTabsViewController.swift
//  TeachUs
//
//  Created by ios on 3/17/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeTabsViewController: ButtonBarPagerTabStripViewController {
    let unselectedColor = UIColor(red: 152.0/255.0, green: 132.0/255.0, blue: 212.0/255.0, alpha: 1.0)
    var controllersArray : [UIViewController] = []
    var parentNavigationController : UINavigationController?

    override func viewDidLoad() {

        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = false
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        /*
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = self?.unselectedColor
            newCell?.label.textColor = .white
        }
 */
        super.viewDidLoad()

        self.view.bringSubview(toFront: self.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch UserManager.sharedUserManager.user! {
        case .Professor:
            
            controllersArray.removeAll()
            let professorAttendanceVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorAttendance) as! ProfessorAttedanceViewController
            professorAttendanceVC.title = "Attendance"
            professorAttendanceVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(professorAttendanceVC)
            
            let professorSyllabusStatusVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorSyllabusStatus) as! SyllabusStatusListViewController
            professorSyllabusStatusVC.title = "Syllabus Status"
            professorSyllabusStatusVC.parentNavigationController = self.parentNavigationController
            professorSyllabusStatusVC.userType = .Professor
            controllersArray.append(professorSyllabusStatusVC)
            
            let professorLogsListVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorLogs) as! ProfessorLogsListViewController
            professorLogsListVC.title = "Logs"
            professorLogsListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(professorLogsListVC)
            break

            
        case .Student:
            controllersArray.removeAll()
            let attendanceVC: StudentAttedanceViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentAttendace) as! StudentAttedanceViewController
            attendanceVC.title = "Attendance"
            attendanceVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(attendanceVC)
            
            let syllabusStatusVC:SyllabusStatusListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorSyllabusStatus) as! SyllabusStatusListViewController
            syllabusStatusVC.title = "Syllabus Status"
            
            syllabusStatusVC.parentNavigationController = self.parentNavigationController
            syllabusStatusVC.userType = .Student
            //controllersArray.append(syllabusStatusVC)
            
            let professorRating:TeachersRatingViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorRating) as! TeachersRatingViewController
            professorRating.title = "Rating"
            professorRating.parentNavigationController = self.parentNavigationController            
            controllersArray.append(professorRating)
            break
            
        case .College:
            self.controllersArray.removeAll()
            print("College")
            let collegeAttendanceListVC:CollegeAttendanceListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.CollegeAttendanceListViewControllerId) as! CollegeAttendanceListViewController
            collegeAttendanceListVC.title = "Attendance (Reports)"
            collegeAttendanceListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(collegeAttendanceListVC)

            let eventAttendanceListVc:EventAttendanceListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.EventAttendanceListViewControllerId) as! EventAttendanceListViewController
            eventAttendanceListVc.title = "Attendance (Events)"
            eventAttendanceListVc.parentNavigationController = self.parentNavigationController
            controllersArray.append(eventAttendanceListVc)
            
            let addRemoveAdminVC:AddRemoveAdminViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.AddRemoveAdminViewControllerId) as! AddRemoveAdminViewController
            addRemoveAdminVC.title = "Add/Remove Admin"
            addRemoveAdminVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(addRemoveAdminVC)
            
            let collegeRatingListVC:CollegeClassRatingListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.CollegeClassRatingListViewControllerId) as! CollegeClassRatingListViewController
            collegeRatingListVC.title = "Ratings"
            collegeRatingListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(collegeRatingListVC)
            


            let collegeSyllabusStatusVC:CollegeSyllabusStatusViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.CollegeSyllabusStatusViewControllerId) as! CollegeSyllabusStatusViewController
            collegeSyllabusStatusVC.title = "Syllabus"
            collegeSyllabusStatusVC.parentNavigationController = self.parentNavigationController
            
//            controllersArray.append(collegeSyllabusStatusVC)
            
            break
            
            
        }
        
        return controllersArray
        
    }

}
