//
//  Butterbot+Message.swift
//  MySQL
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation
import SlackKit

struct ButterMessage {
  var text: String
  let channelID: String

  func consolidateUser(client: ClientConnection)-> ButterMessage {
    let userCodes: [String]? = client.client?.users.compactMap { $0.key }
    var newText = self.text
    userCodes?.forEach { newText = newText.replacingOccurrences(of: $0, with: "<@\($0)>")}
    return ButterMessage(text: newText, channelID: self.channelID)
  }

}

extension ButterBot {

  func sendMessage(message: ButterMessage, client: ClientConnection) {
    let message = message.consolidateUser(client: client)
    try? self.slackKit.rtm?.sendMessage(message.text, channelID: message.channelID)
  }
  
  
}
