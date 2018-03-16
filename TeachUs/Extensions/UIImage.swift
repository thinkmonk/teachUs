//
//  UIImage.swift
//  TeachUs
//
//  Created by ios on 3/13/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func getSizeInKb() -> Double{
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((self), 1)!)
        let imageSize: Int = imgData.length
        let imageSizeKB = Double(imageSize)/1024.0
        return imageSizeKB
    }
    
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func compressImagge() -> UIImage? {
        guard let imageData = UIImagePNGRepresentation(self) else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 500.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = UIImagePNGRepresentation(resizedImage)
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 500.0 // ! Or devide for 1024 if you need KB but not kB
        }
        
        return resizingImage
    }
}

