//
//  Karma+Action.swift
//  MySQL
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation

extension Karma {
  
  func addPointAction(context: KarmaContext) throws {
    guard let to = context.mentionID, let from = context.fromID, to != from else { return }
    guard context.isOpenChannel else { return }
    guard context.containsAddSuffix else { return }
    
    let point = try self.addDatabasePoint(for: to)
    try self.addPointMessage(point: point, context: context)
  }
  
  func removePointAction(context: KarmaContext) throws {
    guard let to = context.mentionID, let from = context.fromID, to != from else { return }
    guard context.isOpenChannel else { return }
    guard context.containsRemoveSuffix else { return }
    
    let point = try self.removeDatabasePoint(for: to)
    try self.removePointMessage(point: point, context: context)
  }
  
}
