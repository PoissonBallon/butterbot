//
//  Foundation+Butter.swift
//  MySQL
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation

extension Int {

  static func randomUniform(_ min: Int, _ max: Int) -> Int {
    #if os(Linux)
    return Int(random() % max) + min
    #else
    return Int(arc4random_uniform(UInt32(max)) + UInt32(min))
    #endif
  }
  
  static var random: Int {
    return Int.randomUniform(0, Int(UINT32_MAX))
  }

}

extension Array {
  var randomOne: Element  {
    return self[Int.randomUniform(0, self.count)]
  }
}
