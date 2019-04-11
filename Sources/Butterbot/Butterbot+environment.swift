//
//  environment.swift
//  App
//
//  Created by Allan Vialatte on 18/05/2018.
//

import Foundation
import Vapor

extension Environment {
  
  static var slackClientID: String {
    return valueForKey(key: "SLACK_CLIENT_ID")
  }

  static var slackClientSecret: String {
    return valueForKey(key: "SLACK_CLIENT_SECRET")
  }
  
  static var postgreUri: String {
    return valueForKey(key: "DATABASE_URL")
  }
  
  static var GoogleAnalyticsTrackingID: String {
    return valueForKey(key: "GA_TRACKING_ID")
  }
}

extension Environment {
  fileprivate static func valueForKey(key: String) -> String {
    guard let value = Environment.get(key)
      else { fatalError("\(key) not set in environment variable") }
    return value
  }
}
