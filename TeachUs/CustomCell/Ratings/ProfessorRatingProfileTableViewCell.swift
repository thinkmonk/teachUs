//
//  ProfessorRatingProfileTableViewCell.swift
//  TeachUs
//
//  Created by ios on 4/21/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class ProfessorRatingProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelSubjectName: UILabel!
    @IBOutlet weak var imageViewProfessor: UIImageView!
    @IBOutlet weak var labelProfessorName: UILabel!
    @IBOutlet weak var labelPopularity: UILabel!
    @IBOutlet weak var labelRatings: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageViewProfessor.makeViewCircular()
        self.makeTableCellEdgesRounded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
