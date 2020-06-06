//
//  AdmissionDocumentPicketTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 06/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol DocumentPickerDelegate:class {
    func uploadImage(sender:ButtonWithIndexPath)
    func deleteImage(sender:ButtonWithIndexPath)
}

class AdmissionDocumentPicketTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonUploadImage: ButtonWithIndexPath!
    @IBOutlet weak var buttondeleteData: ButtonWithIndexPath!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var imageViewData: UIImageView!
    weak var delegate : DocumentPickerDelegate!
    var formId:Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(dsObj:AdmissionDocumentsRowDatasource){
        
        self.labelTitle.text = dsObj.cellType.rawValue
        self.labelData.text = dsObj.cellType.documentType
        self.buttonUploadImage.setTitle("Upload Data", for: .normal)
        if let imageObj = dsObj.attachedObject as? Image{
            self.buttonUploadImage.isHidden = true
            self.imageViewData.isHidden = false
            self.imageViewData.image = imageObj
        }else if let imageUrl = dsObj.attachedObject as? URL{//pre assuming it will  not fail as doc cannot be  dowloaded by alamofire method
            self.buttonUploadImage.isHidden = true
            self.imageViewData.isHidden = false
            self.setImage(urlString: imageUrl.absoluteString)
        }else if let urlString = dsObj.attachedObject as? String{ //first time when we load pre-saved data if available
            self.buttonUploadImage.isHidden = true
            self.setImage(urlString: urlString)
        }
        else{
            self.buttonUploadImage.isHidden = false
            self.imageViewData.isHidden = true
        }
    }
    
    private func setImage(urlString:String){
        Alamofire.request(urlString).responseImage { response in
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.imageViewData.isHidden = false
                self.imageViewData.image = image
            }else{//user has uploaded document
                self.imageViewData.isHidden = true
                if let url = URL(string: urlString){
                    self.buttonUploadImage.isHidden = false
                    self.buttonUploadImage.setTitle("\(url.lastPathComponent) selected.", for: .normal)
                }
                
            }
        }
    }
    
    @IBAction func actionUploadImage(_ sender: Any) {
        self.delegate.uploadImage(sender: self.buttonUploadImage)
    }
    @IBAction func actionDeleteImage(_ sender: Any) {
        self.delegate.deleteImage(sender: self.buttonUploadImage)
    }
}
