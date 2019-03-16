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
        self.imageViewBackground.makeEdgesRoundedWith(radius: self.imageViewBackground.height()/2)
        self.imageProfessor.makeEdgesRoundedWith(radius: self.imageProfessor.height()/2)

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUpCellDetails(tempDetails:ProfessorDetails){
        self.labelSubject.text = tempDetails.subjectName
        self.labelName.text = "\(tempDetails.professforFullname)"
        self.imageProfessor.imageFromServerURL(urlString: tempDetails.imageURL, defaultImage: Constants.Images.defaultProfessor)
        self.selectionStyle = .none
        if(tempDetails.isRatingSubmitted == "1"){
            self.imageViewBackground.backgroundColor = .lightGray
            self.labelName.textColor = .lightGray
            self.labelSubject.textColor = .lightGray
            self.isUserInteractionEnabled = false
            self.accessoryType = .none
        }else{
            self.imageViewBackground.backgroundColor = .black
            self.labelName.textColor = .black
            self.labelSubject.textColor = .black
            self.isUserInteractionEnabled = true
            self.accessoryType = .disclosureIndicator
        }
    }
    
    func setUpProfessorLogCellDetails(tempDetails:ProfessorSubject){
        self.labelSubject.text = tempDetails.subjects
        self.labelName.text = "\(tempDetails.professorName ?? "")"
        self.imageProfessor.imageFromServerURL(urlString: tempDetails.profile ?? "", defaultImage: Constants.Images.defaultProfessor)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    }
    
}
