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
    case processNotStarted       = 1
    case formIsIncomplete        = 2
    case formSubmitted           = 3
    case formRejected            = 4
    case incompleteFormSubmitted = 5
    case formAccepted            = 6
    case feesPaid                = 7
    case incorrectfeeDetials     = 8
    case seatConfirmed           = 9
}
