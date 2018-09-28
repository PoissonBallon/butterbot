//
//  Butterbot.swift
//  App
//
//  Created by Allan Vialatte on 23/05/2018.
//

import Foundation
import Vapor
import Fluent
import GoogleAnalyticsProvider


struct Butterbot: ServiceType {
  static func makeService(for worker: Container) throws -> Butterbot { return Butterbot() }
}


extension Butterbot {
  func action(to event: SlackEvent, on container: Container) -> EventLoopFuture<HTTPResponse> {
    return self.makeFeatures(to: event)
      .map { $0.execute(on: container) }.flatten(on: container)
      .map { $0.flatMap { $0 } }
      .map { self.sendMessage(messages: $0, event: event, on: container) }
      .map { _ in HTTPResponse(status: .accepted) }
  }
}


extension Butterbot {
  func makeFeatures(to event: SlackEvent) -> [ButterbotFeature] {
    let feature: [ButterbotFeature?] = [
      KarmaPointFeature(with: event),
      KarmaBoardFeature(with: event),
      AskMeFeature(with: event)
    ]
    return feature.compactMap { $0 }
  }
}
