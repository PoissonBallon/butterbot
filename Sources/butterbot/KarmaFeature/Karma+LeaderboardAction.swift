//
//  KarmaAdd.swift
//  MySQL
//
//  Created by Allan Vialatte on 12/03/2018.
//

import Foundation
import RxSwift

struct KarmaLeaderboardAction: ButterAction {
  let priority = 100
  let event: ButterEvent
  let actionName = "KarmaLeaderboardAction"
  
  
  var isValid: Bool {
    let parser = KarmaParser(with: event)
    guard parser.isLeaderboard else { return false }
    guard parser.countComponents == 2 else { return false }
    guard let target = parser.target else { return false }
    guard let bot = parser.butterbotUser else { return false }
    guard target == bot else { return false }
    return true
  }
  
  func execute() -> Observable<ButterMessage?> {
    let parser = KarmaParser(with: event)
    
    guard let channelId = parser.event.channel?.id else { return Observable.error(KarmaError.errorToParseInformation) }
    
    return event.database.topPoint()
      .flatMap { (result) -> Observable<ButterMessage?> in

        let rows = result.result
        var message = "Top :sports_medal: :\n"
        rows.enumerated().forEach {
          message.append("\t \($0.offset). ")
          message.append("\($0.element.user) : \($0.element.points) points")
          if $0.offset == 0 { message.append(" :tada: ") }
          message.append("\n")
        }
        let bMessage = ButterMessage(text: message, actionName: self.actionName, channelID: channelId)
        return Observable.just(bMessage)
    }
  }
}

