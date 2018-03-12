//
//  Karma.swift
//  MySQL
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import SlackKit
import RxSwift

struct Karma: ButterFeature {
  
  func actions(for event: ButterEvent) -> [ButterAction] {
    
    return [
      KarmaAddAction(event: event),
      KarmaRemoveAction(event: event),
      KarmaLeaderboardAction(event: event)
    ]
  }
  
  func setup(database: Database) -> Observable<Bool> {
    return database
      .initKarmaTable()
      .flatMap { _ in Observable.just(true) }
  }
}
