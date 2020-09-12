//
//  AddNewScheduleTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 13/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

protocol AddNewScheduleDelegate:class {
    func addNewSchdule()
}

class AddNewScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonAdd: UIButton!
    
    weak var delegate:AddNewScheduleDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionAddNewSchedule(_ sender: Any) {
        self.delegate?.addNewSchdule()
    }
    
}
