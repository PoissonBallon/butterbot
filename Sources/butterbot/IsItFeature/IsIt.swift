//
//  File.swift
//  butterbot
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation
import SlackKit

class IsIt: Feature {
  
  func eventReceive(event: Event, client: ClientConnection) -> ButterMessage? {
    let context = IsItContext(event: event, client: client)
    let actions = IsItAction.all(with: context).sorted { $0.priority > $1.priority }
    let action = actions.first { $0.isValid() }
    do { return try action?.execute() }
    catch { return self.errorMessage(error: error, context: context) }
  }
  
  func errorMessage(error: Error, context: IsItContext) -> ButterMessage? {
    guard let channelId = context.event.channel?.id else { return nil }
    let message = "Butterbot failed : \(error)"
    return ButterMessage(text: message, channelID: channelId)
  }
}
