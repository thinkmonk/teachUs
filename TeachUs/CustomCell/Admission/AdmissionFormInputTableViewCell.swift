//
//  AdmissionFormInputTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 25/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class AdmissionFormInputTableViewCell: UITableViewCell {
    @IBOutlet weak var labelFormHeader: UILabel!
    @IBOutlet weak var viewtextfieldBg: UIView!
    @IBOutlet weak var labelrequired: UILabel!
    @IBOutlet weak var textFieldAnswer: UITextField!
    @IBOutlet weak var buttonDropdown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewtextfieldBg.layer.borderColor = UIColor.lightGray.cgColor
        self.viewtextfieldBg.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpcell(_ cellObj:AdmissionFormDataSource){
        self.labelFormHeader.text = cellObj.cellType.rawValue
    }
    
}
