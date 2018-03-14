//
//  Database.swift
//  butterbot
//
//  Created by Allan Vialatte on 09/03/2018.
//

import Foundation
import MySQL
import RxSwift

class Database {
  let options: Database.Options
  
  init(with env: Environment) {
    self.options = Database.Options(with: env)
  }
  
  func query<T:Codable>(command: String) -> Observable<Database.Result<T>> {
    return Observable.create { [unowned self] (observer) in
      let pool = ConnectionPool(options: self.options)
      do {
        let tmp = try pool.execute({ (connection) -> Database.Result<T> in
          let queryResult:([T], QueryStatus) = try connection.query(command)
          return Database.Result(status: queryResult.1, result: queryResult.0)
        })
        observer.on(.next(tmp))
      } catch {
        observer.onError(error)
      }
      observer.on(.completed)
      return Disposables.create()
    }
  }
  
}

extension Database {
  struct Result<T> {
    let status: QueryStatus
    let result: [T]
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
