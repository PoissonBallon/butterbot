//
//  Butterbot+Feature.swift
//  App
//
//  Created by Allan Vialatte on 24/05/2018.
//

import Foundation
import Service
import Vapor
import Fluent

public protocol ButterFeature {
  func configurePostgreSQL(_ migrations: inout MigrationConfig)
}

public protocol ButterResult {
  
}
