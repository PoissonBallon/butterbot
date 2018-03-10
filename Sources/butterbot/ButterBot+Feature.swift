//
//  ButterBot+Feature.swift
//  butterbot
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import SlackKit

protocol Feature {
  func eventReceive(event: Event, client: ClientConnection) -> Void
}
