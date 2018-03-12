//
//  IsIt+Context.swift
//  butterbot
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation

import SlackKit

struct IsItParser {
  let event: Event
  
  init(with event: ButterEvent) {
    self.event = event.event
  }
}

extension IsItParser {
  static let isItPrefix = "Est-ce qu"
  static let yesSuffix = "-y"
  static let noSuffix = "-n"

}

extension IsItParser {
  
  var containsIsItPrefix: Bool {
    guard let text = event.text?.lowercased() else { return false }
    return text.contains(IsItParser.isItPrefix.lowercased())
  }
  
  var containsYesSuffix: Bool {
    guard let text = event.text else { return false }
    return text.contains(IsItParser.yesSuffix)
  }
  
  var containsNoSuffix: Bool {
    guard let text = event.text else { return false }
    return text.contains(IsItParser.noSuffix)
  }
  
}
