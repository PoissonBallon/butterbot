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
    guard let index = self.textToken.firstIndex(where: {$0 == target}) else { return nil }
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
    switch action {
    case .addOne(let target):     return target.contains(self.fromID) ? action : .cheater(target: target)
    case .addRandom(let target):  return target.contains(self.fromID) ? action : .cheater(target: target)
    default:                      return action
    }
  }
  
  func createAction(for target: String, and token: String) -> Action? {
    let tokenLower = token.lowercased()
    if KarmaFeatureToken.addPointToken.contains(tokenLower) { return Action.addOne(target: target) }
    if KarmaFeatureToken.removePointToken.contains(tokenLower) { return Action.removeOne(target: target) }
    if KarmaFeatureToken.randomRemovePointToken.contains(tokenLower) { return Action.removeRandom(target: target) }
    if KarmaFeatureToken.randomAddPointToken.contains(tokenLower) { return Action.addRandom(target: target) }
    return nil
  }
}

extension KarmaFeatureParser {
  
  enum Action {
    case addOne(target: String)
    case removeOne(target: String)
    case addRandom(target: String)
    case removeRandom(target: String)
    case cheater(target: String)
    
    var target: String {
      switch self {
      case .addOne(let target):       return target
      case .addRandom(let target):    return target
      case .removeOne(let target):    return target
      case .removeRandom(let target): return target
      case .cheater(let target):      return target
      }
    }
    
    var point: Int {
      switch self {
      case .addOne:       return 1
      case .addRandom:    return (try? (OSRandom().generate(Int.self) % 5)) ?? 1
      case .removeOne:    return -1
      case .removeRandom: return ((try? (OSRandom().generate(Int.self) % 5)) ?? 1) * -1
      case .cheater:      return -2
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
