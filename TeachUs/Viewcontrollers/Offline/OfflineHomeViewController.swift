//
//  OfflineHomeViewController.swift
//  TeachUs
//
//  Created by ios on 7/15/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class OfflineHomeViewController: BaseViewController {

    override func viewDidLoad() {
        self.addGradientToNavBarWithMenu()
        super.viewDidLoad()
        let buttonHamburger = UIBarButtonItem(image: UIImage(named: Constants.Images.hamburger), style: .plain, target: self, action: #selector(OfflineHomeViewController.hamburgerAction))
        self.navigationItem.leftBarButtonItem  = buttonHamburger
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(UserManager.sharedUserManager.userFullName)"
        self.addColorToNavBarText(color: UIColor.white)        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc func hamburgerAction() {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toOfflineHomeTabsVC{
            let destinationVC:OfflineTabsViewController = segue.destination as! OfflineTabsViewController
            destinationVC.parentNavigationController = self.navigationController
        }
    }
}
extension OfflineHomeViewController:LeftMenuDeleagte{
    func editProfileClicked() {
        
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
