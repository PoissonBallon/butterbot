//
//  SlackPostMessage.swift
//  App
//
//  Created by Allan Vialatte on 02/06/2018.
//

import Foundation
import Vapor

struct SlackConversMessage: Content {
  let channel: String
  let text: String
  let attachments: [SlackConversAttachment]?
  let mrkdwn: Bool = true
  let asUser: Bool = false
  
  enum CodingKeys: String, CodingKey {
    case channel = "channel"
    case text = "text"
    case attachments = "attachments"
    case mrkdwn = "mrkdwn"
    case asUser = "as_user"
  }
}

