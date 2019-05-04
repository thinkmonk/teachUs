//
//  LOgsDetailTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

protocol LogsDetailCellDelegate{
    func actionDidEditAttendance(_ indexpath:IndexPath)
}

class LogsDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var viewNumberOfLectures: UIView!
    @IBOutlet weak var labelNumberOfLecs: UILabel!
    
    @IBOutlet weak var viewLecTime: UIView!
    @IBOutlet weak var labelLectureTime: UILabel!
    
    
    @IBOutlet weak var viewAttendance: UIView!
    @IBOutlet weak var labelAttendanceCount: UILabel!
    
    @IBOutlet weak var viewTimeOfSubject: UIView!
    @IBOutlet weak var labelTimeOfSubmission: UILabel!
    @IBOutlet weak var buttonEditAttendance:ButtonWithIndexPath!
    
    
    var delegate:LogsDetailCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.viewHeader.makeTopEdgesRounded(radius: Constants.NumberConstants.cornerRadius)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionEditAttendance(_ sender: Any) {
        if let senderButton = sender as? ButtonWithIndexPath{
            self.delegate.actionDidEditAttendance(senderButton.indexPath)
        }
    }
    
    
}
