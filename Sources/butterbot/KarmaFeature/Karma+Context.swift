//
//  KarmaParser.swift
//  butterbot
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import SlackKit

struct KarmaContext {
  let event: Event
  let client: ClientConnection
}

extension KarmaContext {
  static let addPointSuffixes =     ["++", "+= 1", "+ 1", ":+1:"]
  static let removePointSuffixes =  ["--", "-= 1", "- 1"]
}

extension KarmaContext {
  
  var fromID: String? {
    return self.event.user?.id
  }
  
  var mentionID: String? {
    guard let text = event.text else { return nil }
    let id = text.components(separatedBy: "<@").last?.components(separatedBy: ">").first
    return id
  }
  
  var isOpenChannel: Bool {
    guard let channelId = self.event.channel?.id else { return false }
    guard let channel = self.client.client?.channels.first(where: { $0.key == channelId })?.value else { return false }
    return !(channel.isGroup ?? false)
  }
  
  var containsAddSuffix: Bool {
    guard let text = event.text else { return false }
    return (KarmaContext.addPointSuffixes.first { text.contains($0) } != nil )
  }
  
  var containsRemoveSuffix: Bool {
    guard let text = event.text else { return false }
    return (KarmaContext.removePointSuffixes.first { text.contains($0) } != nil )
  }
  
}
