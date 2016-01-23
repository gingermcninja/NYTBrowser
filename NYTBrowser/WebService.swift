//
//  WebService.swift
//  NYTBrowser
//
//  Created by Paul McGrath on 19/01/2016.
//  Copyright © 2016 Paul McGrath. All rights reserved.
//

import UIKit

class WebService: NSObject {
    var baseURL: String = "http://api.nytimes.com/svc/news/v3/content/all/"
    var paramenters: String = "?api-key=c99d5f66d65258b413eb1614d3bcaed9:6:74062624&time-period=48&limit=20"
    
    func getFromAPI(section:String, completionHandler: (NSArray?, NSError?) -> Void) {
        let fullApiURL = NSURL(string:self.baseURL+section+self.paramenters)
        let request: NSURLRequest = NSURLRequest(URL: fullApiURL!)
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                let responseDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                let results: NSArray = responseDictionary["results"] as! NSArray
                NSUserDefaults.standardUserDefaults().setValue(data, forKey: section)
                completionHandler(results,error)
            } catch let error as NSError {
                print(error.description)
                completionHandler(nil,error)
            }
        }
        task.resume()
    }
    
    func getStoredResults(section:String) -> NSArray {
        guard let data:NSData = NSUserDefaults.standardUserDefaults().valueForKey(section) as? NSData else {return NSArray()}
        do {
            let responseDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
            let results: NSArray = responseDictionary["results"] as! NSArray
            return results
        } catch let error as NSError {
            print(error.description)
            return NSArray()
        }
    }
    
    
}
