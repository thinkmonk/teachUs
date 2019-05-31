//
//  CollegeSubjectAndProfessorNotesTableViewCell.swift
//  TeachUs
//
//  Created by ios on 5/31/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class CollegeSubjectAndProfessorNotesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageVIewProfessor: UIImageView!
    @IBOutlet weak var labelSubjectName: UILabel!
    @IBOutlet weak var labelNotesCount: UILabel!
    @IBOutlet weak var labelLecturerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
