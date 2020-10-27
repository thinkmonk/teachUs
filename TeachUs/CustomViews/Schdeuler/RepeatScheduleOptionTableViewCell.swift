//
//  RepeatScheduleOptionTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 28/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

protocol RepeatScheduleDelegate:class {
    func actionDay()
    func actionWeek()
}

class RepeatScheduleOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonWeekly: UIButton!
    @IBOutlet weak var buttonOfDay: UIButton!
    weak var delegate : RepeatScheduleDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonWeekly.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: UIColor.red.cgColor, borderWidth: 2)
        buttonOfDay.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: UIColor.red.cgColor, borderWidth: 2)

    }

    @IBAction func actionRepeatDay(_ sender: Any) {
        self.delegate?.actionDay()
    }
    
    @IBAction func actionRepeatWeekly(_ sender: Any) {
        self.delegate?.actionWeek()
    }
}
