//
//  AddRemoveAdminTableViewCell.swift
//  TeachUs
//
//  Created by ios on 3/10/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class AddRemoveAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCourseName: UILabel!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var buttonRemoveAdmin: ButtonWithIndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(adminDetails:Admin){
        self.labelCourseName.text = ""
        self.labelMobileNumber.text = "\(adminDetails.contact)"
    }
    
}
