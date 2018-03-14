//
//  FeedRouter.swift
//  RedditClone
//
//  Created by Ahmad Husseini on 2018-03-13.
//

import Foundation
import UIKit
import Moya
import SafariServices

public class FeedRouter: Router {
  public enum Routes: String {
    case viewPost, search
  }
  
  public static func makeRootModule() -> UINavigationController {
    let feedViewController = makeFeedModule()
    return UINavigationController(rootViewController: feedViewController)
  }
  
  public static func makeFeedModule(with name: String = "all") -> FeedViewController {
    let viewModel = FeedViewModel(provider: MoyaProvider<Reddit>(), subreddit: name)
    let router = FeedRouter()
    return FeedViewController(viewModel: viewModel, router: router)
  }
  
  public func route(to routeID: String, from context: UIViewController, parameters: Any?) {
    guard let route = Routes(rawValue: routeID) else { return }
    switch route {
    case .search:
      print("Searching...")
    case .viewPost:
      guard let urlString = parameters as? String, let url = URL(string: urlString) else { return }
      let safariViewController = SFSafariViewController(url: url)
      safariViewController.preferredBarTintColor = .salt
      safariViewController.preferredControlTintColor = .slate
      context.navigationController?.present(safariViewController, animated: true)
    }
  }
}
