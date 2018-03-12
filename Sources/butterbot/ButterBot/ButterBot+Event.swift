//
//  ButterBot+Event.swift
//  MySQL
//
//  Created by Allan Vialatte on 12/03/2018.
//

import Foundation
import SlackKit

struct ButterEvent {
  let event: Event
  let client: ClientConnection
  let database: Database
  let channelID: String
  
  init?(event: Event, client: ClientConnection, database: Database) {
    self.event = event
    self.client = client
    self.database = database
    guard let channelID = event.channel?.id else { return nil }
    self.channelID = channelID
  }
}

extension ButterEvent {
  var isOpenChannel: Bool {
    guard let channelId = self.event.channel?.id else { return false }
    guard let channel = self.client.client?.channels.first(where: { $0.key == channelId })?.value else { return false }
    return !(channel.isGroup ?? false)
  }
}
