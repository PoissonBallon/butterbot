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
    
    let message = "Top :sports_medal: :\n"
    var fields = [AttachmentField]()

    return self.executeUser(parser: parser)
      .flatMap { (field) -> Observable<AttachmentField> in
        fields.append(field)
        return self.executeThings(parser: parser)
      }.flatMap { (field) -> Observable<ButterMessage?> in
        fields.append(field)
        let attachments = KarmaLeaderboardAction.makeAttachments(title: "", fields: fields)
        let bMessage = ButterMessage(text: message, actionName: self.actionName, attachments: [attachments], channelID: channelId)
        return Observable.just(bMessage)
    }
  }
  
  func executeThings(parser: KarmaParser) -> Observable<AttachmentField> {
    return event.database
      .topThingsPoint(with: parser.leaderboardCount)
      .flatMap { (result) -> Observable<AttachmentField> in
        let rows = result.result
        let attachment = KarmaLeaderboardAction.makeField(from: Array(rows), with: "Things")
        return Observable.just(attachment)
    }
  }
  
  func executeUser(parser: KarmaParser) -> Observable<AttachmentField> {
    return event.database
      .topUsersPoint(with: parser.leaderboardCount)
      .flatMap { (result) -> Observable<AttachmentField> in
        let rows = result.result
        let attachment = KarmaLeaderboardAction.makeField(from: Array(rows), with: "Users")
        return Observable.just(attachment)
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

