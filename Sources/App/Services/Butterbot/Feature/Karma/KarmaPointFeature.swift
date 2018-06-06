//
//  KarmaFeature.swift
//  App
//
//  Created by Allan Vialatte on 24/05/2018.
//

import Foundation
import Vapor
import Random
import FluentPostgreSQL

struct KarmaPointFeature: ButterbotFeature {
  
  public let priority: Int = 750
  public var event: SlackEvent
  public var isValid: Bool = true
  fileprivate var parser: KarmaFeatureParser
  
  
 init?(with event: SlackEvent) {
    guard let parser = KarmaFeatureParser(with: event) else { return nil }
    self.event = event
    self.parser = parser
  }
  
  func execute(on container: Container) -> EventLoopFuture<ButterbotMessage?> {
    return self.executeKarmaPoint(on: container)
  }  
}

extension KarmaPointFeature {
    
  fileprivate func executeKarmaPoint(on container: Container) -> EventLoopFuture<ButterbotMessage?> {
    return container.withPooledConnection(to: .psql) { (connection) -> EventLoopFuture<KarmaPoint> in
      return try connection.query(KarmaPoint.self)
        .filter(\KarmaPoint.target == self.parser.target)
        .filter(\KarmaPoint.teamId == self.parser.teamId)
        .first()
        .flatMap {
          var karmaPoint = $0 ?? KarmaPoint(target: self.parser.target, point: 0, teamId: self.parser.teamId)
          if self.parser.isCheater { karmaPoint.point = (karmaPoint.point - 2) }
          else if self.parser.containsAddSuffix { karmaPoint.point = (karmaPoint.point + 1)}
          else if self.parser.containsRemoveSuffix { karmaPoint.point = (karmaPoint.point - 1)}
          return karmaPoint.save(on: connection)
      }
      }.map { (karmaPoint) -> ButterbotMessage? in
        var sentence: String?
        if self.parser.isCheater { sentence = L10n.cheaters.random }
        else if self.parser.containsAddSuffix { sentence = L10n.congrats.random }
        else if self.parser.containsRemoveSuffix { sentence = L10n.reproves.random }
        let text = "\(sentence ?? "") [\(karmaPoint.target) : \(karmaPoint.point) points]"
        let message = ButterbotMessage(text: text, attachments: nil)
        return message
    }
  }
  
  
}

extension KarmaPointFeature {
  
  struct KarmaFeatureParser {
    var target: String
    var from: String
    var containsAddSuffix: Bool
    var containsRemoveSuffix: Bool
    var teamId: String
    var isCheater: Bool
    static let addPointSuffixes =     ["++", "+= 1", "+ 1", ":+1:"]
    static let removePointSuffixes =  ["--", "-= 1", "- 1", "—"]
    
    init?(with event: SlackEvent) {
      let text = event.event.text
      guard let target = text.components(separatedBy: " ").first else { return nil }
      guard target.first == "@" || target.first == "#" || target.first == "<" else { return nil }
      
      self.target = target
      self.from = event.event.user
      self.teamId = event.teamId
      self.isCheater = (self.target.contains(self.from))
      self.containsAddSuffix = !KarmaFeatureParser.addPointSuffixes.filter { text.contains($0) }.isEmpty
      self.containsRemoveSuffix = !KarmaFeatureParser.removePointSuffixes.filter { text.contains($0) }.isEmpty
      if (self.containsAddSuffix || self.containsRemoveSuffix) == false { return nil }
    }
  }
}

extension KarmaPointFeature {
  enum KarmaFeatureError: Error {
    case parserFailed
  }
}

extension KarmaPointFeature {
  struct L10n {
    static let congrats = [
      "Félicitation :thumbsup:",
      "C'est la fête du beurre !!!",
      "Owy !!!",
      "Bravo :clap:",
      "The best :thumbsup:",
      "Respect ! :thumbsup:",
      "Congratulation ! :thumbsup:",
      "To infinity and beyond ! :rocket:",
      "And up you go ! :top:",
      "Yeah ! :partyparrot:"
    ]
    
    static let reproves = [
      "Privé de beurre !!",
      "Sorry about that :(",
      "Sniff :sad:",
      "What is my purpose ? :cry:",
      "Tu l'as mérité",
      "Dans tes dents ! :troll:",
      "Hahahaha ! :joy:",
      "Damn... :fearfull:",
      "Wasted ! :skull:",
      "Ok... :neutral_face:",
      "Oh god why... :weary:"
    ]
    
    static let cheaters = [
      "C'est pas joli joli :rage:",
      "Tu te crois malin ? :rage:",
      "On peut tromper une personne mille fois. On peut tromper mille personne une fois. Mais on ne peut pas tromper mille personnes, mille fois. :innocent:"
    ]
    
  }
  
}
