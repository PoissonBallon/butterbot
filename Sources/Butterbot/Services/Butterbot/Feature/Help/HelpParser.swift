//
//  HelpParser.swift
//  App
//
//  Created by Allan Vialatte on 05/12/2018.
//

import Foundation

//struct HelpParser {
//  let text: String
//  let teamId: String
//  let authedBot: String
//  var textToken: [String] = []
//  
//  init(with event:SlackEvent) {
//    self.text = event.event.text
//    self.teamId = event.teamId
//    self.textToken = event.event.text.split(separator: " ").map { String($0) }
//    self.authedBot = event.authedUsers.first ?? ""
//  }
//  
//  func parse() -> [Action] {
//    guard self.textToken.count == 2 else { return [] }
//    guard self.textToken[0] == "<@\(self.authedBot)>" else { return [] }
//    guard self.textToken[1].lowercased() == "help" else { return [] }
//
//    return [Action(teamId: self.teamId, authedBot: self.authedBot)]
//  }
//}
//
//
//extension HelpParser {
//  struct Action {
//    let teamId: String
//    let authedBot: String
//  }
//}
