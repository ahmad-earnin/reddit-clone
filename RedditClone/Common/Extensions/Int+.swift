//
//  Int+.swift
//  RedditClone
//
//  Created by Ahmad Husseini on 2018-03-13.
//

import Foundation

extension Int64 {
  public func coloquialString() -> String {
    if self < 1000 { return "\(self)"}
    let formattedString = String(format: "%.1f", Double(self / 1000))
    return "\(formattedString)k"
  }
}
