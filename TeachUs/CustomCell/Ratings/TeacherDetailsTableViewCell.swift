//
//  TeacherDetailsTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/22/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class TeacherDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewBackground: UIView!
    @IBOutlet weak var imageProfessor: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSubject: UILabel!
    
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
