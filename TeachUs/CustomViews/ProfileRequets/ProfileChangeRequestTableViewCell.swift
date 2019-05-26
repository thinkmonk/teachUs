//
//  ProfileChangeRequestTableViewCell.swift
//  TeachUs
//
//  Created by ios on 5/26/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class ProfileChangeRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var labelUserTyppe: UILabel!
    @IBOutlet weak var labelChangeRequestType: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.makeEdgesRounded()
    }
    
    func setUpCell(data:RequestData){
        self.labelUserTyppe.text = data.userType ?? ""
        self.labelChangeRequestType.text = data.requestType ?? ""
        self.labelUserName.text = data.existingData ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
