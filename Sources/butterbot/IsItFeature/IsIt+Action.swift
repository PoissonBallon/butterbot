//
//  IsIt+Action.swift
//  butterbot
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation
import Foundation

enum IsItAction: FeatureAction {
  case isIt(context: IsItContext)
}

extension IsItAction {
  
  static func all(with context:IsItContext) -> [FeatureAction] {
    return [IsItAction.isIt(context: context)]
  }
  
}

extension IsItAction {
  var priority: Int {
    switch self {
    case .isIt:         return 10
    }
  }
}

extension IsItAction {
  func isValid() -> Bool {
    switch self {
    case .isIt(let context):         return self.isItIsValid(context: context)
    }
  }
  
  func execute() throws -> ButterMessage {
    switch self {
    case .isIt(let context):         return try self.isItExecute(context: context)
    }
  }
}


fileprivate extension IsItAction {
  
  func isItIsValid(context: IsItContext) -> Bool {
    return context.containsIsItPrefix
  }
}

fileprivate extension IsItAction {
  func isItExecute(context: IsItContext) throws -> ButterMessage  {
    guard let channelId = context.event.channel?.id, context.containsIsItPrefix else { throw KarmaError.errorToParseInformation }
    
    if context.containsYesSuffix {
      return yesMessage(channel: channelId)
    } else if context.containsNoSuffix {
      return noMessage(channel: channelId)
    } else {
      return (Int.random % 2 > 0) ? yesMessage(channel: channelId) : noMessage(channel: channelId)
    }
  }
  
  func yesMessage(channel: String) -> ButterMessage {
    let message = IIL10n.yes.randomOne
    return ButterMessage(text: message, channelID: channel)
  }

  func noMessage(channel: String) -> ButterMessage {
    let message = IIL10n.not.randomOne
    return ButterMessage(text: message, channelID: channel)
  }

}

