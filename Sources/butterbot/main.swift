
import Foundation

let bot = try! ButterBot()

bot.listen(event: .message)
RunLoop.main.run()
