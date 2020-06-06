//
//  AdmissionDocumentDataSource.swift
//  TeachUs
//
//  Created by iOS on 06/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
enum AdmissionDocumentsRowCellType:String{
    case dcoumentsTitle = "Documents"
    case photo     = "Photo"
    case signatue  = "Signature"
    
    var documentType:String{
        return "JPG, PNG format only"
    }
}


class AdmissionDocumentsRowDatasource{
    var cellType:AdmissionDocumentsRowCellType!
    var attachedObject:Any?
    var dataSourceObject:Any?
    
    init(detailsCell:AdmissionDocumentsRowCellType, detailsObject:Any?, dataSource:Any?) {
        self.cellType = detailsCell
        self.attachedObject = detailsObject
        self.dataSourceObject = dataSource
    }
}

extension AdmissionDocumentsRowDatasource{
    func setValues(value:Any)
    {
        switch self.cellType {
        case .photo:
            self.attachedObject = value
            
        case .signatue:
            self.attachedObject = value
            
        default:
            break
        }
    }
}
