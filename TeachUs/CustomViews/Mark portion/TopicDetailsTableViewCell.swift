//
//  TopicDetailsTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/18/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class TopicDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var labelChapterNumber: UILabel!
    @IBOutlet weak var labelChapterName: UILabel!
    @IBOutlet weak var labelStatus: UILabel!    
    
    @IBOutlet weak var buttonInProgress: ButtonWithIndexPath!
    @IBOutlet weak var buttonCompleted: ButtonWithIndexPath!
    @IBOutlet weak var viewDisableCell: UIView!
    @IBOutlet weak var viewStatusStack: UIStackView!
    @IBOutlet weak var viewwSeperator: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
