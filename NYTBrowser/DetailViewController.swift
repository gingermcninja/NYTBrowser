//
//  DetailViewController.swift
//  NYTBrowser
//
//  Created by Paul McGrath on 19/01/2016.
//  Copyright © 2016 Paul McGrath. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    
    var detailItem: Report? {
        didSet {
            // Update the view.
            self.configureView()

        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.abstractLabel {
                label.text = detail.abstract
            }
            if let label = self.titleLabel {
                label.text = detail.title
            }
            if let imageView = self.thumbnailImageView {
                imageView.setImageFromURL(NSURL(string: detail.thumbnail_standard)!)
            }
        }
    }
    
    func configureConstraints() {
        let views: [String: AnyObject] = ["topGuide": self.topLayoutGuide, "thumb": thumbnailImageView!, "title": titleLabel!, "abstract": abstractLabel]
        let horizontalTopConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[thumb(75)]-[title]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let horizontalBottomConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[abstract]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let verticalThumbnailConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-[thumb]-[abstract]-(>=0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let verticalTitleConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-[title]-[abstract]-(>=0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(horizontalTopConstraints+horizontalBottomConstraints+verticalThumbnailConstraints+verticalTitleConstraints)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.abstractLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.thumbnailImageView?.translatesAutoresizingMaskIntoConstraints = false
        self.configureConstraints()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

