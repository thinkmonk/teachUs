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
    
    func roundedPurpleButton(){
        let bgColor:UIColor = Constants.colors.themePurple
        let fontColor:UIColor = UIColor.white
        self.makeButtonwith(background: bgColor, fontColor: fontColor, cornerRadius: self.height()/2, borderColor: nil, borderWidth: 0.0)
    }
    
    func roundedgreyButton(){
        let bgColor:UIColor = UIColor.lightGray
        let fontColor:UIColor = UIColor.white
        self.makeButtonwith(background: bgColor, fontColor: fontColor, cornerRadius: self.height()/2, borderColor: nil, borderWidth: 0.0)
    }
    
    func selectedDefaultButton(){
        let bgColor:UIColor = UIColor.rgbColor(126.0, 132.0, 155.0)
        let fontColor:UIColor = UIColor.white
        self.makeButtonwith(background: bgColor, fontColor: fontColor, cornerRadius: nil, borderColor: nil, borderWidth: 0.0)

    }
    
    func selectedRedButton(){
        let bgColor:UIColor = UIColor.rgbColor(299.0, 0.0, 0.0) 
        let fontColor:UIColor = UIColor.white
        self.makeButtonwith(background: bgColor, fontColor: fontColor, cornerRadius: nil, borderColor: nil, borderWidth: 0.0)

    }
    
    func selectedGreenButton(){
        let bgColor:UIColor = UIColor.rgbColor(0.0, 143.0, 83.0)
        let fontColor:UIColor = UIColor.white
        self.makeButtonwith(background: bgColor, fontColor: fontColor, cornerRadius: nil, borderColor: nil, borderWidth: 0.0)
    }

}
