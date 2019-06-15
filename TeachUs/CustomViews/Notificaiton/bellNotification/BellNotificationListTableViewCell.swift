//
//  BellNotificationListTableViewCell.swift
//  TeachUs
//
//  Created by ios on 6/15/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class BellNotificationListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelNotificaitondate: UILabel!
    @IBOutlet weak var labelNotificationDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
