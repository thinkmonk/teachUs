//
//  UIButton.swift
//  TeachUs
//
//  Created by ios on 10/26/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
extension UIButton{
        func makeButtonwith(background:UIColor, fontColor:UIColor, cornerRadius:CGFloat?, borderColor:CGColor?, borderWidth:CGFloat?){
            self.backgroundColor = background
            self.setTitleColor(fontColor, for: UIControlState.normal)
            self.layer.cornerRadius = cornerRadius != nil ? cornerRadius! : 0.0
            self.layer.borderWidth = borderWidth != nil ? borderWidth! : 0.0
            self.layer.borderColor = borderColor != nil ? borderColor! : UIColor.clear.cgColor
        }
    
    
    func roundedRedButton(){
        let bgColor:UIColor = Constants.colors.themeRed
        let fontColor:UIColor = UIColor.white
        self.makeButtonwith(background: bgColor, fontColor: fontColor, cornerRadius: self.height()/2, borderColor: nil, borderWidth: 0.0)
    }
    
    func themeRedButton(){
        let bgColor:UIColor = Constants.colors.themeRed
        let fontColor:UIColor = UIColor.white
        self.makeButtonwith(background: bgColor, fontColor: fontColor, cornerRadius: nil, borderColor: nil, borderWidth: 0.0)

    }
    
    func roundedBlueButton(){
        let bgColor:UIColor = Constants.colors.themeBlue
        let fontColor:UIColor = UIColor.white
        self.makeButtonwith(background: bgColor, fontColor: fontColor, cornerRadius: self.height()/2, borderColor: nil, borderWidth: 0.0)
    }

}
