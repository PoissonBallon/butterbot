//
//  ButterBot+SwiftyBeaver.swift
//  MySQL
//
//  Created by Allan Vialatte on 15/03/2018.
//

import SwiftyBeaver
#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

class HerokuConsoleDestination: BaseDestination {
  let console: ConsoleDestination
  override public var defaultHashValue: Int { return 4263 }
  
  required init(console: ConsoleDestination) {
    self.console = console
    super.init()
  }
  
  override public func send(_ level: SwiftyBeaver.Level, msg: String, thread: String,
                            file: String, function: String, line: Int, context: Any? = nil) -> String? {
    let _ = console.send(level, msg: "-------------------\n", thread: thread, file: file, function: function, line: line)
    let formattedString = console.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)
    if formattedString != nil {
      fflush(stdout)
    }
    
    return formattedString
  }
}
