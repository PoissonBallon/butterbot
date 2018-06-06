//
//  KarmaLeaderboardFeature.swift
//  App
//
//  Created by Allan Vialatte on 03/06/2018.
//

import Foundation
import Vapor
import Random
import Fluent
import FluentSQL
import FluentPostgreSQL

struct KarmaLeaderboardFeature: ButterbotFeature {
  
  public let priority: Int = 900
  public var event: SlackEvent
  public var isValid: Bool = true
  fileprivate var parser: KarmaLeaderboardParser
  
  
  init?(with event: SlackEvent) {
    guard let parser = KarmaLeaderboardParser(with: event) else { return nil }
    self.event = event
    self.parser = parser
  }
  
  func execute(on container: Container) -> EventLoopFuture<ButterbotMessage?> {
    return self.executeKarmaLeaderboard(on: container)
  }
}

extension KarmaLeaderboardFeature {
  
  fileprivate func executeKarmaLeaderboard(on container: Container) -> EventLoopFuture<ButterbotMessage?> {
    return self.topUser(on: container)
      .and(self.topThings(on: container))
      .map {
        let userFields = self.makeField(from: $0.0, with: "Users")
        let thingsFields = self.makeField(from: $0.1, with: "Things")
        let attachment = ButterbotAttachment(title: nil,
                                             text: nil, fields: [userFields, thingsFields])
        return ButterbotMessage(text: KarmaLeaderboardFeature.L10n.title, attachments: [attachment])
    }
  }
  
  fileprivate func topThings(on container: Container) -> EventLoopFuture<[KarmaPoint]> {
    return container.withPooledConnection(to: .psql) {
      return try $0.query(KarmaPoint.self)
        .filter(\KarmaPoint.teamId == self.parser.teamId)
        .filter(\KarmaPoint.target =~ "#")
        .sort(\KarmaPoint.point, QuerySortDirection.descending)
        .range(lower: 0, upper: self.parser.leaderboardCount)
        .all()
    }
  }
  
  fileprivate func topUser(on container: Container) -> EventLoopFuture<[KarmaPoint]> {
    return container.withPooledConnection(to: .psql) {
      return try $0.query(KarmaPoint.self)
        .filter(\KarmaPoint.teamId == self.parser.teamId)
        .filter(\KarmaPoint.target =~ "<@")
        .sort(\KarmaPoint.point, QuerySortDirection.descending)
        .range(lower: 0, upper: self.parser.leaderboardCount)
        .all()
    }
  }
}

extension KarmaLeaderboardFeature {
  func makeField(from list:[KarmaPoint], with title: String) -> ButterbotAttachmentField {
    var values = ""
    
    list.enumerated().forEach {
      values.append("\($0.offset + 1). ")
      values.append("\($0.element.target) : \($0.element.point) points")
      if $0.offset == 0 { values.append(" :tada: ") }
      values.append("\n")
    }
    return ButterbotAttachmentField(title: "\(title) :", value: values, short: true)
  }
}


extension KarmaLeaderboardFeature {
  
  struct KarmaLeaderboardParser {
    let leaderboardCount: Int
    let teamId: String
    
    init?(with event:SlackEvent) {
      guard event.event.text.lowercased().contains("leaderboard") else { return nil }
      guard let authedUser = event.authedUsers.first else { return nil }
      guard event.event.text.components(separatedBy: " ").contains("<@\(authedUser)>") else { return nil }
      self.teamId = event.teamId
      self.leaderboardCount = {
        let base = 5
        let textComponents = event.event.text.lowercased().components(separatedBy: " ")
        guard textComponents.count >= 3 else { return base }
        guard let count = Int(textComponents[2]), count > 0 else { return base }
        return count
      }()
    }
  }
}


extension KarmaLeaderboardFeature {
  struct L10n {
    static let title = "Top :sports_medal: :"
  }
  
}
