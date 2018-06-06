//
//  SlackConversAttachment.swift
//  App
//
//  Created by Allan Vialatte on 02/06/2018.
//

import Foundation
import Vapor

public struct SlackConversAttachmentField: Content {
  public let title: String
  public let value: String
  public let short: Bool
}

public struct SlackConversAttachment: Content {
  public let color: String
  public let title: String
  public let text: String
  public let fields: [SlackConversAttachmentField]?
}
