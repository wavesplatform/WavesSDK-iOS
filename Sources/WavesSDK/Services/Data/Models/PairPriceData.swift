//
//  PairApi.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/26/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension DataService.DTO {
    
    struct PairPrice: Decodable {
        
        public let firstPrice: Double
        public let lastPrice: Double
        public let volume: Double
        public let volumeWaves: Double?
        public let quoteVolume: Double?
    }
    
    struct PairPriceSearch: Decodable {
        
        public let data: PairPrice
        public let amountAsset: String
        public let priceAsset: String
    }
}

