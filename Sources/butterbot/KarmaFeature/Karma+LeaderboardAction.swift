//
//  KarmaAdd.swift
//  MySQL
//
//  Created by Allan Vialatte on 12/03/2018.
//

import Foundation
import RxSwift
import SlackKit

struct KarmaLeaderboardAction: ButterAction {
  let priority = 100
  let event: ButterEvent
  let actionName = "KarmaLeaderboardAction"
  
  
  var isValid: Bool {
    let parser = KarmaParser(with: event)
    guard parser.isLeaderboard else { return false }
    guard parser.countComponents <= 3 else { return false }
    guard let target = parser.target else { return false }
    guard let bot = parser.butterbotUser else { return false }
    guard target == bot else { return false }
    return true
  }
  
  func execute() -> Observable<ButterMessage?> {
    let parser = KarmaParser(with: event)
    
    guard let channelId = parser.event.channel?.id else { return Observable.error(KarmaError.errorToParseInformation) }
    
    return event.database.topPoint(with: parser.leaderboardCount)
      .flatMap { (result) -> Observable<ButterMessage?> in
        
        let rows = result.result
        let count = parser.leaderboardCount
        let message = "Top :sports_medal: :\n"
        
        let users = rows.filter { $0.user.contains("<@")}.prefix(count)
        let things = rows.filter{ $0.user.contains("<@") == false }.prefix(count)
        
        let fields = [
          KarmaLeaderboardAction.makeField(from: Array(users), with: "Users"),
          KarmaLeaderboardAction.makeField(from: Array(things), with: "Things")
        ]
        
        let attachments = KarmaLeaderboardAction.makeAttachments(title: "", fields: fields)
        
        let bMessage = ButterMessage(text: message, actionName: self.actionName, attachments: [attachments], channelID: channelId)
        return Observable.just(bMessage)
    }
  }
  
  static func makeField(from list:[KarmaRow], with title: String) -> AttachmentField {
    var values = ""
    
    list.enumerated().forEach {
      values.append("\($0.offset + 1). ")
      values.append("\($0.element.user) : \($0.element.points) points")
      if $0.offset == 0 { values.append(" :tada: ") }
      values.append("\n")
    }
    
    return AttachmentField(title: "\(title) :", value: values, short: true)
    
  }
  
  static func makeAttachments(title: String, fields: [AttachmentField]) -> Attachment {
    return Attachment(
      fallback: title, title: title, callbackID: nil, type: nil,
      colorHex: "#DAE55C", pretext: nil, authorName: nil, authorLink: nil,
      authorIcon: nil, titleLink: nil, text: nil, fields: fields,
      actions: nil, imageURL: nil, thumbURL: nil, footer: nil,
      footerIcon: nil, ts: nil, markdownFields: nil)
  }
}

