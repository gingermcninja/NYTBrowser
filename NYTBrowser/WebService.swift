//
//  WebService.swift
//  NYTBrowser
//
//  Created by Paul McGrath on 19/01/2016.
//  Copyright © 2016 Paul McGrath. All rights reserved.
//

import UIKit

class WebService: NSObject {
    //var apiURL: String = "http://api.nytimes.com/svc/news/v3/content/all/arts?api-key=c99d5f66d65258b413eb1614d3bcaed9:6:74062624&time-period=48"
    var baseURL: String = "http://api.nytimes.com/svc/news/v3/content/all/"
    var paramenters: String = "?api-key=c99d5f66d65258b413eb1614d3bcaed9:6:74062624&time-period=48"
    
    func getFromAPI(section:String, completionHandler: (NSArray?, NSError?) -> Void) {
        let fullApiURL = NSURL(string:self.baseURL+section+self.paramenters)
        let request: NSURLRequest = NSURLRequest(URL: fullApiURL!)
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                let responseDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                let results: NSArray = responseDictionary["results"] as! NSArray
                completionHandler(results,error)
            } catch let error as NSError {
                print(error.description)
                completionHandler(nil,error)
            }
        }
        task.resume()

    }
}
