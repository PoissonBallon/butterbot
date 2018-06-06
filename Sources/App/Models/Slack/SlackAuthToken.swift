//
//  SlackAuthToken.swift
//  App
//
//  Created by Allan Vialatte on 17/05/2018.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct SlackAuthTokenBot: Content  {
  let botUserId: String
  let botAccessToken: String

  enum CodingKeys: String, CodingKey {
    case botUserId = "bot_user_id"
    case botAccessToken = "bot_access_token"
  }
}


struct SlackAuthToken: Content  {
  let accessToken: String
  let scope: String
  let teamName: String
  let teamId: String
  let bot: SlackAuthTokenBot
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case scope = "scope"
    case teamName = "team_name"
    case teamId = "team_id"
    case bot = "bot"
  }
}
