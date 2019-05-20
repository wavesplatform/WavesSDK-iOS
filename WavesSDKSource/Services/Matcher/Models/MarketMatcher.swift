//
//  MarketApi.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/23/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension MatcherService.DTO {
    
    struct Market: Decodable {
        public struct AssetInfo: Decodable {
            public let decimals: Int
        }
        
        public let amountAsset: String
        public let amountAssetName: String
        public let amountAssetInfo: AssetInfo?
        
        public let priceAsset: String
        public let priceAssetName: String
        public let priceAssetInfo: AssetInfo?
    }
    
    struct MarketResponse: Decodable {        
        public let markets: [Market]
    }
}
