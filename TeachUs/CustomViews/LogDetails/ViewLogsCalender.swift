//
//  ViewLogsCalender.swift
//  TeachUs
//
//  Created by ios on 5/7/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

protocol ViewLogsCalenderDelegate {
    func getLogs(fromDate:String, toDate:String)
    func dismissCalenderView()
}

class ViewLogsCalender: UIView {

    @IBOutlet weak var buttonCloseView: UIButton!
    @IBOutlet weak var textFieldFromDate: UITextField!
    @IBOutlet weak var textFieldToDate: UITextField!
    @IBOutlet weak var buttonCalendarFromTime: UIButton!
    @IBOutlet weak var buttonCalendarToTime: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    var fromDatePicker: ViewDatePicker!
    var fromDate:String = ""
    var toDatePicker: ViewDatePicker!
    var toDate:String = ""
    var delegate :ViewLogsCalenderDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonSubmit.roundedRedButton()
        self.textFieldFromDate.addBottomBorder()
        self.textFieldToDate.addBottomBorder()
        self.initFromDatePicker()
        self.initToDatePicker()
    }
    
    func initFromDatePicker(){
        if(fromDatePicker == nil){
            fromDatePicker = ViewDatePicker.instanceFromNib() as! ViewDatePicker
            fromDatePicker.setUpPicker(type: .date)
            fromDatePicker.buttonOk.addTarget(self, action: #selector(ViewLogsCalender.dismissFromDatePicker), for: .touchUpInside)
            
            fromDatePicker.picker.minimumDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
            fromDatePicker.picker.maximumDate = NSCalendar.current.date(byAdding: .month, value: 0, to: Date())
        }
    }
    
    func initToDatePicker(){
        if(toDatePicker == nil){
            toDatePicker = ViewDatePicker.instanceFromNib() as! ViewDatePicker
            toDatePicker.setUpPicker(type: .date)
            toDatePicker.buttonOk.addTarget(self, action: #selector(ViewLogsCalender.dismissToDatePicker), for: .touchUpInside)
            toDatePicker.picker.minimumDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
            toDatePicker.picker.maximumDate = NSCalendar.current.date(byAdding: .month, value: 0, to: Date())
        }
    }

    
    @objc func dismissFromDatePicker(){
        if(fromDatePicker != nil){
            self.fromDate = self.fromDatePicker.postJsonDateString
            self.textFieldFromDate.text = fromDatePicker.dateString
            fromDatePicker.alpha = 0
            fromDatePicker.removeFromSuperview()
        }
    }
    
    @objc func dismissToDatePicker(){
        if(toDatePicker != nil){
            self.toDate = self.toDatePicker.postJsonDateString
            self.textFieldToDate.text = toDatePicker.dateString
            toDatePicker.alpha = 0
            toDatePicker.removeFromSuperview()
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        if delegate != nil{
            self.delegate.dismissCalenderView()
        }
    }
    
    func verifyDate() -> Bool{
        if(self.fromDate == ""  || self.toDate == ""){
            showAlterWithTitle(nil, alertMessage: "Date Range not selected!")
        }else if(self.fromDate < self.toDate){
            return true
        }else{
            showAlterWithTitle("Wrong Date Range", alertMessage: "From date should be lesser than to date!")
        }
        return false
    }
    
    @IBAction func submitDates(_ sender: Any) {
        
        if delegate != nil && self.verifyDate(){
            self.delegate.getLogs(fromDate: self.fromDate, toDate: self.toDate)
        }
    }
    
    @IBAction func showFromDatePickerView(_ sender: Any) {
        fromDatePicker.showView(inView: self)
    }
    @IBAction func toFromDatePickerView(_ sender: Any) {
        toDatePicker.showView(inView: self)
    }

    @IBAction func fromTextFieldEdited(_ sender: Any) {
        fromDatePicker.showView(inView: self)
    }
    @IBAction func toTextFieldEdited(_ sender: Any) {
        toDatePicker.showView(inView: self)
    }
    
    func showAlterWithTitle(_ title:String?, alertMessage:String){
        let alertTitle = title != nil ? title : nil
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

}
