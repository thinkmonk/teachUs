//
//  DefaultSelectionTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/11/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

protocol DefaultAttendanceSelectionDelegate {
    func selectDefaultAttendance(_ attendance:Bool)
    func getPreviousLectureAttendance()
    func showGridView()
}

class DefaultSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonShowGridView: UIButton!
    @IBOutlet weak var buttonPresent: UIButton!
    @IBOutlet weak var buttonFetchPreviAttendance: UIButton!
    var delegate:DefaultAttendanceSelectionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonPresent.makeTableCellEdgesRounded()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.buttonPresent.dropShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func performPresentButtonUIChanges() {
        if AttendanceManager.sharedAttendanceManager.defaultAttendanceForAllStudents{
            self.buttonPresent.setTitle("Absent All", for: .normal)
            self.buttonPresent.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)
            
        }else{
            self.buttonPresent.setTitle("Present All", for: .normal)
            self.buttonPresent.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        }
    }
    
    @IBAction func markDefaultAttendance(_ sender: Any) {
        AttendanceManager.sharedAttendanceManager.defaultAttendanceForAllStudents.toggle()
        performPresentButtonUIChanges()
        self.delegate?.selectDefaultAttendance(AttendanceManager.sharedAttendanceManager.defaultAttendanceForAllStudents)
    }
    
    @IBAction func bringLatAttendance(_ sender:Any){
        self.delegate?.getPreviousLectureAttendance()
    }
    
    @IBAction func showGridView(_ sender: Any) {
        self.delegate?.showGridView()
    }
    
}
