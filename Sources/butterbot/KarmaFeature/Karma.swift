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
  let databaseTable: String = "Karma"
  
  init(with db:Database) {
    self.database = db
    self.createTableIfNotExit()
  }
  
  func eventReceive(event: Event, client: ClientConnection) -> Void {
    let context = KarmaContext(event: event, client: client)
    
    do {
      try addPointAction(context: context)
      try removePointAction(context: context)
    } catch {
      print(error)
    }
  }
  
  
}
