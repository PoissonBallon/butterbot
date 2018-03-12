//
//  ButterBot+Feature.swift
//  butterbot
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import SlackKit
import RxSwift

protocol ButterFeature {
  func setup(database: Database) -> Observable<Bool>
  func actions(for event: ButterEvent) -> [ButterAction]
}

protocol ButterAction {
  var priority: Int { get }
  var isValid: Bool { get }
  var event: ButterEvent { get }

  func execute() -> Observable<ButterMessage?>
}

