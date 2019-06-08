//
//  UIImageView.swift
//  TeachUs
//
//  Created by ios on 11/25/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension UIImageView {
    public func imageFromServerURL(urlString: String, defaultImage : String?) {
        if let imageURL = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
            let downloadPicTask = session.dataTask(with: imageURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded picture with response code \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self.image = image
                            }
                            // Do something with your image.
                        } else {
                            if let di = defaultImage, let image = UIImage(named: di) {
                                self.image = image
                            }
                        }
                    } else {
                        if let di = defaultImage, let image = UIImage(named: di) {
                            self.image = image
                        }
                    }
                }
            }
            
            downloadPicTask.resume()
        }
    }
    
    /// Download image method woth completion block updates
    ///
    /// - Parameters:
    ///   - urlString: urlString description
    ///   - defaultImage: defaultImage description
    ///   - completion: completion description
    public func imageFromServerURL(urlString: String, defaultImage : String?, _ completion:@escaping (_ success:Bool) -> Void) {
        if let imageURL = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
            let downloadPicTask = session.dataTask(with: imageURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded picture with response code \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self.image = image
                                completion(true)
                            }
                            // Do something with your image.
                        } else {
                            if let di = defaultImage, let image = UIImage(named: di) {
                                self.image = image
                                completion(true)
                            }
                        }
                    } else {
                        if let di = defaultImage, let image = UIImage(named: di) {
                            self.image = image
                            completion(true)
                        }
                    }
                }
            }
            
            downloadPicTask.resume()
        }
    }

    
}
