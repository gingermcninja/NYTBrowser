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
    @IBOutlet weak var publishDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImg.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        publishDateLabel.translatesAutoresizingMaskIntoConstraints = false
        configureConstraints()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureConstraints() {
        let views = ["thumb": thumbnailImg, "title":titleLabel, "published":publishDateLabel]
        let horizontalTitleConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[thumb(75)]-8-[title]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let horizontalPublishedDateConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[thumb(75)]-8-[published]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let verticalThumbnailConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[thumb(75)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let verticalLabelConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[title(60)][published]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(horizontalTitleConstraints+horizontalPublishedDateConstraints+verticalThumbnailConstraints+verticalLabelConstraints)
    }

}
