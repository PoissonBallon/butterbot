//
//  Karma.swift
//  MySQL
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import SlackKit

class Karma: Feature {
  let database: Database
  static let databaseTable: String = "karma"
  
  
  required init(with db:Database) {
    self.database = db
    self.database.initKarmaTable()
  }
  
  func eventReceive(event: Event, client: ClientConnection) -> ButterMessage? {
    let context = KarmaContext(event: event, client: client, database: database)
    let actions = KarmaAction.all(with: context).sorted { $0.priority > $1.priority }
    let action = actions.first { $0.isValid() }
    do { return try action?.execute() }
    catch { return self.errorMessage(error: error, context: context) }
  }
  
  func errorMessage(error: Error, context: KarmaContext) -> ButterMessage? {
    guard let channelId = context.event.channel?.id else { return nil }
    let message = "Butterbot failed : \(error)"
    return ButterMessage(text: message, channelID: channelId)
  }
}
