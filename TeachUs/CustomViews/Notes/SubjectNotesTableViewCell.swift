//
//  SubjectNotesTableViewCell.swift
//  TeachUs
//
//  Created by ios on 5/28/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class SubjectNotesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellWrapper: UIView!
    @IBOutlet weak var labelCourseName: UILabel!
    @IBOutlet weak var labelSubjectName: UILabel!
    @IBOutlet weak var labelNotesCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(notesOBject:SubjectList){
        self.labelCourseName.text = notesOBject.subjectListClass ?? ""
        self.labelSubjectName.text = notesOBject.subjectName ?? ""
        self.labelNotesCount.text = "\(notesOBject.totalNotes ?? 0)"
    }
    
}
