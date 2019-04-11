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
//
//struct KarmaBoardFeature: ButterbotFeature {
//  var event: SlackEvent
//  var parser: KarmaBoardParser
//  
//  init(with event: SlackEvent) {
//    self.event = event
//    self.parser = KarmaBoardParser(with: event)
//  }
//  
//  func execute(on container: Container) -> EventLoopFuture<[ButterbotMessage]> {
//    guard let action = self.parser.parse().first else { return container.eventLoop.newSucceededFuture(result: []) }
//    return self.executeKarmaLeaderboard(with: action, on: container).map { [$0] }
//  }
//  
//  func help(for botID: String) -> ButterbotAttachment? {
//    let title = ":top: Leaderboard instructions"
//    let leaderField = ButterbotAttachmentField(title: "Show Leaderboard :", value: "<@\(botID)> `leaderboard`", short: false)
//    let lastField   = ButterbotAttachmentField(title: "Show Lastboard :", value: "<@\(botID)> `lastboard`", short: false)
//    
//    return ButterbotAttachment(title: title, text: nil, fields: [leaderField, lastField])
//  }
//}
//
//extension KarmaBoardFeature {
//  
//  fileprivate func executeKarmaLeaderboard(with action: KarmaBoardParser.Action, on container: Container) -> EventLoopFuture<ButterbotMessage> {
//    let points = self.boardUser(with: action, on: container).and(self.boardThings(with: action, on: container))
//    
//    return points.map {
//      let userFields = self.makeField(from: $0.0, with: "Users")
//      let thingsFields = self.makeField(from: $0.1, with: "Things")      
//      let attachment = ButterbotAttachment(title: nil, text: nil, fields: [userFields, thingsFields])
//      return ButterbotMessage(text: action.type.title, attachments: [attachment])
//    }
//  }
//  
//  fileprivate func boardThings(with action: KarmaBoardParser.Action, on container: Container) -> EventLoopFuture<[KarmaPoint]> {
//    let sqlDirection = action.type == .leaderboard ? GenericSQLDirection.descending : GenericSQLDirection.ascending
//    
//    return container.withPooledConnection(to: .psql) {
//      return KarmaPoint.query(on: $0)
//        .filter(\KarmaPoint.teamId == self.parser.teamId)
//        .filter(\KarmaPoint.target =~ "#")
//        .sort(\KarmaPoint.point, sqlDirection)
//        .range(lower: 0, upper: (action.length - 1))
//        .all()
//    }
//  }
//  
//  fileprivate func boardUser(with action: KarmaBoardParser.Action, on container: Container) -> EventLoopFuture<[KarmaPoint]> {
//    let sqlDirection = action.type == .leaderboard ? GenericSQLDirection.descending : GenericSQLDirection.ascending
//    
//    return container.withPooledConnection(to: .psql) {
//      return KarmaPoint.query(on: $0)
//        .filter(\KarmaPoint.teamId == self.parser.teamId)
//        .filter(\KarmaPoint.target =~ "<@")
//        .sort(\KarmaPoint.point, sqlDirection)
//        .range(lower: 0, upper: (action.length - 1))
//        .all()
//    }
//  }
//}
//
//extension KarmaBoardFeature {
//  func makeField(from list:[KarmaPoint], with title: String) -> ButterbotAttachmentField {
//    var values = ""
//    
//    list.enumerated().forEach {
//      values.append("\($0.offset + 1). ")
//      values.append("\($0.element.target) : \($0.element.point) points")
//      if $0.offset == 0 { values.append(" :tada: ") }
//      values.append("\n")
//    }
//    return ButterbotAttachmentField(title: "\(title) :", value: values, short: true)
//  }
//}
