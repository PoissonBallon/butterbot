//
//  Karma+Message.swift
//  butterbot
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation

extension Karma {
  
  func addPointMessage(point: Int, context: KarmaContext) throws {
    guard let mention = context.mentionID else { return }
    guard let channelId = context.event.channel?.id else { return }
    
    let message = "<@\(mention)> a [\(point) points]"
    try context.client.rtm?.sendMessage(message, channelID: channelId)
  }
  
  func removePointMessage(point: Int, context: KarmaContext) throws {
    guard let mention = context.mentionID else { return }
    guard let channelId = context.event.channel?.id else { return }
    
    let message = "<@\(mention)> a [\(point) points]"
    try context.client.rtm?.sendMessage(message, channelID: channelId)
  }

}
