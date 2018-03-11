//
//  IsIt+Context.swift
//  butterbot
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation

import SlackKit

struct IsItContext {
  let event: Event
  let client: ClientConnection
}

extension IsItContext {
  static let isItPrefix = "Est-ce qu"
  static let yesSuffix = "-y"
  static let noSuffix = "-n"

}

extension IsItContext {
  
  var containsIsItPrefix: Bool {
    guard let text = event.text else { return false }
    return text.contains(IsItContext.isItPrefix)
  }
  
  var containsYesSuffix: Bool {
    guard let text = event.text else { return false }
    return text.contains(IsItContext.yesSuffix)
  }
  
  var containsNoSuffix: Bool {
    guard let text = event.text else { return false }
    return text.contains(IsItContext.noSuffix)
  }
  
}
