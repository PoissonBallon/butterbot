//
//  SlackEventMessage.swift
//  App
//
//  Created by Allan Vialatte on 23/05/2018.
//

import Foundation
import Vapor

struct SlackEventMessage: Content {
  let type: String
  let channel: String
  let user: String
  let text: String
  let ts: String
  let eventTs: String
  let channelType: String
  
  enum CodingKeys: String, CodingKey {
    case type = "type"
    case channel = "channel"
    case user = "user"
    case text = "text"
    case ts = "ts"
    case eventTs = "event_ts"
    case channelType = "channel_type"
  }
}
