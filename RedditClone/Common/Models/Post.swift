//
//  Post.swift
//  RedditClone
//
//  Created by Ahmad Husseini on 2018-03-13.
//

import SwiftyJSON

public struct Post {
  public let title: String
  public let user: String
  public let subreddit: String
  public let url: String
  public let score: Int64
  
  public init?(_ json: JSON) {
    title = json["title"].stringValue
    user = json["author"].stringValue
    subreddit = json["subreddit"].stringValue
    url = json["url"].stringValue
    score = json["score"].int64Value
  }
}
