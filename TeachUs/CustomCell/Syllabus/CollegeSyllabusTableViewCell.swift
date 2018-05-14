//
//  CollegeSyllabusTableViewCell.swift
//  TeachUs
//
//  Created by ios on 5/13/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class CollegeSyllabusTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSyllabusSubject: UILabel!
    @IBOutlet weak var labelSyllabusPercent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeTableCellEdgesRounded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
