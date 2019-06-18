//
//  ViewUnavailableProfile.swift
//  TeachUs
//
//  Created by ios on 6/15/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ViewUnavailableProfile:UIView, MFMailComposeViewControllerDelegate{
    
    var parentViewController:UIViewController?
    
    @IBOutlet weak var viewBg: UIView!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewUnavailableProfile", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
    }
    @IBAction func closeView(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func openEmail(_ sender: Any) {
        //Email id: info@teachuseducation.com
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["info@teachuseducation.com"])
        mail.setSubject("Profile Not available")
        mail.setMessageBody("<p>Send us your issue!</p>", isHTML: true)
        if let parentVC = parentViewController{
            parentVC.present(mail, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func makePhoneCall(_ sender: Any) {
        //Call on: +91 9892222453
        let busPhone = "+919892222453"
        if let url = URL(string: "tel://\(busPhone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
