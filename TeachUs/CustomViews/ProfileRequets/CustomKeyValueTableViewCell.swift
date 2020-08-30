//
//  CustomKeyValueTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 30/08/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class CustomKeyValueTableViewCell: UITableViewCell {
    @IBOutlet weak var labelCustomKey: UILabel!
    @IBOutlet weak var labelCustomValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
