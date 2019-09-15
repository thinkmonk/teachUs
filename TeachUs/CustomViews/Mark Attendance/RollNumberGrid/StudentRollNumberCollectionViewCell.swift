//
//  StudentRollNumberCollectionViewCell.swift
//  TeachUs
//
//  Created by ios on 9/15/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class StudentRollNumberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCelllBg: UIView!
    @IBOutlet weak var labelRollNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.viewCelllBg.layer.borderColor = UIColor.gray.cgColor
        self.viewCelllBg.layer.borderWidth = 1
    }
    
    override var isSelected: Bool{
        didSet{
            self.viewCelllBg.backgroundColor = self.isSelected ? Constants.colors.themePurple : .white
            self.labelRollNumber.textColor = self.isSelected ? .white : .black
        }
    }
    
    func setUpCell(studentObj:MarkStudentAttendance){
        self.labelRollNumber.text = studentObj.student?.studentRollNo ?? "NA"
        self.isSelected = studentObj.isPrsent
    }
    
}
