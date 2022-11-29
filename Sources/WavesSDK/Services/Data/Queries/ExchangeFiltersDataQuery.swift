//
//  ExchangeFilters.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension DataService.Query {
  struct ExchangeFilters: Codable {
    // Address of a matcher which sent the transaction
    public let matcher: String?
    // Address of a trader-participant in a transaction — an ORDER sender
    public let sender: String?
    // Id of order related to the transaction
    public let orderId: String?
    // Time range filter, start. Defaults to first transaction's time_stamp in db.
    public let timeStart: String?
    // Time range filter, end. Defaults to now.
    public let timeEnd: String?
    // Asset ID of the amount asset.
    public let amountAsset: String?
    // Asset ID of the price asset.
    public let priceAsset: String?
    // Cursor in base64 encoding. Holds information about timestamp, id, sort.
    public let after: String?
    // Sort order. Gonna be rewritten by cursor's sort if present.
    public var sort: String = "desc"
    // How many transactions to await in response.
    public let limit: Int

    public init(matcher: String?, sender: String?, orderId:String?,timeStart: String?, timeEnd: String?, amountAsset: String?, priceAsset: String?, after: String?, sort: String = "desc", limit: Int) {
      self.matcher = matcher
      self.sender = sender
      self.orderId = orderId
      self.timeStart = timeStart
      self.timeEnd = timeEnd
      self.amountAsset = amountAsset
      self.priceAsset = priceAsset
      self.after = after
      self.sort = sort
      self.limit = limit
    }
  }
}
