//
//  Error.swift
//  Async
//
//  Created by Allan Vialatte on 09/03/2018.
//

import Foundation

enum ButterError: Error {
  case envKeyMissing(key:String)
}
