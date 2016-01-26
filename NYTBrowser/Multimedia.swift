//
//  Multimedia.swift
//  NYTBrowser
//
//  Created by Paul McGrath on 25/01/2016.
//  Copyright © 2016 Paul McGrath. All rights reserved.
//

import UIKit
import Decodable

public struct Multimedia {
    public let url: String
    public let format: String
    public let type: String
    public let height: Int
    public let width: Int
}

extension Multimedia: Decodable {
    public static func decode(j: AnyObject) throws -> Multimedia {
        return try Multimedia(
            url: j => "url",
            format: j => "format",
            type: j => "type",
            height: j => "height",
            width: j => "width"
        )
    }
    
}