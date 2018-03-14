//
//  Environment.swift
//  Async
//
//  Created by Allan Vialatte on 09/03/2018.
//

import Foundation

struct Environment {
  let slackClientID: String
  let slackClientSecret: String
  let slackVerifToken: String
  let slackBotToken: String
  let mysqlURL: String
  let mysqlUser: String
  let mysqlPass: String
  let mysqlDBName: String
  
  init() throws {
    self.slackClientID =      try Environment.getEnvValue(key: "SLACK_CLIENT_ID")
    self.slackClientSecret =  try Environment.getEnvValue(key: "SLACK_CLIENT_SECRET")
    self.slackVerifToken =    try Environment.getEnvValue(key: "SLACK_VERIF_TOKEN")
    self.slackBotToken =      try Environment.getEnvValue(key: "SLACK_BOT_TOKEN")
    self.mysqlURL =           try Environment.getEnvValue(key: "MYSQL_URL")
    self.mysqlUser =          try Environment.getEnvValue(key: "MYSQL_USER")
    self.mysqlPass =          try Environment.getEnvValue(key: "MYSQL_PASS")
    self.mysqlDBName =        try Environment.getEnvValue(key: "MYSQL_DBNAME")
  }
  
}

extension Environment {
  
  fileprivate static func getEnvValue(key: String) throws -> String {
    guard let value = ProcessInfo.processInfo.environment[key] else {
      throw ButterError.envKeyMissing(key: key)
    }
    
    return value
  }
  
}
