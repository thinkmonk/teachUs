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
}

class DefaultSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonPresent: UIButton!
    @IBOutlet weak var buttonAbsent: UIButton!
    var buttons:[UIButton]!
    var delegate:DefaultAttendanceSelectionDelegate!
    var selectedButton:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        buttons = [buttonPresent,buttonAbsent]
        self.markDefaultAttendance(self.buttonPresent)
        self.buttonPresent.makeTableCellEdgesRounded()
        self.buttonAbsent.makeTableCellEdgesRounded()
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
        let button:UIButton = sender as! UIButton
        
        for btn in buttons{
            if btn == button{
                btn.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
                btn.dropShadow()
            }
            else{
                btn.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)
                btn.removeDropShadow()
            }
        }
        
        if(button != selectedButton){
            selectedButton = button
            if(delegate != nil){
                //100 - present
                //101 - absent
                
                switch button.tag{
                case 100:
                    self.delegate.selectDefaultAttendance(true)
                    break
                case 101:
                    self.delegate.selectDefaultAttendance(false)
                    break
                default:
                    break
                }
            }
            
        }
    }
}
