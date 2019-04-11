//
//  ButterFeatureKarma.swift
//  ButterFeatureKarma
//
//  Created by Allan Vialatte on 11/04/2019.
//

import Foundation
import Butterbot
import Vapor
import Fluent

struct ButterFeatureKarma: ButterFeature {
  func configurePostgreSQL(_ migrations: inout MigrationConfig) {
    migrations.add(model: KarmaPoint.self, database: .psql)
  }

}
