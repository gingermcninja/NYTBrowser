//
//  MasterViewController.swift
//  NYTBrowser
//
//  Created by Paul McGrath on 19/01/2016.
//  Copyright © 2016 Paul McGrath. All rights reserved.
//

import UIKit
import Foundation

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var sectionReports = ["books":[Report](),"blogs":[Report](),"technology":[Report]()]
    var sections = ["books", "blogs", "technology"]
    var objects = [Report]()
    var data = NSMutableData()
    @IBOutlet weak var segmentedControl:UISegmentedControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadDataFromAPI()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
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
                    self.tableView.reloadData()
                })
            } catch let error as NSError {
                print(error.description)
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ArticleTableViewCell

        let object = objects[indexPath.row]
        cell.titleLabel.text = object.title
        cell.abstractLabel.text = object.abstract
        cell.setThumbnailFromURL(NSURL(string: object.thumbnail_standard)!)
        print(object.thumbnail_standard)
        //cell.textLabel!.text = object.title
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
/*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
*/

}

