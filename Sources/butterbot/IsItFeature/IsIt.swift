//
//  File.swift
//  butterbot
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation
import SlackKit
import RxSwift

struct IsIt: ButterFeature {
  func actions(for event: ButterEvent) -> [ButterAction] { return [] }
  func setup(database: Database) -> Observable<Bool> { return Observable.just(true) }
}


struct IsItAction: ButterAction {
  let priority = 80
  let event: ButterEvent
  let actionName = "IsItAction"
  
  
  var isValid: Bool {
    let parser = IsItParser(with: event)
    return parser.containsIsItPrefix
  }
  
  func execute() -> Observable<ButterMessage?> {
    let parser = IsItParser(with: event)
    let bMessage: ButterMessage
    guard let channelId = parser.event.channel?.id, parser.containsIsItPrefix else { return Observable.empty() }
    
    if parser.containsYesSuffix {
      bMessage = yesMessage(channel: channelId)
    } else if parser.containsNoSuffix {
      bMessage = noMessage(channel: channelId)
    } else {
      bMessage = (Int.randomPos % 2 > 0) ? yesMessage(channel: channelId) : noMessage(channel: channelId)
    }
    return Observable.just(bMessage)
  }
  
  
  func yesMessage(channel: String) -> ButterMessage {
    let message = IIL10n.yes.randomOne
    return ButterMessage(text: message, actionName: self.actionName, channelID: channel)
  }
  
  func noMessage(channel: String) -> ButterMessage {
    let message = IIL10n.not.randomOne
    return ButterMessage(text: message, actionName: self.actionName, channelID: channel)
  }
  
}
