//
//  SchedularDatePickerViewController.swift
//  TeachUs
//
//  Created by iOS on 11/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

protocol DatePickerDelegate:class {
    func dateSelected(from fromDate:Date, to toDate:Date)
}


class SchedularDatePickerViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldFromDate: UITextField!
    @IBOutlet weak var textFieldToDate: UITextField!
    
    @IBOutlet weak var labelErrorMessage: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    weak var delegate : DatePickerDelegate!
    var toolBar = UIToolbar()
    var dateFormatter = DateFormatter()
    var fromDate : Date? {
        didSet {
            validateDates()
        }
    }
    var toDate : Date? {
        didSet {
            validateDates()
        }
    }
    
    var datepicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldFromDate.inputView = datepicker
        textFieldToDate.inputView   = datepicker
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.setItems([doneButton], animated: true)
        textFieldFromDate.inputAccessoryView   = toolBar
        textFieldToDate.inputAccessoryView     = toolBar
        textFieldFromDate.delegate = self
        textFieldToDate.delegate = self
        labelErrorMessage.isHidden = true
        validateDates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textFieldFromDate.becomeFirstResponder()        
    }
    
    func validateDates() {
        guard let fromDate = fromDate, let toDate = toDate else {
            buttonSubmit.roundedgreyButton()
            buttonSubmit.makeViewCircular()
            return
        }
        
        if fromDate < toDate {
            labelErrorMessage.isHidden = true
            buttonSubmit.roundedBlueButton()
            buttonSubmit.isUserInteractionEnabled = true
        } else {
            labelErrorMessage.isHidden = false
            labelErrorMessage.text = "From date should be less then to date"
            buttonSubmit.roundedgreyButton()
            buttonSubmit.makeViewCircular()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFieldFromDate {
            datepicker.datePickerMode = .date
            if let fromDate = fromDate {
                datepicker.date = fromDate
            }else{
                datepicker.date = Date()
            }
        }
        if textField == textFieldToDate {
            datepicker.datePickerMode = .date
            if let toDate = toDate {
                datepicker.date = toDate
            }else if let fromDate = fromDate {
                datepicker.date = fromDate.addDays(7)
            }else {
                datepicker.date = Date().addDays(7)
            }
        }
    }
    
    @objc func doneButtonTapped() {
        if textFieldFromDate.isFirstResponder {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            textFieldFromDate.text = dateFormatter.string(from: datepicker.date)
            fromDate = datepicker.date
        }
        if textFieldToDate.isFirstResponder {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            textFieldToDate.text = dateFormatter.string(from: datepicker.date)
            toDate = datepicker.date
        }
        self.view.endEditing(true)
    }


    @IBAction func actionClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDatesSelected(_ sender: Any) {
        guard let fromDate = fromDate, let toDate = toDate else {
            return
        }
        
        dismiss(animated: true) {
            self.delegate.dateSelected(from: fromDate, to: toDate)
        }
        
    }
}
