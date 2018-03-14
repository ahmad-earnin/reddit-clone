//
//  RedditService.swift
//  RedditClone
//
//  Created by Ahmad Husseini on 2018-03-13.
//

import Foundation
import Moya

public enum Reddit {
  case search(term: String)
  case subreddit(name: String, after: String?)
}

extension Reddit: TargetType {
  public var baseURL: URL { return URL(string: "https://www.reddit.com/")! }
  
  public var path: String {
    switch self {
    case .search:
      return "/api/search_subreddits.json"
    case let .subreddit(name, _):
      return "/r/\(name)/hot.json"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .search:
      return .post
    case .subreddit:
      return .get
    }
  }
  
  public var sampleData: Data {
    return Data()
  }
  
  public var task: Task {
    switch self {
    case let .search(term):
      let parameters = ["query": term]
      return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
    case let .subreddit(_, after):
      let parameters = ["after": after ?? ""]
      return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
  }
  
  public var headers: [String : String]? {
    return nil
  }
}
