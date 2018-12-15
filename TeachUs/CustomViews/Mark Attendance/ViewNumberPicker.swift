//
//  ViewDatePicker.swift
//  TeachUs
//
//  Created by ios on 11/12/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewNumberPicker: UIView {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var buttonOk: UIButton!
    @IBOutlet weak var viewPickerBackground: UIView!
    var pickerData: [String] = []
    var selectedValue = Variable<String>("1")

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpPicker(){
        for i in 1...10{
            pickerData.append("\(i)")
        }
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(0, inComponent: 0, animated: true)
        picker.backgroundColor = UIColor.white
        self.buttonOk.roundedRedButton()
    }
    
    func showView(inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width()
        self.frame.size.height = inView.height()
        self.center.x = inView.centerX()
        self.center.y = inView.centerY()
        self.viewPickerBackground.makeEdgesRounded()
        inView.addSubview(self)
        
        //display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewNumberPicker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}

extension ViewNumberPicker : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedValue.value = pickerData[row]
    }
    
}
