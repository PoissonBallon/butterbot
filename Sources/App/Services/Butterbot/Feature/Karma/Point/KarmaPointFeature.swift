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


