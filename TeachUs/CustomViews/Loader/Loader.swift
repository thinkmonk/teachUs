//
//  Loader.swift
//  TeachUs
//
//  Created by ios on 10/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class Loader: UIView {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var viewBackground: UIView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func start(){
        viewBackground.makeEdgesRounded()
        loader.startAnimating()
    }

    func stop(){
        loader.stopAnimating()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Loader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }



}
