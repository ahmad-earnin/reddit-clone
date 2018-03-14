//
//  Router.swift
//  RedditClone
//
//  Created by Ahmad Husseini on 2018-03-13.
//

import Foundation
import UIKit

public protocol Router {
  func route(to routeID: String, from context: UIViewController, parameters: Any?)
}
