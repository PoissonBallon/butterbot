
import Foundation
import SwiftyBeaver

let logger = SwiftyBeaver.self
logger.addDestination(HerokuConsoleDestination(console: ConsoleDestination()))

let bot = try! ButterBot()
bot.setup()
bot.run()

RunLoop.main.run()
