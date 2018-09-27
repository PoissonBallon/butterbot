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
  
  func execute(on container: Container) -> EventLoopFuture<ButterbotMessage?> {
    return container.eventLoop.newFailedFuture(error: ButterbotError.notRegister)
    return self.executeKarmaPoint(on: container)
  }
}

extension KarmaPointFeature {
  
  fileprivate func executeKarmaPoint(on container: Container) -> EventLoopFuture<ButterbotMessage?> {
    let actions = self.parser.parse()
    self.requestKarma(from: actions, with: container)
    
  }
  
  fileprivate func updateOrCreateKarmaPoint(updates:[KarmaPoint], actions: [KarmaFeatureParser.Action]) -> [KarmaPoint] {
    return actions.map { (action) in {
      let karmaPoint = updates.first(where: {$0.target == action.target}) ?? KarmaPoint(target: action.target, point: 0, teamId: self.parser.teamID)
      karmaPoint.point = karmaPoint.point + action.point
      return karmaPoint
    }
  }
  
  fileprivate func updateDatabaseKarma(from actions : [KarmaFeatureParser.Action], with container: Container) -> EventLoopFuture<[KarmaPoint]>  {
    return container.withPooledConnection(to: .psql) { (connection) -> EventLoopFuture<[KarmaPoint]> in
      return KarmaPoint
        .query(on: connection)
        .filter(\KarmaPoint.teamId == self.parser.teamID)
        .filter(\KarmaPoint.target ~~ actions.map({ $0.target }))
        .all()
        .map { self.updateOrCreateKarmaPoint(updates: $0, actions: actions) }
        .flatMap { conne
    }
  }
  
  
  
  fileprivate func generateMessage(with action: KarmaFeatureParser.Action, point: Int, and result: KarmaPoint) -> EventLoopFuture<ButtebotMessage> {
    var sentence: String?
    guard self.parser.isBanish == false else { return ButterbotMessage(text: L10n.banish.random ?? "", attachments: nil) }
    if self.parser.isCheater { sentence = L10n.cheaters.random }
    else if self.parser.containsAddSuffix { sentence = L10n.congrats.random }
    else if self.parser.containsRemoveSuffix { sentence = L10n.reproves.random }
    let text = "\(sentence ?? "") [\(karmaPoint.target) : \(karmaPoint.point) points]"
    let message = ButterbotMessage(text: text, attachments: nil)
    return message
  }
}
}

}
