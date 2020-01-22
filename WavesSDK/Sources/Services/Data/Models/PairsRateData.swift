//
//  PairsRateData.swift
//  WavesSDK
//
//  Created by Pavel Gubin on 22.01.2020.
//  Copyright © 2020 Waves. All rights reserved.
//

import Foundation

public extension DataService.DTO {
    
    struct PairRate {
        public let amountAssetId: String
        public let priceAssetId: String
        public let rate: Double
    }
}
