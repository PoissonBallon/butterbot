//
//  KarmaBoardParser.swift
//  App
//
//  Created by Allan Vialatte on 28/09/2018.
//

import Foundation

struct KarmaBoardParser {
  let text: String
  let teamId: String
  let authedBot: String
  var textToken: [String] = []
  
  init(with event:SlackEvent) {
    self.text = event.event.text
    self.teamId = event.teamId
    self.textToken = event.event.text.split(separator: " ").map { String($0) }
    self.authedBot = event.authedUsers.first ?? ""
  }
  
  func parse() -> [Action] {
    guard self.textToken.count > 1, self.textToken.count < 3 else { return [] }
    guard self.textToken[0] == "<@\(self.authedBot)>" else { return [] }
    
    let actionVerb = self.textToken[1]
    var actionLength = 5
    if self.textToken.count > 2{ actionLength =  (Int(self.textToken[2]) ?? 5)}
    if actionVerb.lowercased() == "leaderboard" { return [Action(teamId: self.teamId, type: .leaderboard, length: actionLength)] }
    if actionVerb.lowercased() == "lastboard" { return [Action(teamId: self.teamId, type: .lastboard, length: actionLength)] }
    return []
  }
}


extension KarmaBoardParser {
  struct Action {
    let teamId: String
    let type: ActionType
    let length: Int
  }
}

enum ActionType {
  case leaderboard
  case lastboard
  
  var title: String {
    switch self {
    case .leaderboard:    return "Top :sports_medal: :"
    case .lastboard:      return "Last :thumbsdown: :"
    }
  }
}
