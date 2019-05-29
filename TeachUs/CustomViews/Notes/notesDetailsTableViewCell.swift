//
//  notesDetailsTableViewCell.swift
//  TeachUs
//
//  Created by ios on 5/29/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class notesDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCellWrapper: UIView!
    @IBOutlet weak var labelNotesTitle: UILabel!
    @IBOutlet weak var buttonDeleteNotes: ButtonWithIndexPath!
    @IBOutlet weak var buttonDownloadNotes: ButtonWithIndexPath!
    var notesObject:NotesList!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.viewCellWrapper.makeTableCellEdgesRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpNotes(notesData:NotesList){
        self.notesObject = notesData
        self.labelNotesTitle.text = notesData.title
        if let fileUrl = notesData.filePath{
            let imageURL = "\(fileUrl)"
            if let _ = GlobalFunction.checkIfFileExisits(fileUrl: imageURL, name:notesData.generatedFileName ?? ""){
                self.buttonDownloadNotes.setTitle("View", for: .normal)
            }
            else{
                self.buttonDownloadNotes.setTitle("Download", for: .normal)
            }
        }

    }
    
}
