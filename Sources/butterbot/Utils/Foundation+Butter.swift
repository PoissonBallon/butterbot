//
//  Foundation+Butter.swift
//  MySQL
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation

extension Array {
  var randomOne: Element  {
    return self[Int(arc4random_uniform(UInt32(self.count)))]
  }
}
