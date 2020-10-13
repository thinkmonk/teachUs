//
//  HomeViewController.swift
//  TeachUs
//
//  Created by ios on 10/24/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeViewController: BaseViewController{
    
    var pageMenu : CAPSPageMenu?
    var controllersArray : [UIViewController] = []
    var notificaitonLabel:UILabel!
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    override func viewDidLoad() {
        
        self.addGradientToNavBarWithMenu()
        super.viewDidLoad()

        let buttonHamburger = UIBarButtonItem(image: UIImage(named: Constants.Images.hamburger), style: .plain, target: self, action: #selector(HomeViewController.hamburgerAction))
        self.navigationItem.leftBarButtonItem  = buttonHamburger

//        self.makeDataSource()
//        setUpPageMenu()
        
        self.addNotificaitonLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showHideAdmissionButton), name: .showHideAdmissionButton, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(UserManager.sharedUserManager.userFullName) "
        
        self.addColorToNavBarText(color: UIColor.white)
//        self.addChildViewController(pageMenu!)
//        self.view.addSubview(pageMenu!.view)
//        pageMenu?.didMove(toParentViewController: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBellNotificaitonCount), name: .notificationBellCountUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bellNotificationAction), name: .performNotificationNavigation, object: nil)
        let notificationReceived = UserDefaults.standard.bool(forKey: Constants.UserDefaults.notifiocationReceived)
        if notificationReceived{
            self.bellNotificationAction()
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.notifiocationReceived)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func addNotificaitonLabel(){
        // badge label
        if notificaitonLabel == nil{
            notificaitonLabel = UILabel(frame: CGRect(x: 10, y: -10, width: 20, height: 20))
            notificaitonLabel.layer.borderColor = UIColor.clear.cgColor
            notificaitonLabel.layer.borderWidth = 2
            notificaitonLabel.layer.cornerRadius = notificaitonLabel.bounds.size.height / 2
            notificaitonLabel.textAlignment = .center
            notificaitonLabel.layer.masksToBounds = true
            notificaitonLabel.font = UIFont.systemFont(ofSize: 10)
            notificaitonLabel.textColor = .white
            notificaitonLabel.backgroundColor = .red
            if let collegeDetails = UserManager.sharedUserManager.appUserCollegeDetails, let count = Int(collegeDetails.notificationCount ?? "0"){
                notificaitonLabel.text = count > 100 ? "99+" : "\(count)"
            }
            // button
            
            if UserManager.sharedUserManager.user != .exam{
                let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20 ))
                rightButton.setBackgroundImage(UIImage(named: "bellNotification"), for: .normal)
                rightButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                rightButton.addTarget(self, action: #selector(bellNotificationAction), for: .touchUpInside)
                rightButton.addSubview(notificaitonLabel)
                
                // Bar button item
                let bellButtomItem = UIBarButtonItem(customView: rightButton)
                navigationItem.rightBarButtonItems  = [bellButtomItem]
            }
        }

        
        //button is present
        if let buttonPresentFlag = self.navigationItem.rightBarButtonItems?.contains(where: {$0.tag == Constants.NumberConstants.tagAdmissionButton}),
            buttonPresentFlag
        {//if this condition is moved up then it will add the button twice.
            if !UserManager.sharedUserManager.shouldShowAdmissionButton,
                let newItems = self.navigationItem.rightBarButtonItems?.filter({$0.tag != Constants.NumberConstants.tagAdmissionButton}),
                newItems.count > 0
            {
                self.navigationItem.rightBarButtonItems = newItems
            }
        }else{
            if UserManager.sharedUserManager.user == .student && UserManager.sharedUserManager.shouldShowAdmissionButton, !(self.navigationItem.rightBarButtonItems?.contains(where: {$0.tag == Constants.NumberConstants.tagAdmissionButton}) ?? true)
            {
                let admissionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20 ))
                admissionButton.setTitle("Admission", for: .normal)
                admissionButton.layer.borderWidth = 1.0
                admissionButton.layer.borderColor = UIColor.white.cgColor
                admissionButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                admissionButton.addTarget(self, action: #selector(admissionFormAction), for: .touchUpInside)
                admissionButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
                admissionButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
                admissionButton.tag = Constants.NumberConstants.tagAdmissionButton
                navigationItem.titleView?.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                let addmissionBarButton = UIBarButtonItem(customView: admissionButton)
                addmissionBarButton.tag = Constants.NumberConstants.tagAdmissionButton
                navigationItem.rightBarButtonItems?.append(addmissionBarButton)
            }
        }
        

        

    }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpPageMenu(){
        let parameters: [CAPSPageMenuOption] = [
        .scrollMenuBackgroundColor(UIColor.clear),
        .viewBackgroundColor(UIColor.clear),
        .selectionIndicatorColor(UIColor.clear),
        .unselectedMenuItemLabelColor(UIColor(red: 152.0/255.0, green: 132.0/255.0, blue: 212.0/255.0, alpha: 1.0)),
        .menuItemFont(UIFont(name: "HelveticaNeue", size: 15.0)!),
        .menuHeight(44.0),
        .menuMargin(20.0),
        .selectionIndicatorHeight(0.0),
        .menuItemWidthBasedOnTitleTextWidth(true),
        .selectedMenuItemLabelColor(UIColor.white)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        let pageMenuFrame = CGRect(x: 0.0, y: 60.0, width: self.view.width(), height: self.view.height()-60.0)
        pageMenu = CAPSPageMenu(viewControllers: controllersArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        
        
        
    }
    
    @objc func bellNotificationAction(){
        self.performSegue(withIdentifier: Constants.segues.toBellNotificationList, sender: self)
    }
    
    @objc func admissionFormAction(){
        self.performSegue(withIdentifier: Constants.segues.toAdmissionForm, sender: self)
    }

    @objc func hamburgerAction() {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {
        }
    }
    
    @objc func showHideAdmissionButton(){
        self.addNotificaitonLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toHomeTabVC{
            let destinationVC:HomeTabsViewController = segue.destination as! HomeTabsViewController
            destinationVC.parentNavigationController = self.navigationController
        }
    }

}
extension HomeViewController:LeftMenuDeleagte{
    func editProfileClicked() {
        self.performSegue(withIdentifier: Constants.segues.toEditProfile, sender: self)
    }
    
    func menuItemSelected(item:Int){
//        pageMenu?.moveToPage(item)
        for childViewController in childViewControllers {
            guard let child = childViewController as? PagerTabStripViewController else {
                continue
            }
            child.reloadPagerTabStripView()
            child.moveToViewController(at: item)
            break
        }
        self.updateBellNotificaitonCount()
    }
    
    @objc func updateBellNotificaitonCount(){
        if let label = self.notificaitonLabel{
            if let collegeDetails = UserManager.sharedUserManager.appUserCollegeDetails,
                let count = Int(collegeDetails.notificationCount ?? "0"){
                label.text = count > 100 ? "99+" : "\(count)"
            }
        }
    }
}
