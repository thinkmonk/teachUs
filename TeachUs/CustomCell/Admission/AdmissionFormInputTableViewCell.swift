//
//  AdmissionFormInputTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 25/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class CustomTextField:UITextField{
    var indexpath:IndexPath?
}

class AdmissionFormInputTableViewCell: UITableViewCell {
    @IBOutlet weak var labelFormHeader: UILabel!
    @IBOutlet weak var viewtextfieldBg: UIView!
    @IBOutlet weak var labelrequired: UILabel!
    @IBOutlet weak var textFieldAnswer: CustomTextField!
    @IBOutlet weak var buttonDropdown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewtextfieldBg.layer.borderColor = UIColor.lightGray.cgColor
        self.viewtextfieldBg.layer.borderWidth = 1
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    ///For first form - AdmissionsViewController
    func setUpcell(_ cellObj:AdmissionFormDataSource){
        //disabled if mobileNumber
        self.isUserInteractionEnabled = !(cellObj.cellType == .MobileNumber)
        self.viewtextfieldBg.backgroundColor = cellObj.cellType == .MobileNumber ? .lightGray : .white
        self.labelrequired.isHidden = !(cellObj.isCompulsaey ?? false)
        //Set text from datasource
        if let textValue = cellObj.attachedObject as? String{
            self.textFieldAnswer.text = textValue
        }
        self.textFieldAnswer.placeholder = cellObj.cellType.rawValue
        self.labelFormHeader.text = cellObj.cellType.rawValue
    }
    
    ///For second form - AdmissionSubjectsViewController
    func setUpcell(_ cellObj:AdmissionSubjectDataSource){
        //disabled if mobileNumber
        let disabledCells : [SubjectCellType] = [.level, .course, .academicYear]
        let isDisabledCell = disabledCells.contains(cellObj.cellType)
        self.isUserInteractionEnabled = !isDisabledCell
        self.buttonDropdown.isHidden = isDisabledCell
        self.viewtextfieldBg.backgroundColor = isDisabledCell ? .lightGray : .white
        
        //Set text from datasource
        if let textValue = cellObj.attachedObject as? String{
            self.textFieldAnswer.text = textValue
        }else if let detailsObject = cellObj.attachedObject as? AdmissionFormSubject{
            self.textFieldAnswer.text = detailsObject.subjectName ?? "NA"
            
        }
        self.labelFormHeader.text = cellObj.cellType.value
        self.textFieldAnswer.placeholder = cellObj.placeHolderText ?? cellObj.cellType.placeHolder
        if let form = cellObj.attachedObject as? AdmissionFormSubject{
            self.textFieldAnswer.text  = form.subjectName ?? ""
        }
    }
    
    func setUpCell(_ cellObj: AcademicRowDataSource){
        self.isUserInteractionEnabled = !cellObj.isgreyedOUt
        self.viewtextfieldBg.backgroundColor = cellObj.isgreyedOUt ? .lightGray : .white
        if let attachedDs = cellObj.attachedDs as? [String], attachedDs.count > 0{ //hide dropdown if dropdown is no datasource is present
            self.buttonDropdown.isHidden  = cellObj.isgreyedOUt
        }else{
            self.buttonDropdown.isHidden  = true
        }
        //Set text from datasource
        if let textValue = cellObj.attachedObj as? String{
            self.textFieldAnswer.text = textValue
        }else{
            self.textFieldAnswer.placeholder = cellObj.cellType.rawValue
        }
        self.labelFormHeader.text = cellObj.cellType.rawValue
        self.labelrequired.isHidden = !cellObj.isCumpulsory || cellObj.isgreyedOUt
        self.textFieldAnswer.placeholder = cellObj.cellType.rawValue
    }
    
    func setUpCell(_ cellObj: FamilyCellDataSource){
        if let attachedDs = cellObj.attachedDs as? [String], attachedDs.count > 0{ //hide dropdown if dropdown is no datasource is present
            self.buttonDropdown.isHidden  = false
        }else{
            self.buttonDropdown.isHidden  = true
        }
        if let textValue = cellObj.attachedObj as? String{
            self.textFieldAnswer.text = textValue
        }else if let textValue = cellObj.attachedObj as? Int{
            self.textFieldAnswer.text = "\(textValue)"
        }else{
            self.textFieldAnswer.placeholder = cellObj.cellType.rawValue
            
        }
        self.labelrequired.isHidden = !cellObj.isCumpulsory
        self.labelFormHeader.text = cellObj.cellType.rawValue
        self.textFieldAnswer.placeholder = cellObj.cellType.rawValue
    }

}
