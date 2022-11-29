//
//  Transaction.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension DataService.DTO {

    enum OrderType: String, Decodable {
        case sell
        case buy
    }
    
    struct Pair: Decodable {
        public let amountAsset: String
        public let priceAsset: String
    }
    
    struct Order: Decodable {
        public let id: String
        public let senderPublicKey: String
        public let matcherPublicKey: String
        public let assetPair: Pair
        public let orderType: OrderType
        public let price: Double
        public let sender: String
        public let amount: Double
        public let timestamp: Date
        public let expiration: Date
        public let matcherFee: Double
        public let signature: String
    }

    struct ExchangeTransaction: Decodable {
        public let id: String
        public let timestamp: Date
        public let height: Int64
        public let type: Int
        public let fee: Double
        public let sender: String
        public let senderPublicKey: String
        public let buyMatcherFee: Double
        public let sellMatcherFee: Double
        public let price: Double
        public let amount: Double
        public let order1: Order
        public let order2: Order
    }
}

extension DataService.DTO.ExchangeTransaction {
    
    public var orderType: DataService.DTO.OrderType {
        let order = order1.timestamp > order2.timestamp ? order1 : order2
        return order.orderType
    }
}
