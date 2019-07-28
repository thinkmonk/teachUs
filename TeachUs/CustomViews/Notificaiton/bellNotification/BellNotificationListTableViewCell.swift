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
    @IBOutlet weak var viewReadDot: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.viewReadDot.makeViewCircular()
        self.viewReadDot.backgroundColor = Constants.colors.themePurple
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
