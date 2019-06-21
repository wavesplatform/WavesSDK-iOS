//
//  OrderBookApi.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/17/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension MatcherService.DTO {
    
    struct OrderBook: Decodable {
        
        public struct Pair: Decodable {
            public let amountAsset: String
            public let priceAsset: String
        }
        
        public struct Value: Decodable {
            public let amount: Int64
            public let price: Int64
        }

        public let date: Date
        public let pair: Pair
        public let bids: [Value]
        public let asks: [Value]
        
        private enum CodingKeys: String, CodingKey {
            case date = "timestamp"
            case pair, bids, asks
        }
    }
}
