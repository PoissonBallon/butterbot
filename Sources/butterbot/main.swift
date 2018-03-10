import SlackKit
import MySQL
import Foundation

let slackKit = SlackKit()
let env = try! Environment()
let database = Database(with: env)
let karma = Karma(with: database)


karma.createTableIfNotExit()
slackKit.addRTMBotWithAPIToken(env.slackBotToken)

slackKit.notificationForEvent(.hello) { (event, _) in
  print(event)
}

slackKit.notificationForEvent(.channelJoined) { (event, _) in
  print(event)
}

slackKit.notificationForEvent(.message) { [unowned karma] (event, connection) in
  print(event)
  karma.event(event: event)
}


RunLoop.main.run()
