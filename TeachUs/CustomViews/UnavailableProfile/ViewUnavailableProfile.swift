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
    @IBOutlet weak var labelUnavailableUserBody: UILabel!
    @IBOutlet weak var buttonWhatsapp:UIButton!
    @IBOutlet weak var buttonEmail:UIButton!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewUnavailableProfile", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let body = UserManager.sharedUserManager.unauthorisedUser.body, let email = UserManager.sharedUserManager.unauthorisedUser.email, let contact = UserManager.sharedUserManager.unauthorisedUser.contact{
            self.labelUnavailableUserBody.text = body
            buttonEmail.titleLabel?.lineBreakMode = .byWordWrapping
            buttonEmail.titleLabel?.textAlignment = .center
            buttonEmail.setTitle("Email id: \(email)",for: .normal)
            buttonWhatsapp.setTitle("WhatsApp on: \(contact)", for: .normal)
        }
    }
    @IBAction func closeView(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func openEmail(_ sender: Any) {
        //Email id: info@teachuseducation.com
        if let email = UserManager.sharedUserManager.unauthorisedUser.email {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject("\(getErrorHeaderText())")
            mail.setMessageBody("\(getUserErrorText())", isHTML: true)
            if let parentVC = parentViewController{
                parentVC.present(mail, animated: true, completion: nil)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func makePhoneCall(_ sender: Any) {
        //Call on: +91 9892223453
        print("\(getErrorHeaderText()+getUserErrorText())")
        if let busPhone = UserManager.sharedUserManager.unauthorisedUser.contact?.replacingOccurrences(of: " ", with: "")
{
            if let url = URL(string: "http://api.whatsapp.com/send?phone=\(busPhone)&text=\(getErrorHeaderText()+getUserErrorText())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }else{
                print("unable to open URL")
            }
        }
    }
    
    private func getErrorHeaderText() -> String{
               switch UserManager.sharedUserManager.user{
        case .student:
            return "Facing Login Issue-Student!"
            
        case .professor:
                return "Facing Login Issue-Lecturer!"
            
        case .college:
            return "Facing Login Issue-College!"
            
        case .parents:
            return "Facing Login Issue-Parent!"

        case .none:
            return ""
        }

    }
    
    
    private func getUserErrorText() -> String{
        switch UserManager.sharedUserManager.user{
        case .student:
            return "\n\r\nHello!\r\n\r\nKindly provide following details to resolve your issue.\r\n\r\nCollege Name :- \r\n\r\nYour Name :- \r\n\r\nContact Number :- \r\n\r\nEmail Address :- \r\n\r\nCourse :- \r\n\r\nYear :- \r\n\r\nSemester :- \r\n\r\nRoll No :-"
            
        case .professor:
                return "\n\r\nHello!\r\n\r\nKindly provide following details to resolve your issue.\r\n\r\nCollege Name :- \r\n\r\nYour Name :- \r\n\r\nContact Number :- \r\n\r\nEmail Address :-"
            
        case .college:
            return "\n\r\nHello!\r\n\r\nKindly provide following details to resolve your issue.\r\n\r\nCollege Name :- \r\n\r\nYour Name :- \r\n\r\nContact Number :- \r\n\r\nEmail Address :-"
            
        case .parents:
            return "\n\r\nHello!\r\n\r\nKindly provide following details to resolve your issue.\r\n\r\nCollege Name :- \r\n\r\nYour Name :- \r\n\r\nContact Number :- \r\n\r\nEmail Address :-"

        case .none:
            return ""
        }
    }
}
