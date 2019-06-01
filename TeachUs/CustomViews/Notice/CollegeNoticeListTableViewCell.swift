//
//  CollegeNoticeListTableViewCell.swift
//  TeachUs
//
//  Created by ios on 6/1/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class CollegeNoticeListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelNoticeDate: UILabel!
    @IBOutlet weak var labelNoticeTitle: UILabel!
    @IBOutlet weak var labelNoticeDescription: UILabel!
    @IBOutlet weak var buttonDownload: ButtonWithIndexPath!
    @IBOutlet weak var labelNoticeClassDetails: UILabel!
    @IBOutlet weak var viewWrapper: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpNotice(noticeObject:Notice){
        self.labelNoticeDate.text = "\(noticeObject.createdAt?.getDateFromString() ?? "")"
        self.labelNoticeTitle.text = noticeObject.title ?? ""
        self.labelNoticeDescription.text = noticeObject.noticeDescription ?? ""
        self.labelNoticeClassDetails.text = "Send to \(noticeObject.courses ?? "")"
        if let fileUrl = noticeObject.filePath{
            let imageURL = "\(fileUrl)"
            if let _ = GlobalFunction.checkIfFileExisits(fileUrl: imageURL, name:noticeObject.generatedFileName ?? ""){
                self.buttonDownload.setTitle("View", for: .normal)
            }
            else{
                self.buttonDownload.setTitle("Download", for: .normal)
            }
        }
    }
    
}
