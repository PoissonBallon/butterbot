
import Foundation
import SwiftyBeaver

let logger = SwiftyBeaver.self
logger.addDestination(ConsoleDestination())

let bot = try! ButterBot()
bot.setup()
bot.run()

RunLoop.main.run()
