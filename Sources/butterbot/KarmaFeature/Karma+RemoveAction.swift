//
//  KarmaAdd.swift
//  MySQL
//
//  Created by Allan Vialatte on 12/03/2018.
//

import Foundation
import RxSwift

struct KarmaRemoveAction: ButterAction {
  let priority = 100
  let event: ButterEvent
  let actionName = "KarmaRemoveAction"
  
  
  var isValid: Bool {
    let parser = KarmaParser(with: event)
    guard let to = parser.target, let from = parser.fromUser, to != from else { return false }
    guard ((parser.event.channel?.id) != nil) else { return false }
    guard parser.isOpenChannel else { return false }
    guard parser.containsRemoveSuffix else { return false }
    
    return true
  }
  
  func execute() -> Observable<ButterMessage?> {
    let parser = KarmaParser(with: event)
    guard let target = parser.target, let channelId = parser.event.channel?.id else { return Observable.error(KarmaError.errorToParseInformation) }
    
    return event.database
      .removePoint(for: target)
      .concatMap { _ in return self.event.database.countPoint(for: target) }
      .flatMap { (result) -> Observable<ButterMessage?> in
        let point = result.result.first?.points ?? 0
        let message = "\(KL10n.reproves.randomOne) [\(target) : \(point) points]"
        
        let bMessage = ButterMessage(text: message, actionName: self.actionName, channelID: channelId)
        return Observable.just(bMessage)
    }
  }
}

