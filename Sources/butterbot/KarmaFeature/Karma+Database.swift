//
//  KarmaFeature+Database.swift
//  MySQL
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import MySQL
import RxSwift

struct KarmaRow: Codable, QueryParameter{
  let user: String
  let points: Int
}

extension Karma {
  fileprivate static var databaseTable = "karma"
}


extension Database {
  
  func initKarmaTable() -> Observable<Database.Result<KarmaRow>> {
    let command = "CREATE TABLE \(Karma.databaseTable) (user VARCHAR(30) NOT NULL PRIMARY KEY, points INT(6) NOT NULL)"
    return self.query(command: command)
  }

  func addPoint(for user: String) -> Observable<Database.Result<KarmaRow>>{
    let command = "INSERT INTO \(Karma.databaseTable) (user, points) VALUES('\(user)', 1) ON DUPLICATE KEY UPDATE points = points + 1;"
    return self.query(command: command)
  }
  
  func removePoint(for user: String) -> Observable<Database.Result<KarmaRow>> {
    let command = "INSERT INTO \(Karma.databaseTable) (user, points) VALUES('\(user)', -1) ON DUPLICATE KEY UPDATE points = points - 1;"
    return self.query(command: command)
  }
  
  func countPoint(for user: String) -> Observable<Database.Result<KarmaRow>> {
    let command = "SELECT * FROM \(Karma.databaseTable) WHERE user = '\(user)';"
    return self.query(command: command)
  }
  
  func topPoint(with limit: Int) -> Observable<Database.Result<KarmaRow>> {
    let command = "SELECT * FROM \(Karma.databaseTable) ORDER BY points DESC LIMIT \(limit);"
    return self.query(command: command)
  }
}
