//
//  AdmissionHeaderTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 28/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class AdmissionHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var viewBg: UIView!
    
    @IBOutlet weak var labelSectionTitle: UILabel!
    @IBOutlet weak var viewCopy: UIStackView!
    @IBOutlet weak var labelCopyAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUPcell(dsObject:AdmissionFormDataSource){
        self.labelSectionTitle.text = dsObject.cellType.rawValue
        self.viewCopy.isHidden = dsObject.cellType! != . PermannentAddress
        self.labelCopyAddress.text = "Copy coresspondence address?"
    }
}
