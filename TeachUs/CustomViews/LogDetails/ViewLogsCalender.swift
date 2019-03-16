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

class ViewLogsCalender: UIView, UITextFieldDelegate {

    @IBOutlet weak var buttonCloseView: UIButton!
    @IBOutlet weak var buttonCalendarFromTime: UIButton!
    @IBOutlet weak var buttonCalendarToTime: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewCalendarBackground: UIView!
    @IBOutlet weak var labelFromDate: UILabel!
    @IBOutlet weak var labelToDate: UILabel!
    var fromDatePicker: ViewDatePicker!
    var fromDate:Date!
    var fromDateString:String = ""
    var toDatePicker: ViewDatePicker!
    var toDate:Date!
    var toDateStirng:String = ""
    var delegate :ViewLogsCalenderDelegate!
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonSubmit.roundedRedButton()
        self.viewCalendarBackground.makeTableCellEdgesRounded()
        self.initFromDatePicker()
        self.initToDatePicker()
        
        self.toDate = Date()
        self.labelToDate.text  = self.dateFormatter.string(from: self.toDate!)
        self.toDateStirng  = self.dateFormatter.string(from: self.toDate)
        self.fromDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
        self.labelFromDate.text = self.dateFormatter.string(from: self.fromDate!)
        self.fromDateString = self.dateFormatter.string(from: self.fromDate!)
        let tapFromDate = UITapGestureRecognizer(target: self, action: #selector(ViewLogsCalender.tapFromDateFunction))
        self.labelFromDate.isUserInteractionEnabled = true
        self.labelFromDate.addGestureRecognizer(tapFromDate)
        
        let tapToDate = UITapGestureRecognizer(target: self, action: #selector(ViewLogsCalender.tapToDateFunction))
        self.labelToDate.isUserInteractionEnabled = true
        self.labelToDate.addGestureRecognizer(tapToDate)

    }
    
    @objc
    func tapFromDateFunction(sender:UITapGestureRecognizer) {
        fromDatePicker.showView(inView: self)
    }
    
    @objc
    func tapToDateFunction(sender:UITapGestureRecognizer) {
        toDatePicker.showView(inView: self)
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
            self.fromDateString = self.fromDatePicker.postJsonDateString
            self.labelFromDate.text = fromDatePicker.dateString
            fromDatePicker.alpha = 0
            fromDatePicker.removeFromSuperview()
        }
    }
    
    @objc func dismissToDatePicker(){
        if(toDatePicker != nil){
            self.toDateStirng = self.toDatePicker.postJsonDateString
            self.labelToDate.text = toDatePicker.dateString
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
        if(self.fromDateString == ""  || self.toDateStirng == ""){
            showAlterWithTitle(nil, alertMessage: "Date Range not selected!")
        }else if(self.fromDate < self.toDate){
            return true
        }else{
            showAlterWithTitle("Wrong Date Range", alertMessage: "From date should be lesser than to date!")
        }
        return false
    }
    
    //MARK:- Text field delegate

    
    @IBAction func submitDates(_ sender: Any) {
        
        if delegate != nil && self.verifyDate(){
            self.delegate.getLogs(fromDate: self.fromDateString, toDate: self.toDateStirng)
        }
    }
    
    @IBAction func showFromDatePickerView(_ sender: Any) {
        fromDatePicker.showView(inView: self)
    }
    @IBAction func toFromDatePickerView(_ sender: Any) {
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
