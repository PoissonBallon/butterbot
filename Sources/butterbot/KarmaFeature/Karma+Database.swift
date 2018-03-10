//
//  KarmaFeature+Database.swift
//  MySQL
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import MySQL

struct KarmaRow: Codable, QueryParameter{
  let user: String
  let points: Int
}


extension Karma {
  
  func createTableIfNotExit() {
    let command = String(format: "CREATE TABLE %@ (user VARCHAR(30) NOT NULL PRIMARY KEY, points INT(6) NOT NULL)", self.databaseTable)
    let _ = try? self.database.pool.execute { try? $0.query(command) }
  }

  func addDatabasePoint(for user: String) throws -> Int {
    let command = String(format: "INSERT INTO %@ (user, points) VALUES('%@', 1) ON DUPLICATE KEY UPDATE points = points + 1;", self.databaseTable, user)
    let _ = try self.database.pool.execute { try $0.query(command) as QueryStatus }
    return try self.pointCount(for: user)
  }
  
  func removeDatabasePoint(for user: String) throws -> Int {
    let command = String(format: "INSERT INTO %@ (user, points) VALUES('%@', -1) ON DUPLICATE KEY UPDATE points = points - 1;", self.databaseTable, user)
    let _ = try self.database.pool.execute { try $0.query(command) as QueryStatus }
    return try self.pointCount(for: user)
  }
  
  func pointCount(for user: String) throws -> Int {
    let command = String(format: "SELECT * FROM %@ WHERE user = '%@';", self.databaseTable, user)
    let rows = try self.database.pool.execute { try $0.query(command) as [KarmaRow] }
    guard let item = rows.first else { return 0 }
    return item.points
  }
  
}
