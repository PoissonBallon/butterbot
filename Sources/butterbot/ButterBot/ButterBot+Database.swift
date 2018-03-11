//
//  Database.swift
//  butterbot
//
//  Created by Allan Vialatte on 09/03/2018.
//

import Foundation
import MySQL

class Database {
  let pool: ConnectionPool
  
  init(with env: Environment) {
    let options = Database.Options(with: env)
    self.pool = ConnectionPool(options: options)
  }
  
  func information() {
    do {
      try pool.execute { (connection) -> Void in
        let status = try connection.query("SHOW DATABASES;") as QueryStatus
        print(status)
      }
    } catch {
      print(error)
    }
  }
}


extension Database {
  
  struct Options : ConnectionOption {
    let host: String
    let user: String
    let password: String
    let database: String
    let port: Int = 3306
    let timeout: Int = 10
    let omitDetailsOnError : Bool = false
    
    init(with env: Environment) {
      self.host = env.mysqlURL
      self.user = env.mysqlUser
      self.password = env.mysqlPass
      self.database = env.mysqlDBName
    }
  }
}
