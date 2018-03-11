//
//  Karma+Action.swift
//  MySQL
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation

enum KarmaAction: FeatureAction {
  case addPoint(context: KarmaContext)
  case removePoint(context: KarmaContext)
  case leaderboard(context: KarmaContext)
}

extension KarmaAction {
  
  static func all(with context:KarmaContext) -> [KarmaAction] {
    return [
      .addPoint(context: context),
      .removePoint(context: context),
      .leaderboard(context: context)
    ]
  }
  
}

extension KarmaAction {
  var priority: Int {
    switch self {
    case .addPoint:     return 10
    case .removePoint:  return 10
    case .leaderboard:  return 9
    }
  }
}

extension KarmaAction {
  func isValid() -> Bool {
    switch self {
    case .addPoint(let context):     return self.addPointIsValid(context: context)
    case .removePoint(let context):  return self.removePointIsValid(context: context)
    case .leaderboard(let context):  return self.leaderboardIsValid(context: context)
    }
  }
  
  func execute() throws -> ButterMessage {
    switch self {
    case .addPoint(let context):     return try self.addPointExecute(context: context)
    case .removePoint(let context):  return try self.removePointExecute(context: context)
    case .leaderboard(let context):  return try self.leaderboardExecute(context: context)
    }
  }
}


fileprivate extension KarmaAction {
  
  func addPointIsValid(context: KarmaContext) -> Bool {
    guard let to = context.mentionID, let from = context.fromID, to != from else { return false }
    guard ((context.event.channel?.id) != nil) else { return false }
    guard context.isOpenChannel else { return false }
    guard context.containsAddSuffix else { return false}
    return true
  }
  
  func removePointIsValid(context: KarmaContext) -> Bool {
    guard let to = context.mentionID, let from = context.fromID, to != from else { return false }
    guard ((context.event.channel?.id) != nil) else { return false }
    guard context.isOpenChannel else { return false }
    guard context.containsRemoveSuffix else { return false}
    return true
  }
  
  func leaderboardIsValid(context: KarmaContext) -> Bool {
    guard ((context.event.channel?.id) != nil) else { return false }
    
    return context.isLeaderboard
  }
}

fileprivate extension KarmaAction {
  func addPointExecute(context: KarmaContext) throws -> ButterMessage  {
    guard let to = context.mentionID, let channelId = context.event.channel?.id else { throw KarmaError.errorToParseInformation }
    let point = try context.database.addPoint(for: to)
    let message = "\(KL10n.congrats.randomOne) [\(to) : \(point) points]"
    
    return ButterMessage(text: message, channelID: channelId)
  }
  
  func removePointExecute(context: KarmaContext) throws -> ButterMessage {
    guard let to = context.mentionID, let channelId = context.event.channel?.id else { throw KarmaError.errorToParseInformation }
    let point = try context.database.addPoint(for: to)
    let message = "\(KL10n.congrats.randomOne) [\(to) : \(point) points]"
    
    return ButterMessage(text: message, channelID: channelId)
  }
  
  func leaderboardExecute(context: KarmaContext) throws -> ButterMessage {
    guard let channelId = context.event.channel?.id else { throw KarmaError.errorToParseInformation }
    let rows = try context.database.topPoint()
    var message = "Top :sports_medal: :\n"
    rows.enumerated().forEach {
      message.append("\t \($0.offset). ")
      message.append("\($0.element.user) : \($0.element.points) points")
      if $0.offset == 0 { message.append(" :tada: ") }
      message.append("\n")
    }
    return ButterMessage(text: message, channelID: channelId)
  }
}

