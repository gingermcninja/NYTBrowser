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
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var clickForMoreBtn: UIButton!

    var detailItem: Report? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        if let detail = self.detailItem {
            if let label = self.abstractLabel {
                label.text = detail.abstract
            }
            if let label = self.titleLabel {
                label.text = detail.title
            }
            if let label = self.publishedLabel {
                let dateFormatter:NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "EEEE, MMMM d yyyy"
                label.text = dateFormatter.stringFromDate(detail.published_date)
            }
            if let imageView = self.thumbnailImageView {
                imageView.setImageFromURL(NSURL(string: detail.thumbnail_standard)!)
            }
            if let imageView = self.mainImageView {
                if self.detailItem?.multimedia.count > 0 {
                    for media:Multimedia in (self.detailItem?.multimedia)! {
                        if(media.type == "image" && media.format != "Standard Thumbnail") {
                            imageView.setImageFromURL(NSURL(string: media.url)!)
                            break
                        }
                    }
                }
            }
        }
    }
    
    func configureConstraints() {
        let views: [String: AnyObject] = ["topGuide": self.topLayoutGuide, "thumb": thumbnailImageView!, "title": titleLabel!, "abstract": abstractLabel, "published":publishedLabel, "mainImage":mainImageView, "moreBtn":clickForMoreBtn]
        let horizontalTopConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[thumb(75)]-[title]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let horizontalBottomConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[abstract]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let horizontalPublishedDateConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[published]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let horizontalMainImageConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[mainImage]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let horizontalMoreBtnConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[moreBtn]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)

        
        let verticalThumbnailConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-[thumb]-[published]-[mainImage]-[abstract]-[moreBtn]-(>=0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let verticalTitleConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-[title]-[published]-[mainImage]-[abstract]-[moreBtn]-(>=0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
        NSLayoutConstraint.activateConstraints(horizontalTopConstraints+horizontalBottomConstraints+horizontalPublishedDateConstraints+horizontalMainImageConstraints+horizontalMoreBtnConstraints)
        NSLayoutConstraint.activateConstraints(verticalThumbnailConstraints+verticalTitleConstraints)
        
    }
    
    @IBAction func clickForMore() {
        UIApplication.sharedApplication().openURL(NSURL(string:(self.detailItem?.url)!)!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.abstractLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.thumbnailImageView?.translatesAutoresizingMaskIntoConstraints = false
        self.publishedLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.mainImageView?.translatesAutoresizingMaskIntoConstraints = false
        self.clickForMoreBtn.translatesAutoresizingMaskIntoConstraints = false
        self.configureConstraints()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

