//
//  ProfileDetailsEditTableViewCell.swift
//  TeachUs
//
//  Created by ios on 5/11/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class ProfileDetailsEditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewCellWrapper: UIView!
    @IBOutlet weak var labelKey: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var viewBottomSeperator: UIView!
    @IBOutlet weak var buttonEditDetails: ButtonWithIndexPath!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
