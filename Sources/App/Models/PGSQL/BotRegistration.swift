//
//  SlackRegister.swift
//  App
//
//  Created by Allan Vialatte on 18/05/2018.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct BotRegistration: Content, PostgreSQLModel {
  
  var id: Int?
  let accessToken: String
  let scope: String
  let teamName: String
  let teamId: String
  let botUserId: String
  let botAccessToken: String
  
  init(with authToken: SlackAuthToken) {
    self.id = nil
    self.accessToken = authToken.accessToken
    self.scope = authToken.scope
    self.teamName = authToken.teamName
    self.teamId = authToken.teamId
    self.botUserId = authToken.bot.botUserId
    self.botAccessToken = authToken.bot.botAccessToken
  }
}

extension BotRegistration: Migration {}
