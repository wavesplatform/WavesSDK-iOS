//
//  MyOrderMatcher.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/26/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension MatcherService.DTO {
    
    struct Order: Decodable {
        
        public struct AssetPair: Decodable {
            public let amountAsset: String?
            public let priceAsset: String?
        }
        
        public enum OrderType: String, Decodable {
            case sell
            case buy
        }
        
        public enum Status: String, Decodable {
            case Accepted
            case PartiallyFilled
            case Cancelled
            case Filled
        }
        
        public let id: String
        public let type: OrderType
        public let amount: Int64
        public let price: Int64
        public let filled: Int64
        public let status: Status
        public let timestamp: Date
                
        public let fee: Int64?
        public let feeAsset: String?
        public let assetPair: AssetPair
    }
    
    struct SettingRateFee {
        public let assetId: String
        public let rate: Double
    }
    
    struct Setting: Decodable {
        public let priceAssets: [String]        
    }
}
