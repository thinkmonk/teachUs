//
//  UIImageView.swift
//  TeachUs
//
//  Created by ios on 11/25/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
extension UIImageView {
    public func imageFromServerURL(urlString: String, defaultImage : String?) {
        print("URL String \(urlString)")
        if let di = defaultImage {
            self.image = UIImage(named: di)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
