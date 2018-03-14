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
        let message = "Top :sports_medal: :\n"
        
        let users = rows.filter { $0.user.contains("<@")}
        let things = rows.filter{ $0.user.contains("<@") == false }
        var usersAttachValues = ""
        var thingsAttachValues = ""
        
        users.enumerated().forEach {
          usersAttachValues.append("\($0.offset + 1). ")
          usersAttachValues.append("\($0.element.user) : \($0.element.points) points")
          if $0.offset == 0 { usersAttachValues.append(" :tada: ") }
          usersAttachValues.append("\n")
        }
        
        things.enumerated().forEach {
          thingsAttachValues.append("\($0.offset + 1). ")
          thingsAttachValues.append("\($0.element.user) : \($0.element.points) points")
          if $0.offset == 0 { thingsAttachValues.append(" :tada: ") }
          thingsAttachValues.append("\n")
        }

        let userFields = AttachmentField(title: "Users :", value: usersAttachValues, short: true)
        let thingsFields = AttachmentField(title: "Things :", value: thingsAttachValues, short: true)
        let attachment = KarmaLeaderboardAction.generateAttachments(title: "", fields: [userFields,thingsFields])
        
        let bMessage = ButterMessage(text: message, actionName: self.actionName, attachments: [attachment], channelID: channelId)
        return Observable.just(bMessage)
    }
  }
  
  static func generateAttachments(title: String, fields: [AttachmentField]) -> Attachment {
    return Attachment(
      fallback: title, title: title, callbackID: nil, type: nil,
      colorHex: "#DAE55C", pretext: nil, authorName: nil, authorLink: nil,
      authorIcon: nil, titleLink: nil, text: nil, fields: fields,
      actions: nil, imageURL: nil, thumbURL: nil, footer: nil,
      footerIcon: nil, ts: nil, markdownFields: nil)
  }
}

