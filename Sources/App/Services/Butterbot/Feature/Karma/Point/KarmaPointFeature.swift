//  KarmaFeature.swift
//  App
//
//  Created by Allan Vialatte on 24/05/2018.
//

import Foundation
import Vapor
import Random
import Fluent
import FluentPostgreSQL
import Regex

struct KarmaPointFeature: ButterbotFeature {
  let priority: Int = 750
  let event: SlackEvent
  let parser: KarmaFeatureParser
  
  
  init?(with event: SlackEvent) {
    self.event = event
    self.parser = KarmaFeatureParser(with: event)
  }
  
  func execute(on container: Container) -> EventLoopFuture<[ButterbotMessage]> {
    return self.executeKarmaPoint(on:container)
  }
  
  func help(for botID: String) -> ButterbotAttachment? {
    let title = ":first_place_medal: Karma instructions"
    
    let addToken = KarmaPointFeatureToken.addPointToken.map { "`\($0)`" }.joined(separator: " || ")
    let removeToken = KarmaPointFeatureToken.removePointToken.map { "`\($0)`" }.joined(separator: " || ")
    let addRandomToken = KarmaPointFeatureToken.randomAddPointToken.map { "`\($0)`" }.joined(separator: " || ")
    let removeRandomToken = KarmaPointFeatureToken.randomRemovePointToken.map { "`\($0)`" }.joined(separator: " || ")
    
    let addPoint = ButterbotAttachmentField(title: "Add 1 karma point :", value: "(@someone || #something) (\(addToken))", short: false)
    let removePoint = ButterbotAttachmentField(title: "Remove 1 karma point :", value: "(@someone || #something) (\(removeToken))", short: false)
    let addRandomPoint = ButterbotAttachmentField(title: "Add (1..5) karma point(s) :", value: "(@someone || #something) (\(addRandomToken))", short: false)
    let removeRandomPoint = ButterbotAttachmentField(title: "Remove (1..5) karma point(s) :", value: "(@someone || #something) (\(removeRandomToken))", short: false)

    return ButterbotAttachment(title: title, text: nil, fields: [addPoint, removePoint, addRandomPoint, removeRandomPoint])
  }
}

extension KarmaPointFeature {
  
  fileprivate func executeKarmaPoint(on container: Container) -> EventLoopFuture<[ButterbotMessage]> {
    let actions = self.parser.parse()
    let executeAction = actions.map { self.updateDatabaseKarma(from: $0, with: container) }.flatten(on: container)
    let message = executeAction.map { $0.map { self.generateMessage(with: $0.1, and: $0.0)} }
    return message
  }
  
  
  
  fileprivate func updateDatabaseKarma(from action : KarmaFeatureParser.Action, with container: Container) -> EventLoopFuture<(KarmaPoint, KarmaFeatureParser.Action)>  {
    return container.withPooledConnection(to: .psql) { (connection) -> EventLoopFuture<(KarmaPoint, KarmaFeatureParser.Action)> in
      return KarmaPoint
        .query(on: connection)
        .filter(\KarmaPoint.teamId == self.parser.teamID)
        .filter(\KarmaPoint.target == action.target)
        .first()
        .map { $0 ?? KarmaPoint(target: action.target, point: 0, teamId: self.parser.teamID) }
        .map { KarmaPoint(id: $0.id, target: $0.target, point: $0.point + action.point, teamId: $0.teamId) }
        .flatMap { $0.save(on: connection) }
        .and(result: action)
    }
  }
  
  
  fileprivate func generateMessage(with action: KarmaFeatureParser.Action, and karma: KarmaPoint) -> ButterbotMessage {
    let sign = (action.point > 0) ? "+" : "-"
    let pointAbs = abs(action.point)
    let text = "\(action.sentence) (\(sign)\(pointAbs)pts) : [\(karma.target) : \(karma.point) points]"
    let message = ButterbotMessage(text: text, attachments: nil)
    return message
  }
}


