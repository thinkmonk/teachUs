//
//  TeacherProfileTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/24/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class TeacherProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelteacherName: UILabel!
    @IBOutlet weak var labelTeacherSubject: UILabel!
    @IBOutlet weak var buttonHeart: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
