//
//  CustomButtonsTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 30/08/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class CustomButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonReject: UIButton!
    @IBOutlet weak var buttonApprove: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonApprove.roundedRedButton()
        buttonReject.roundedgreyButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
