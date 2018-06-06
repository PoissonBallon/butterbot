//
//  Butterbot.swift
//  App
//
//  Created by Allan Vialatte on 23/05/2018.
//

import Foundation
import Vapor
import Fluent


struct Butterbot: ServiceType {
  func action(to event: SlackEvent, on container: Container) -> EventLoopFuture<HTTPResponse> {
    let chooseFeature = self.makeFeatures(to: event)
      .filter { $0.isValid }
      .sorted { $0.priority > $1.priority }.first
    
    guard let feature = chooseFeature else {
      return container.eventLoop.newSucceededFuture(result: HTTPResponse(status: .noContent))
    }
    return feature.execute(on: container).flatMap { try self.sendMessage(message: $0, event: event, on: container) }
  }
  
  static func makeService(for worker: Container) throws -> Butterbot { return Butterbot() }
}

extension Butterbot {
  func makeFeatures(to event: SlackEvent) -> [ButterbotFeature] {
    let feature: [ButterbotFeature?] = [
      KarmaPointFeature(with: event),
      KarmaLeaderboardFeature(with: event),
      AskMeFeature(with: event)
    ]
    return feature.compactMap { $0 }
  }
}
