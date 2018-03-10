//
//  Karma.swift
//  MySQL
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import SlackKit

class Karma {
  let database: Database
  let databaseTable: String = "Karma"
  
  init(with db:Database) {
    self.database = db
  }
  
  
  func event(event: Event) {
    
  }

}
