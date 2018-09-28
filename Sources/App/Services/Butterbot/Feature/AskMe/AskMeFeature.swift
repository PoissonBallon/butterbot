//
//  AskMeFeature.swift
//  App
//
//  Created by Allan Vialatte on 06/06/2018.
//

import Foundation
import Vapor
import Random
import FluentPostgreSQL

struct AskMeFeature: ButterbotFeature {
  
  public let priority: Int = 750
  public var event: SlackEvent
  public var isValid: Bool = true
  
  
  init?(with event: SlackEvent) {
    guard (AskMeParser(with: event) != nil) else { return nil }
    self.event = event
  }
  
  func execute(on container: Container) -> EventLoopFuture<[ButterbotMessage]> {
    let answer: String? = ([true, false].random ?? false) ? L10n.yes.random : L10n.not.random
    let message = ButterbotMessage(text: answer ?? "", attachments: nil)
    return container.eventLoop.newSucceededFuture(result: [message])
  }
}

extension AskMeFeature {
  
  struct AskMeParser {
    init?(with event: SlackEvent) {
      guard let authedUser = event.authedUsers.first else { return nil }
      guard event.event.text.components(separatedBy: " ").contains("<@\(authedUser)>") else { return nil }
      guard event.event.text.lowercased().contains("est-ce qu") else { return nil }
    }
  }
}

extension AskMeFeature {
  struct L10n {
    
    static var yes:[String] = [
      "Yes :thumbsup:",
      "Owyyyyy :thumbsup:",
      "Je veux mon vieux :thumbsup:",
      "Plutôt deux fois qu'une !! :thumbsup:",
      "Evidemment :thumbsup:",
      "Sure :thumbsup:",
      "Oui :thumbsup:",
      "Bien sure :thumbsup:",
      "Of course :thumbsup:",
      "Obviously :thumbsup:"
    ]
    
    static var not: [String] = [
      "Nop :thumbsdown:",
      "Je ne pense pas :thumbsdown:",
      "Never never :thumbsdown:",
      "Non ça m'étonnerait :thumbsdown:",
      "Non mais je veux du beurre :thumbsdown:",
      "Heu........ Nope :thumbsdown:",
      "I don't think so :thumbsdown:",
      "Même pas dans tes rêves les plus fous :thumbsdown:",
      "Non :thumbsdown:",
      "Nope Nope Nope Nope :thumbsdown:"
    ]
    
  }
}
