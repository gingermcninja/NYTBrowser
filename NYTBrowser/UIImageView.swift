//
//  UIImageView.swift
//  NYTBrowser
//
//  Created by Paul McGrath on 20/01/2016.
//  Copyright © 2016 Paul McGrath. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromURL(url:NSURL) {
        getImage(url) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard let data = data where error == nil else {
                    self.image = UIImage(named: "NYT-logo")
                    return
                }
                self.image = UIImage(data: data)
            })
        }
    }
    
    func getImage(url:NSURL, completion:((data:NSData?, response:NSURLResponse?, error:NSError?) -> Void )) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data:data, response: response, error: error)
            }.resume()
    }
}