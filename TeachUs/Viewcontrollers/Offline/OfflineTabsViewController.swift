//
//  OfflineTabsViewController.swift
//  TeachUs
//
//  Created by ios on 7/15/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class OfflineTabsViewController: ButtonBarPagerTabStripViewController {
    var controllersArray : [UIViewController] = []
    var parentNavigationController : UINavigationController?
    let unselectedColor = UIColor(red: 152.0/255.0, green: 132.0/255.0, blue: 212.0/255.0, alpha: 1.0)

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        super.viewDidLoad()
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = self?.unselectedColor
            newCell?.label.textColor = .white
        }
        self.view.bringSubview(toFront: self.view)

    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        controllersArray.removeAll()
        let professorAttendanceVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.OfflineClassProfessorAttendance) as! OfflineClassAttendanceViewController
        professorAttendanceVC.title = "Attendance"
        professorAttendanceVC.parentNavigationController = self.parentNavigationController
        controllersArray.append(professorAttendanceVC)

        return controllersArray
    }

}
