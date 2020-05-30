//
//  AdmissionHeaderTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 28/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
protocol AdmissionHeaderTableViewCellDelegate {
    func copyCorrespondenceAddress()
}


class AdmissionHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var viewBg: UIView!
    
    @IBOutlet weak var labelSectionTitle: UILabel!
    @IBOutlet weak var viewCopy: UIStackView!
    @IBOutlet weak var labelCopyAddress: UILabel!
    
    @IBOutlet weak var switchCopy: UISwitch!
    var delegate:AdmissionHeaderTableViewCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionCopyCorrespondenceAddress(_ sender: Any) {
        if switchCopy.isOn{
            self.delegate.copyCorrespondenceAddress()
        }
    }
    
    func setUPcell(dsObject:AdmissionFormDataSource){
        self.labelSectionTitle.text = dsObject.cellType.rawValue
        self.viewCopy.isHidden = dsObject.cellType! != . PermannentAddress
        self.labelCopyAddress.text = "Copy coresspondence address?"
    }
}
