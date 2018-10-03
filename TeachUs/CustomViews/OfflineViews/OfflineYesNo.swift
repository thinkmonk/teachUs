//
//  OfflineYesNo.swift
//  TeachUs
//
//  Created by ios on 7/12/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class OfflineYesNo: UIView {
    @IBOutlet weak var buttonYes: UIButton!
    
    @IBAction func enableOfflineMode(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mfslidemenuContainer = mainStoryBoard.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as!MFSideMenuContainerViewController
        self.window?.rootViewController = nil
        self.window?.rootViewController = mfslidemenuContainer
        
        let centerNavigationController = mainStoryBoard.instantiateViewController(withIdentifier: "offlineNavigation") as! UINavigationController
        
        let leftMenuController = mainStoryBoard.instantiateViewController(withIdentifier: "OfflineLeftMenuViewController") as! OfflineLeftMenuViewController
        let homeVc:OfflineHomeViewController = centerNavigationController.topViewController as! OfflineHomeViewController
        leftMenuController.delegate = homeVc as LeftMenuDeleagte
        mfslidemenuContainer.leftMenuViewController = leftMenuController
        mfslidemenuContainer.centerViewController  = centerNavigationController
        UserManager.sharedUserManager.isUserInOfflineMode = true
        self.removeFromSuperview()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonYes.roundedRedButton()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "OfflineYesNo", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    func showView(inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width()
        self.frame.origin.y = inView.height()
        self.center.x = inView.centerX()
        inView.addSubview(self)
        //display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }, completion: { (result) in
            print("completion result is \(result)")
        })
    }
}
