//
//  ViewProfessorMailReport.swift
//  TeachUs
//
//  Created by ios on 3/23/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

protocol ViewProfessorMailReportDelegate {
    func dismissMailReportView()
    func mailReport(fromDate: String, toDate: String)
}

class ViewProfessorMailReport: UIView {

    @IBOutlet weak var buttondismissView: UIButton!
    @IBOutlet weak var labelFromDate: UILabel!
    @IBOutlet weak var labelToDate: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var buttonShowFromDate: UIButton!
    @IBOutlet weak var buttonShowTodate: UIButton!
    @IBOutlet weak var viewFromDateBg: UIView!
    @IBOutlet weak var viewToDateBg: UIView!
    @IBOutlet weak var viewEmailBg: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewGenerateReportBg: UIView!
    var delegate:ViewProfessorMailReportDelegate!
    var fromDatePicker: ViewDatePicker!
    var fromDate:Date!
    var fromDateString:String = ""
    var toDatePicker: ViewDatePicker!
    var toDate:Date!
    var toDateStirng:String = ""
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "YYYY MMMM dd"
        return df
    }
    
    var jsonDateFormater:DateFormatter{
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonSubmit.roundedRedButton()
        self.viewGenerateReportBg.makeTableCellEdgesRounded()
        self.setUpDefaultDates()
        self.initToDatePicker()
        self.initFromDatePicker()
    }
    
    @objc
    func tapFromDateFunction(sender:UITapGestureRecognizer) {
        fromDatePicker.showView(inView: self)
    }
    
    @objc
    func tapToDateFunction(sender:UITapGestureRecognizer) {
        toDatePicker.showView(inView: self)
    }
    
    func setUpDefaultDates(){
        self.toDate = Date()
        self.labelToDate.text  = self.dateFormatter.string(from: self.toDate!)
        self.toDateStirng  = self.jsonDateFormater.string(from: self.toDate)
        self.fromDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
        self.labelFromDate.text = self.dateFormatter.string(from: self.fromDate!)
        self.fromDateString = self.jsonDateFormater.string(from: self.fromDate!)
        let tapFromDate = UITapGestureRecognizer(target: self, action: #selector(ViewLogsCalender.tapFromDateFunction))
        self.labelFromDate.isUserInteractionEnabled = true
        self.labelFromDate.addGestureRecognizer(tapFromDate)
        
        let tapToDate = UITapGestureRecognizer(target: self, action: #selector(ViewLogsCalender.tapToDateFunction))
        self.labelToDate.isUserInteractionEnabled = true
        self.labelToDate.addGestureRecognizer(tapToDate)

    }
    
    func initFromDatePicker(){
        if(fromDatePicker == nil){
            fromDatePicker = (ViewDatePicker.instanceFromNib() as! ViewDatePicker)
            fromDatePicker.setUpPicker(type: .date)
            fromDatePicker.buttonOk.addTarget(self, action: #selector(ViewLogsCalender.dismissFromDatePicker), for: .touchUpInside)
            fromDatePicker.picker.date = self.fromDate
            fromDatePicker.picker.minimumDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
            fromDatePicker.picker.maximumDate = NSCalendar.current.date(byAdding: .month, value: 0, to: Date())
        }
    }
    
    func initToDatePicker(){
        if(toDatePicker == nil){
            toDatePicker = (ViewDatePicker.instanceFromNib() as! ViewDatePicker)
            toDatePicker.setUpPicker(type: .date)
            toDatePicker.buttonOk.addTarget(self, action: #selector(ViewLogsCalender.dismissToDatePicker), for: .touchUpInside)
            toDatePicker.picker.date = self.toDate
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
            self.delegate.dismissMailReportView()
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
    
    @IBAction func submitDates(_ sender: Any) {
        if delegate != nil && self.verifyDate(){
            self.delegate.mailReport(fromDate: self.fromDateString, toDate: self.toDateStirng)
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
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewProfessorMailReport", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
