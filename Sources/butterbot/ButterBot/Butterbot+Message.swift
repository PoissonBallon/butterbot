//
//  Butterbot+Message.swift
//  MySQL
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation
import SlackKit

struct ButterMessage {
  let text: String
  let actionName: String
  let channelID: String
}

extension ButterBot {
  func sendMessage(message: ButterMessage?) {
    guard let message = message else { return }
    try? self.slackKit.rtm?.sendMessage(message.text, channelID: message.channelID)
  }
}
