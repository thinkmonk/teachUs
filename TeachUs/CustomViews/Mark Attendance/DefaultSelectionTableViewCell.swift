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
    var isPresent:Bool = false //default value of entire edit attendance flow
    override func awakeFromNib() {
        super.awakeFromNib()
        self.markDefaultAttendance(self.isPresent)
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
    
    @IBAction func markDefaultAttendance(_ sender: Any) {
        isPresent.toggle()
        if isPresent{
            self.buttonPresent.setTitle("Absent All", for: .normal)
            self.buttonPresent.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)
            self.buttonPresent.dropShadow()

        }else{
            self.buttonPresent.setTitle("Present All", for: .normal)
            self.buttonPresent.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
            self.buttonPresent.removeDropShadow()
    
        }
        self.delegate?.selectDefaultAttendance(isPresent)
    }
    
    @IBAction func bringLatAttendance(_ sender:Any){
        self.delegate?.getPreviousLectureAttendance()
    }
    
    @IBAction func showGridView(_ sender: Any) {
        self.delegate?.showGridView()
    }
    
}
