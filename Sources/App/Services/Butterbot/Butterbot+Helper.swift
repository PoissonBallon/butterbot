//
//  Butterbot+Helper.swift
//  App
//
//  Created by Allan Vialatte on 02/06/2018.
//

import Foundation
import Vapor
import Fluent
import FluentSQL
import FluentPostgreSQL

extension Butterbot {
  static let slackChatPostMessageURL = "https://slack.com/api/chat.postMessage"
  static let color = "#DAE55C"
}

extension Butterbot {
  func sendMessage(message: ButterbotMessage?, event: SlackEvent, on container: Container) throws -> EventLoopFuture<HTTPResponse> {
    guard let butterMessage = message else { return container.eventLoop.newSucceededFuture(result: HTTPResponse(status: .ok)) }
    let slackMessage = self.createMessage(message: butterMessage, event: event)
    return self.askToken(for: event, on: container).flatMap { (token) -> EventLoopFuture<HTTPResponse> in
      try container.client().post(Butterbot.slackChatPostMessageURL) {
        try $0.content.encode(slackMessage)
        $0.http.headers.add(name: .authorization, value: "Bearer \(token)")
        $0.http.headers.add(name: .keepAlive, value: "timeout=2, max=1000")
        }.map { $0.http }
    }
  }
}


extension Butterbot {
  fileprivate func askToken(for event: SlackEvent, on container: Container) -> EventLoopFuture<String> {
    return container.withPooledConnection(to: .psql) { (connection) -> EventLoopFuture<String> in
      return BotRegistration
        .query(on: connection)
        .filter(\BotRegistration.teamId == event.teamId)
        .first().map { $0?.botAccessToken }
        .unwrap(or: ButterbotError.notRegister)
    }
  }
  
  fileprivate func createMessage(message: ButterbotMessage, event: SlackEvent) -> SlackConversMessage {
    let attachments = message.attachments?.compactMap { SlackConversAttachment(attachment: $0) }
    return SlackConversMessage(channel: event.event.channel, text: message.text, attachments: attachments)
  }
}


fileprivate extension SlackConversAttachment {
  fileprivate init(attachment: ButterbotAttachment) {
    self.text = attachment.text ?? ""
    self.title = attachment.title ?? ""
    self.color = Butterbot.color
    self.fields = attachment.fields?.compactMap { SlackConversAttachmentField(field: $0) }
  }
}

fileprivate extension SlackConversAttachmentField {
  fileprivate init(field: ButterbotAttachmentField) {
    self.short = field.short
    self.title = field.title
    self.value = field.value
  }
}
