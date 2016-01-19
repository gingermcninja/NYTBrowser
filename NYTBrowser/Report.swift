//
//  Report.swift
//  NYTBrowser
//
//  Created by Paul McGrath on 19/01/2016.
//  Copyright © 2016 Paul McGrath. All rights reserved.
//

import UIKit
import Decodable

public struct Report {
    public let title: String
    public let subheadline: String
    public let abstract: String
    public let thumbnail_standard: String
    public let created_date: NSDate
    public let updated_date: NSDate
    public let published_date: NSDate
}

extension Report: Decodable {
    public static func decode(j: AnyObject) throws -> Report {
        return try Report(
            title: j => "title",
            subheadline: j => "subheadline",
            abstract: j => "abstract",
            thumbnail_standard: j => "thumbnail_standard",
            created_date: decodeDateFromString(j => "created_date"),
            updated_date: decodeDateFromString(j => "updated_date"),
            published_date: decodeDateFromString(j => "published_date")
        )
    }
    
    private static func decodeDateFromString(date: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddThh:mm:ssxxx"
        return dateFormatter.dateFromString(date) ?? NSDate()
    }
}
