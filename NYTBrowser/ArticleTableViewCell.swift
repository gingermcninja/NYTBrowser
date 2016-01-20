//
//  ArticleTableViewCell.swift
//  NYTBrowser
//
//  Created by Paul McGrath on 19/01/2016.
//  Copyright © 2016 Paul McGrath. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getThumbnailImage(url:NSURL, completion:((data:NSData?, response:NSURLResponse?, error:NSError?) -> Void )) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data:data, response: response, error: error)
        }.resume()
    }
    
    func setThumbnailFromURL(url:NSURL) {
        getThumbnailImage(url) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard let data = data where error == nil else {
                    self.thumbnailImg.image = UIImage(named: "NYT-logo")
                    return
                }
                self.thumbnailImg.image = UIImage(data: data)
            })
        }
    }

}
