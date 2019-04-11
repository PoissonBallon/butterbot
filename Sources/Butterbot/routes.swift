import Routing
import Vapor

//
//public func routes(_ router: Router) throws {
//  let webController = WebController()
//  let slackAuthController = SlackAuthController()
//  
//  router.get("", use: webController.index)
//  router.group("slack") { (subRouter) in
//    subRouter.get("/oauth/authorize", use: slackAuthController.oauthAuthorize)
//    subRouter.post("/event", use: slackAuthController.event)
//  }
//}
