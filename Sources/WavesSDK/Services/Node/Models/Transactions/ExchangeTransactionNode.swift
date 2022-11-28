//
//  TransactionExchangeNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    /**
     Not available now!

     Exchange transaction matches a sell and buy orders
     for exchange by specifying the following:

     The asset.
     The price of asset to sell(1) or buy(0).
     The amount which the user is offering.
     The asset and the amount which the user requests in return.
     */
    struct ExchangeTransaction: Codable {
        public struct Order: Codable {
            public let id: String
            public let sender: String
            public let senderPublicKey: String
            public let matcherPublicKey: String
            public let assetPair: AssetPair
            public let orderType: String
            public let price: Int64
            public let amount: Int64
            public let timestamp: Date
            public let expiration: Int64
            public let matcherFee: Int64
            public let signature: String?
            public let proofs: [String]?
            public let matcherFeeAssetId: String?
        }

        public struct AssetPair: Codable {
            public let amountAsset: String?
            public let priceAsset: String?
        }

        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let height: Int64
        public let version: Int

        public let signature: String?
        public let proofs: [String]?
        public let order1: Order
        public let order2: Order
        public let price: Int64
        public let amount: Int64
        public let buyMatcherFee: Int64
        public let sellMatcherFee: Int64
        public let applicationStatus: String?
    }
}
