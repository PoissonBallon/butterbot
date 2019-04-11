//
//  Butterbot.swift
//  App
//
//  Created by Allan Vialatte on 23/05/2018.
//

import Foundation
import Vapor
import Fluent

public class Butterbot {
  var config: Config
  var environment: Environment
  var services: Services
  var feature: [ButterFeature]
  
  public init() throws {
    self.config = Config.default()
    self.environment = try Environment.detect()
    self.services = Services.default()
    self.feature = []
  }
  
  public func launch() throws {
    try self.configure()
    try Application(config: config, environment: environment, services: services).run()
  }
}

extension Butterbot {
  func addFeature(feature: ButterFeature) {
    
  }
}


//
//struct Butterbot: ServiceType {
//  static func makeService(for worker: Container) throws -> Butterbot { return Butterbot() }
//}
//
//
//extension Butterbot {
//  func action(to event: SlackEvent, on container: Container) -> EventLoopFuture<HTTPResponse> {
//    return Butterbot.makeFeatures(to: event)
//      .map { $0.execute(on: container) }
//      .flatten(on: container)
//      .map { $0.flatMap { $0 } }
//      .map { self.sendMessage(messages: $0, event: event, on: container) }
//      .map { _ in HTTPResponse(status: .accepted) }
//  }
//}
//
//
//extension Butterbot {
//  static func makeFeatures(to event: SlackEvent) -> [ButterbotFeature] {
//    let feature: [ButterbotFeature?] = [
//      KarmaPointFeature(with: event),
//      KarmaBoardFeature(with: event),
//      AskMeFeature(with: event),
//      HelpFeature(with: event)
//    ]
//    return feature.compactMap { $0 }
//  }
//}
