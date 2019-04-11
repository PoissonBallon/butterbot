//
//  SlackRegister.swift
//  App
//
//  Created by Allan Vialatte on 18/05/2018.
//

import Foundation
import Vapor
import FluentPostgreSQL
//
//struct BotRegistration: Content, Model {
//  typealias ID = String
//  
//  typealias Database = PostgreSQLDatabase
//  static var idKey: WritableKeyPath<BotRegistration, String?> { return \.teamId }
//
//  var teamId: String?
//  var accessToken: String
//  var scope: String
//  var teamName: String
//  var botUserId: String
//  var botAccessToken: String
//  
//  init(with authToken: SlackAuthToken) {
//    self.accessToken = authToken.accessToken
//    self.scope = authToken.scope
//    self.teamName = authToken.teamName
//    self.teamId = authToken.teamId
//    self.botUserId = authToken.bot.botUserId
//    self.botAccessToken = authToken.bot.botAccessToken
//  }
//}
//
//extension BotRegistration: Migration {}
