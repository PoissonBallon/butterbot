import SlackKit
import MySQL
import Foundation

let bot = SlackKit()
let env: Environment
let database: Database

do {
  env = try Environment()
} catch {
  fatalError(error.localizedDescription)
}

database = Database(with: env)
database.information()
//bot.addRTMBotWithAPIToken(slackBotToken)
//// Register for event notifications
//
//bot.notificationForEvent(.hello) { (event, message) in
//  if let channelID = event.channel?.id {
//    try? bot.rtm?.sendMessage("I am alive", channelID: channelID)
//  }
//}
//
//bot.notificationForEvent(.message) { (event, _) in
//  print(event.message)
//  if let channelID = event.channel?.id {
//    try? bot.rtm?.sendMessage("I am alive", channelID: channelID)
//  }
//}

RunLoop.main.run()
