//
//  KarmaParser.swift
//  butterbot
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import SlackKit

struct KarmaParser {
  let event: Event
  let client: ClientConnection
  let database: Database
  let text: String
  let channelID: String
  let isOpenChannel: Bool
  
  init(with event: ButterEvent) {
    self.event = event.event
    self.client = event.client
    self.database = event.database
    self.channelID = event.channelID
    self.isOpenChannel = event.isOpenChannel
    self.text = event.event.text?.trimmingCharacters(in: .newlines) ?? ""
    
  }
}

extension KarmaParser {
  static let addPointSuffixes =     ["++", "+= 1", "+ 1", ":+1:"]
  static let removePointSuffixes =  ["--", "-= 1", "- 1", "—"]
}

extension KarmaParser {
  
  var butterbotUser: String? {
    guard let id = self.client.client?.authenticatedUser?.id else { return nil }
    return "<@\(id)>"
  }
  
  var fromUser: String? {
    guard let id = self.event.user?.id else { return nil }
    return "<@\(id)>"
  }
  
  var isLeaderboard: Bool {
    guard let text = event.text?.lowercased() else { return false }
    return text.contains("leaderboard")
  }
  
  var leaderboardCount: Int {
    let base = 5
    guard let textComponents = event.text?.lowercased().components(separatedBy: " ") else { return base }
    guard textComponents.count >= 3 else { return base }
    guard let count = Int(textComponents[2]) else { return base }
    return count
  }

  var countComponents: Int {
    return event.text?.components(separatedBy: " ").count ?? 0
  }
  
  var target: String? {
    guard let text = event.text else { return nil }
    guard let target = text.components(separatedBy: " ").first else { return nil }
    guard target.first == "@" || target.first == "#" || target.first == "<" else { return nil }
    return target
  }
  

  var containsAddSuffix: Bool {
    guard let text = event.text else { return false }
    guard let suffixe = text.components(separatedBy: " ").last else { return false }
    return (KarmaParser.addPointSuffixes.first { $0 == suffixe } != nil )
  }
  
  var containsRemoveSuffix: Bool {
    guard let text = event.text else { return false }
    guard let suffixe = text.components(separatedBy: " ").last else { return false }
    return (KarmaParser.removePointSuffixes.first { $0 == suffixe } != nil )
  }
  
}
