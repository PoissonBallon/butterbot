//
//  SlackAuthController.swift
//  App
//
//  Created by Allan Vialatte on 17/05/2018.
//

import Foundation
import Vapor
import HTTP
import Leaf
import Fluent

//
//final class SlackAuthController {
//  
//  func oauthAuthorize(_ req:Request) throws -> EventLoopFuture<View> {
//    let slackClientID = Environment.slackClientID
//    let slackClientSecret = Environment.slackClientSecret
//    let code = try req.query.decode(SlackAuthCode.self)
//    let access = SlackAuthAccess(clientId: slackClientID, clientSecret: slackClientSecret, code: code.code, redirectURI: nil)
//    
//    return try req.client().get("https://slack.com/api/oauth.access") { (request) in
//      try request.query.encode(access)
//      }.flatMap { (response) -> EventLoopFuture<SlackAuthToken> in 
//        return try response.content.decode(SlackAuthToken.self)
//      } .flatMap { (authToken) -> EventLoopFuture<BotRegistration> in
//        return req.withPooledConnection(to: .psql) { (connection) -> EventLoopFuture<BotRegistration> in
//          return BotRegistration(with: authToken).create(on: connection).thenIfError { _ in
//            return BotRegistration(with: authToken).save(on: connection)
//          }
//        }
//      }.flatMap { _ in
//        let leaf = try req.make(LeafRenderer.self)
//        let context = [String: String]()
//        return leaf.render("success", context)
//    }
//  }
//  
//  func event(_ req: Request) throws -> EventLoopFuture<HTTPResponse> {
//    let logger = try req.make(Logger.self)
//    logger.info(req.debugDescription)
//    return req.content.get(String.self, at: "type").flatMap {
//      switch $0 {
//      case "url_verification":
//        return try self.challenge(req: req).mapIfError { _ in HTTPResponse(status: .noContent) }
//      case "event_callback":
//        return try self.eventCallback(req: req).mapIfError { _ in HTTPResponse(status: .noContent) }
//      default:
//        return req.eventLoop.newSucceededFuture(result: HTTPResponse(status: .notImplemented))
//      }
//    }
//  }
//  
//}
//
//extension SlackAuthController {
//  
//  func challenge(req: Request) throws -> EventLoopFuture<HTTPResponse> {
//    return try req.content.decode(SlackChallenge.self).map { HTTPResponse(status: .ok, body: HTTPBody(string: $0.challenge)) }
//  }
//  
//  func eventCallback(req: Request) throws -> EventLoopFuture<HTTPResponse> {
//    let bot = try req.make(Butterbot.self)
//    let logger = try? req.make(Logger.self)
//    
//    return try req.content.decode(SlackEvent.self).flatMap {
//      return bot.action(to: $0, on: req)
//      }.mapIfError {
//        logger?.report(error: $0)
//        return HTTPResponse(status: .noContent)
//    }
//  }
//}
//
//
//
