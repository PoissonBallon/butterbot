import Butterbot
import Foundation

do {
  let butterbot = try Butterbot()
  try butterbot.configure()
  try butterbot.launch()
} catch {
  print(error)
  exit(1)
}
