//
//  ArticlesViewController.swift
//  NYTBrowser
//
//  Created by Paul McGrath on 21/01/2016.
//  Copyright © 2016 Paul McGrath. All rights reserved.
//

import Foundation
import UIKit

class ArticlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var segmentedControl:UISegmentedControl?
    @IBOutlet weak var loadingView:UIView?
    @IBOutlet weak var activity:UIActivityIndicatorView?

    var detailViewController: DetailViewController? = nil
    var sections = ["books", "blogs", "technology"]
    var objects = [Report]()
    var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView?.hidden = true
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControl?.translatesAutoresizingMaskIntoConstraints = false
        self.loadingView?.translatesAutoresizingMaskIntoConstraints = false
        self.activity?.translatesAutoresizingMaskIntoConstraints = false
        configureConstraints()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        let section:String = self.sections[(self.segmentedControl?.selectedSegmentIndex)!]
        displayData(WebService().getStoredResults(section))
        reloadDataFromAPI()
    }
    
    func configureConstraints() {
        let views: [String: AnyObject] = ["topGuide": self.topLayoutGuide, "tabbar": segmentedControl!, "table": tableView!, "loading": loadingView!, "activity": activity!]
        let horizontalTabBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[tabbar]-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let horizontalTableConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[table]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let horizontalLoadingConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[loading]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let horizontalActivityConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[activity]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-[tabbar]-[table]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let verticalLoadingConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-[tabbar]-[loading]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        self.loadingView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[loading]-(<=1)-[activity]", options: .AlignAllCenterY, metrics: nil, views: ["activity": activity!, "loading":loadingView!]))
        self.loadingView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[loading]-(<=1)-[activity]", options: .AlignAllCenterX, metrics: nil, views: ["activity": activity!, "loading":loadingView!]))
        NSLayoutConstraint.activateConstraints(horizontalTabBarConstraints+horizontalTableConstraints+horizontalLoadingConstraints+horizontalActivityConstraints)
        NSLayoutConstraint.activateConstraints(verticalConstraints+verticalLoadingConstraints)

    }
    
    @IBAction func sectionChanged() {
        reloadDataFromAPI()
    }
    
    func reloadDataFromAPI() {
        let service:WebService = WebService()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        loadingView?.hidden = false
        let section:String = self.sections[(self.segmentedControl?.selectedSegmentIndex)!]
        service.getFromAPI(section) { (apiData, apiError) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loadingView?.hidden = true
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            if(apiError != nil) {
                let alert = UIAlertController(title: "Error", message: apiError?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            } else {
                self.displayData(apiData!)
            }
        }
    }
    
    func displayData(dataArray:NSArray) {
        do {
            self.objects = try [Report].decode(dataArray)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.detailViewController?.detailItem = self.objects.first
                self.tableView!.reloadData()
            })
        } catch let error as NSError {
            print(error.description)
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView!.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d yyyy"
        let object = objects[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath) as! ArticleTableViewCell
        cell.titleLabel.text = object.title
        cell.publishDateLabel.text = dateFormatter.stringFromDate(object.published_date)
        cell.thumbnailImg.setImageFromURL(NSURL(string: object.thumbnail_standard)!)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}
