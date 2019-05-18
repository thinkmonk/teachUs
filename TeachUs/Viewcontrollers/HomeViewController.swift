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

    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)

    override func viewDidLoad() {
        
        self.addGradientToNavBarWithMenu()
        super.viewDidLoad()

        let buttonHamburger = UIBarButtonItem(image: UIImage(named: Constants.Images.hamburger), style: .plain, target: self, action: #selector(HomeViewController.hamburgerAction))
        self.navigationItem.leftBarButtonItem  = buttonHamburger

//        self.makeDataSource()
//        setUpPageMenu()
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(UserManager.sharedUserManager.userFullName)"
        self.addColorToNavBarText(color: UIColor.white)
//        self.addChildViewController(pageMenu!)
//        self.view.addSubview(pageMenu!.view)
//        pageMenu?.didMove(toParentViewController: self)

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

    @objc func hamburgerAction() {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {
        }
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
//        makeDataSource()
    }
    
    

}
