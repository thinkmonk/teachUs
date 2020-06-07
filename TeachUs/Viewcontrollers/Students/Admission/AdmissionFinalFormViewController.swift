//
//  AdmissionFinalFormViewController.swift
//  TeachUs
//
//  Created by iOS on 07/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class AdmissionFinalFormViewController: BaseViewController {

    @IBOutlet weak var imageViewTick: UIImageView!
    @IBOutlet weak var labelSuccessMessage: UILabel!
    @IBOutlet weak var labelDocumetnName: UILabel!
    @IBOutlet weak var buttonDownloadDocument: UIButton!
    @IBOutlet weak var stackViewBg:UIStackView!
    @IBOutlet weak var buttonSendEmail: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFormData()
        buttonDownloadDocument.themeRedButton()
        buttonSendEmail.themeRedButton()
        self.stackViewBg.isHidden = true
        self.addDefaultBackGroundImage()
    }
    func getFormData(){
        self.stackViewBg.isHidden = false
        AdmissionBaseManager.shared.getAdmissionPDFDetails(completion: { [weak self] (admissionOBj) in
            self?.setUpUIData(obj: admissionOBj)
        }) { (message) in
            self.showAlertWithTitle("Failed", alertMessage: message)
        }
        
    }
    
    func setUpUIData(obj:AdmissionPdfDetails){
        if let pdfstring = obj.pdfUrl, let pdfUrl = URL(string: pdfstring) {
            self.labelDocumetnName.text = pdfUrl.lastPathComponent
        }
        self.labelSuccessMessage.text = "You've successfully submitted the application form"
    }
    
    @IBAction func actionDownloadDocument(_ sender: Any) {
        
    }
    
    @IBAction func actionEmailForm(_ sender: Any) {
    }
}
