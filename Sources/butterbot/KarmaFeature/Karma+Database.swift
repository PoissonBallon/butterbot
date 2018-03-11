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


extension Database {
  
  func initKarmaTable() {
    let command = "CREATE TABLE \(Karma.databaseTable) (user VARCHAR(30) NOT NULL PRIMARY KEY, points INT(6) NOT NULL)"
    let _ = try? self.pool.execute { try? $0.query(command) }
  }

  func addPoint(for user: String) throws -> Int {
    let command = "INSERT INTO \(Karma.databaseTable) (user, points) VALUES('\(user)', 1) ON DUPLICATE KEY UPDATE points = points + 1;"
    let _ = try self.pool.execute { try $0.query(command) as QueryStatus }
    return try self.countPoint(for: user)
  }
  
  func removePoint(for user: String) throws -> Int {
    let command = "INSERT INTO \(Karma.databaseTable) (user, points) VALUES('\(user)', -1) ON DUPLICATE KEY UPDATE points = points - 1;"
    let _ = try self.pool.execute { try $0.query(command) as QueryStatus }
    return try self.countPoint(for: user)
  }
  
  func countPoint(for user: String) throws -> Int {
    let command = "SELECT * FROM \(Karma.databaseTable) WHERE user = '\(user)';"
    let rows = try self.pool.execute { try $0.query(command) as [KarmaRow] }
    guard let item = rows.first else { return 0 }
    return item.points
  }
  
  func topPoint() throws -> [KarmaRow] {
    let limit = 25
    let command = "SELECT * FROM \(Karma.databaseTable) ORDER BY points DESC LIMIT \(limit);"
    let rows = try self.pool.execute { try $0.query(command) as [KarmaRow] }
    return rows
  }
}
