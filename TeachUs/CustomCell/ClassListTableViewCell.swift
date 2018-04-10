//
//  ClassListTableViewCell.swift
//  TeachUs
//
//  Created by ios on 4/10/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class ClassListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelClassName: UILabel!
    @IBOutlet weak var labelParticipantCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
