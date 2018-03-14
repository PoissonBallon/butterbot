//
//  Butterbot+Message.swift
//  MySQL
//
//  Created by Allan Vialatte on 11/03/2018.
//

import Foundation
import SlackKit
import RxSwift

struct ButterMessage {
  let text: String
  let actionName: String
  let channelID: String
}

extension ButterBot {
  func sendMessage(message: ButterMessage?) {
    guard let message = message else { return }
    try? self.slackKit.rtm?.sendMessage(message.text, channelID: message.channelID)
  }
  
  func sendWebMessag(message: ButterMessage?) -> Observable<Bool> {
    guard let message = message else { return Observable.just(false) }
    
    return Observable.create { [unowned self] (observer) -> Disposable in
      self.slackKit.webAPI?.sendMessage(channel: message.channelID, text: message.text, escapeCharacters: false, username: nil, asUser: true, parse: nil, linkNames: nil, attachments: nil, unfurlLinks: nil, unfurlMedia: nil, iconURL: nil, iconEmoji: nil, success: { (ts, channel) in
        observer.onNext(true)
      }, failure: { (error) in
        observer.onError(error)
      })
      return Disposables.create()
    }
  }
}
