//
//  NotificationListTableViewCell.swift
//  TeachUs
//
//  Created by ios on 6/3/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class NotificationListTableViewCell: UITableViewCell {
    @IBOutlet weak var viewCellWrapper: UIView!
    @IBOutlet weak var imageViewNotificationImage: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageViewrightArrow: UIImageView!
    @IBOutlet weak var labelNotificationTitle: UILabel!
    @IBOutlet weak var labelNotificationDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.viewCellWrapper.makeEdgesRounded()
    }
    
    func setUpCell(notificationObj:NotificationList){
        if let subUrl = notificationObj.filePath, let fileName = notificationObj.generatedFileName{
            let imageURl = URLConstants.BaseUrl.baseURLHome + subUrl + "\(fileName)"
            print("Notification image URL = \(imageURl)")
            DispatchQueue.main.async {
                self.imageViewNotificationImage.imageFromServerURL(urlString: imageURl, defaultImage: Constants.Images.leftMenuTopView)
            }
        }
        self.labelDate.text = notificationObj.updatedBy?.getDateFromString()
        self.labelNotificationTitle.text = notificationObj.title ?? ""
        self.labelNotificationDescription.text = notificationObj.notificationDescription ?? ""
    }
    
}
