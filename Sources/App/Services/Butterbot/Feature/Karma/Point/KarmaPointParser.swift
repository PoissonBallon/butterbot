//
//  File.swift
//  App
//
//  Created by Allan Vialatte on 27/09/2018.
//

import Foundation
import Vapor
import Random
import FluentPostgreSQL
import Regex

class KarmaFeatureParser {
  let event: SlackEvent
  let fromID: String
  let teamID: String
  let text: String
  var textToken: [String] = []
  
  init(with event: SlackEvent) {
    self.event = event
    self.teamID = event.teamId
    self.fromID = event.event.user
    self.text = event.event.text
  }
  
  func parse() -> [Action] {
    self.textToken = self.event.event.text.split(separator: " ").map { String($0) }
    let actions = self.findTargets().compactMap { self.findAction(for: $0) }.map { self.checkCheater(for: $0) }
    return actions
  }
  
  fileprivate func findTargets() -> [String] {
    let text = self.event.event.text
    guard let regex = try? Regex(pattern: "(#\\w+)|(<@\\w+>)", groupNames: ["things","user"]) else { return [] }
    let finded = regex.findAll(in: text)
    return finded.map { $0.matched }
  }
  
  fileprivate func findAction(for target: String) -> Action? {
    guard let index = self.textToken.index(where: {$0 == target}) else { return nil }
    if index < (self.textToken.count - 2) {
      if let action = self.createAction(for: target, and: self.textToken[index + 1]) {
        self.textToken.remove(at: index + 1)
        return action
      }
    }
    if index > 0 {
      if let action = self.createAction(for: target, and: self.textToken[index - 1]) {
        self.textToken.remove(at: index - 1)
        return action
      }
    }
    return nil
  }
  
  fileprivate func checkCheater(for action: Action) -> Action {
    switch action.type {
    case .addOne, .addRandom:     return action.target.contains(self.fromID) ? action : Action(target: action.target, type: .cheater)
    default:                      return action
    }
  }
  
  func createAction(for target: String, and token: String) -> Action? {
    let tokenLower = token.lowercased()
    if KarmaFeatureToken.addPointToken.contains(tokenLower) { return Action(target: target, type: .addOne) }
    if KarmaFeatureToken.removePointToken.contains(tokenLower) { return Action(target: target, type: .removeOne) }
    if KarmaFeatureToken.randomRemovePointToken.contains(tokenLower) { return Action(target: target, type: .addRandom) }
    if KarmaFeatureToken.randomAddPointToken.contains(tokenLower) { return Action(target: target, type: .removeRandom) }
    return nil
  }
}

extension KarmaFeatureParser {
  
  struct Action {
    let type: ActionType
    let target: String
    let point: Int
    let sentence: String
    
    init(target: String, type: ActionType) {
      self.type = type
      self.target = target
      self.point = type.point
      self.sentence = type.sentence
    }
  }
  
  enum ActionType {
    case addOne
    case addRandom
    case removeOne
    case removeRandom
    case cheater
    
    fileprivate var point: Int {
      switch self {
      case .addOne:       return 1
      case .addRandom:    return (try? (OSRandom().generate(Int.self) % 5)) ?? 1
      case .removeOne:    return -1
      case .removeRandom: return ((try? (OSRandom().generate(Int.self) % 5)) ?? 1) * -1
      case .cheater:      return -2
      }
    }
    
    fileprivate var sentence: String {
      switch self {
      case .addOne:       return KarmaPointSentence.congrats.random ?? ""
      case .addRandom:    return KarmaPointSentence.congrats.random ?? ""
      case .removeOne:    return KarmaPointSentence.reproves.random ?? ""
      case .removeRandom: return KarmaPointSentence.reproves.random ?? ""
      case .cheater:      return KarmaPointSentence.cheaters.random ?? ""
      }
    }
  }
}


struct KarmaFeatureToken {
  static let addPointToken    =            ["++", "merci", "thanks", ":+1:", ":thumbsup:", "+ 1"]
  static let removePointToken =            ["--", ":thumbsdown:", "- 1", "—", ":middle_finger:"]
  static let randomAddPointToken =         ["+?"]
  static let randomRemovePointToken =      ["-?"]
}
