//
//  Butterbot+Message.swift
//  App
//
//  Created by Allan Vialatte on 02/06/2018.
//

import Foundation

struct ButterbotAttachmentField {
  public let title: String
  public let value: String
  public let short: Bool
}

struct ButterbotAttachment {
  public let title: String?
  public let text: String?
  public let fields: [ButterbotAttachmentField]?
}

struct ButterbotMessage {
  let text: String
  let attachments: [ButterbotAttachment]?
}
