//
//  CustomSyllabusTopicTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 12/08/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
import RxSwift

class CustomSyllabusTopicTableViewCell: UITableViewCell {
    @IBOutlet weak var labelOtherHeader: UILabel!
    @IBOutlet weak var textFieldTopicInput: UITextField!
    
    var myCellDisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        myCellDisposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
