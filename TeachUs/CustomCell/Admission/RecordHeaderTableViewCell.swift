//
//  RecordHeaderTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 02/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class RecordHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var labelrecordNumber: UILabel!
    @IBOutlet weak var buttonDeleteRecord: ButtonWithIndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.buttonDeleteRecord.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
