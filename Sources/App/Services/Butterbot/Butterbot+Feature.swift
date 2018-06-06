//
//  Butterbot+Feature.swift
//  App
//
//  Created by Allan Vialatte on 24/05/2018.
//

import Foundation
import Service
import Vapor

protocol ButterbotFeature {
  var priority: Int { get }
  var event: SlackEvent { get set}
  var isValid: Bool { get }
  func execute(on container: Container) -> EventLoopFuture<ButterbotMessage?>
}

