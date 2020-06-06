//
//  AdmissionDocumentsManager.swift
//  TeachUs
//
//  Created by iOS on 06/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class AdmissionDocumentsManager{
    static let shared = AdmissionDocumentsManager()
    var docuemtnsData:AdmissionDocuments!
    var dataSource = [AdmissionDocumentsRowDatasource]()
    
    
    func makeDataSource(){
        dataSource.removeAll()
        
        let headerDs = AdmissionDocumentsRowDatasource(detailsCell: .dcoumentsTitle, detailsObject: "", dataSource: nil)
        self.dataSource.append(headerDs)
        
        let photoDs = AdmissionDocumentsRowDatasource(detailsCell: .photo, detailsObject: self.docuemtnsData.personalInformation?.photo, dataSource: nil)
        self.dataSource.append(photoDs)
        
        let signatureDs = AdmissionDocumentsRowDatasource(detailsCell: .signatue, detailsObject: self.docuemtnsData.personalInformation?.sign, dataSource: nil)
        self.dataSource.append(signatureDs)
        
    }

}
