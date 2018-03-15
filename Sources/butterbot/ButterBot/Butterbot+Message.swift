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
  let attachments: [Attachment]?
  let channelID: String
}

extension ButterBot {
  
  func sendWebMessag(message: ButterMessage?) -> Observable<ButterMessage> {
    guard let message = message else { return Observable.empty() }
    
    return Observable.create { [unowned self] (observer) -> Disposable in
      self.slackKit.webAPI?.sendMessage(channel: message.channelID,
                                        text: message.text,
                                        username: nil,
                                        asUser: true,
                                        parse: nil,
                                        linkNames: nil,
                                        attachments: message.attachments,
                                        unfurlLinks: nil,
                                        unfurlMedia: nil,
                                        iconURL: nil,
                                        iconEmoji: nil,
                                        success: { (ts, channel) in
        observer.onNext(message)
      }, failure: { (error) in
        observer.onError(error)
      })
      return Disposables.create()
    }
  }
}
