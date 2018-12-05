//
//  HelpFeature.swift
//  App
//
//  Created by Allan Vialatte on 05/12/2018.
//

import Foundation
import Vapor
import Random
import Fluent
import FluentSQL
import FluentPostgreSQL

struct HelpFeature: ButterbotFeature {
  var event: SlackEvent
  var parser: HelpParser
  
  init(with event: SlackEvent) {
    self.event = event
    self.parser = HelpParser(with: event)
  }
  
  func execute(on container: Container) -> EventLoopFuture<[ButterbotMessage]> {
    guard let action = self.parser.parse().first else { return container.eventLoop.newSucceededFuture(result: []) }
    return self.executeHelp(with: action, on: container).map { [$0] }
  }
  
  func help(for botID: String) -> ButterbotAttachment? {
    return nil
  }
  
}

extension HelpFeature {
  
  fileprivate func executeHelp(with action: HelpParser.Action, on container: Container) -> EventLoopFuture<ButterbotMessage> {
    let feature = Butterbot.makeFeatures(to: self.event)
    let attachments = feature.compactMap { $0.help(for: self.parser.authedBot) }
    let message = ButterbotMessage(text: "Butterbot Help", attachments: attachments)
    return container.eventLoop.newSucceededFuture(result: message)
  }
}
