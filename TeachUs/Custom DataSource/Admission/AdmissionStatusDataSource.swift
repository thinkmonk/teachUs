//
//  AdmissionStatusDataSource.swift
//  TeachUs
//
//  Created by iOS on 08/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//


/*
 1 - Process not started
  - Only Status message
 2 - Form is incomplete
  - Status message and Proceed button
 3 - Application submitted and it is under review - Status message, Download Form & Email Form
 4 - Application is rejected
  - Only Status message.
 5 - Incomplete application received/Review, re-edit and submit
 - Status message & Proceed
 6 - Application is accepted share fee payment details -  Status message, Bank Details, Transaction No Text Box and Upload receipt button
 7 - Fees paid application is under review
  - Only Status message.
 8 - Incorrect fee payment details received, resend the details (re-show transition ID view)
  - Status message, Bank Details, Transaction No Text Box and Upload receipt button
 9 - Application is confirmed and seat is secured - Only Status message.
 */

import Foundation

enum FormStatus:Int, Codable{
    case processNotStarted       = 0
    case formIsIncomplete        = 1
    case formSubmitted           = 2
    case formRejected            = 3
    case incompleteFormSubmitted = 4
    case formAccepted            = 5
    case feesPaid                = 6
    case incorrectfeeDetials     = 7
    case seatConfirmed           = 8
}
