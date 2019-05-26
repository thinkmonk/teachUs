//
//  ViewProfileRequestDetails.swift
//  TeachUs
//
//  Created by ios on 5/26/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

protocol ViewProfileRequestDetailsDelegate {
    func downloadProof()
    func approve()
    func reject()
    func close()
}


class ViewProfileRequestDetails: UIView {

    @IBOutlet weak var labelRequestType: UILabel!
    @IBOutlet weak var labelRequestDetails: UILabel!
    @IBOutlet weak var labelExisitingDetails: UILabel!
    @IBOutlet weak var viewNewDetails: UILabel!
    
    @IBOutlet weak var labelNameOfDoc: UILabel!
    @IBOutlet weak var buttonDownload: UIButton!
    @IBOutlet weak var buttonApproveRequest: UIButton!
    @IBOutlet weak var buttonRejectRequest: UIButton!
    @IBOutlet weak var viewWrapper: UIView!
    
    var delegate:ViewProfileRequestDetailsDelegate!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.viewWrapper.makeEdgesRounded()
        self.buttonRejectRequest.roundedgreyButton()
        self.buttonApproveRequest.roundedRedButton()
        
    }
    
    @IBAction func actionDownloadProof(_ sender: Any) {
        if self.delegate != nil{
            self.delegate.downloadProof()
        }
    }
    
    @IBAction func actionApproveChangeRequest(_ sender: Any) {
        if self.delegate != nil{
            self.delegate.approve()
        }
    }
    @IBAction func actionRejectRequest(_ sender: Any) {
        if self.delegate != nil{
            self.delegate.reject()
        }
    }
    
    @IBAction func closeView(_ sender:Any){
        if self.delegate != nil{
            self.delegate.close()
        }
    }
    
    
    func setUpRequestData(data:RequestData){
        self.labelRequestType.text = data.userType ?? ""
        self.labelRequestDetails.text = data.requestType ?? ""
        self.labelExisitingDetails.text = data.existingData ?? ""
        self.viewNewDetails.text = data.newData ?? ""
        let name = data.filePath?.components(separatedBy: "/")
        self.labelNameOfDoc.text = name?.last ?? ""
        
        if let fileUrl = data.filePath{
            let imageURL = URLConstants.BaseUrl.baseURL + "/\(fileUrl)"
            if let _ = GlobalFunction.checkIfFileExisits(fileUrl: imageURL){
                self.buttonDownload.setTitle("View", for: .normal)
            }else{
                self.buttonDownload.setTitle("Download", for: .normal)
            }
        }else{
            self.buttonDownload.setTitle("Download", for: .normal)

        }
        
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "RequestDetails", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
