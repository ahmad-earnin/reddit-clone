//
//  Listing.swift
//  RedditClone
//
//  Created by Ahmad Husseini on 2018-03-13.
//

import Foundation
import SwiftyJSON

public struct Listing {
  public let after: String
  public let children: [Post]
  
  public init?(_ json: JSON) {
    guard let dictionary = json.dictionary, let data = dictionary["data"] else { return nil }
    
    after = data["after"].stringValue
    children = data["children"].arrayValue.flatMap { Post($0["data"]) }
  }
}
