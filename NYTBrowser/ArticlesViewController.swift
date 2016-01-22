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
    var detailViewController: DetailViewController? = nil
    var sections = ["books", "blogs", "technology"]
    var objects = [Report]()
    var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControl?.translatesAutoresizingMaskIntoConstraints = false
        configureConstraints()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        reloadDataFromAPI()
    }
    
    func configureConstraints() {
        let views: [String: AnyObject] = ["topGuide": self.topLayoutGuide, "tabbar": segmentedControl!, "table": tableView!]
        let horizontalTabBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[tabbar]-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let horizontalTableConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[table]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-[tabbar]-[table]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(horizontalTabBarConstraints+horizontalTableConstraints+verticalConstraints)

    }
    
    @IBAction func sectionChanged() {
        reloadDataFromAPI()
    }
    
    func reloadDataFromAPI() {
        let service:WebService = WebService()
        service.getFromAPI(self.sections[(self.segmentedControl?.selectedSegmentIndex)!]) { (apiData, apiError) -> Void in
            do {
                self.objects = try [Report].decode(apiData!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.detailViewController?.detailItem = self.objects.first
                    self.tableView!.reloadData()
                })
            } catch let error as NSError {
                print(error.description)
            }
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
