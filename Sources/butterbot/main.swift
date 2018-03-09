import SlackKit
import Foundation

let bot = SlackKit()
let slackBotToken: String = ProcessInfo.processInfo.environment["SLACK_BOT_TOKEN"] ?? ""

bot.addRTMBotWithAPIToken(slackBotToken)
// Register for event notifications

bot.notificationForEvent(.hello) { (event, message) in
  if let channelID = event.channel?.id {
    try? bot.rtm?.sendMessage("I am alive", channelID: channelID)
  }
}

bot.notificationForEvent(.message) { (event, _) in
  print(event.message)
  if let channelID = event.channel?.id {
    try? bot.rtm?.sendMessage("I am alive", channelID: channelID)
  }
}

RunLoop.main.run()
