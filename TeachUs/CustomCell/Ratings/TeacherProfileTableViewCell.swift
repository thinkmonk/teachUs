//
//  TeacherProfileTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/24/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

func color(_ rgbColor: Int) -> UIColor{
    return UIColor(
        red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class TeacherProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelteacherName: UILabel!
    @IBOutlet weak var labelTeacherSubject: UILabel!
    @IBOutlet weak var labelHeartDescription: UILabel!
    @IBOutlet weak var buttonHeart: FaveButton!
    @IBOutlet weak var viewCellBg: UIView!
    @IBOutlet weak var labelPopularityValue:UILabel!
    let colors = [
        DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
        DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
        DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
        DotColors(first: color(0xE9A966), second: color(0xF8C852)),
        DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
    ]

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.makeTableCellEdgesRounded()
        self.viewCellBg.addShadow()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelPopularityValue.alpha = 0;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



