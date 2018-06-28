//
//  KarmaPoint.swift
//  App
//
//  Created by Allan Vialatte on 24/05/2018.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct KarmaPoint: Content, PostgreSQLModel {
  var id: Int?
  var target: String
  var point: Int
  var teamId: String

  init(target: String, point: Int, teamId: String) {
    self.id = nil
    self.target = target
    self.point = point
    self.teamId = teamId
  }

}

extension KarmaPoint: Migration {}

extension KarmaPoint {
  func willCreate(on conn: PostgreSQLConnection) throws -> EventLoopFuture<KarmaPoint> {
    print(self)
    return Future.map(on: conn) { self }
  }
}
