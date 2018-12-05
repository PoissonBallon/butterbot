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
  var event: SlackEvent { get }
  func help(for botID:String) -> ButterbotAttachment?
  func execute(on container: Container) -> EventLoopFuture<[ButterbotMessage]>
}

