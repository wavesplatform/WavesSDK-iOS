//
//  CandleFilters.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/23/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension DataService.Query {
    
    struct CandleFilters: Codable {
        public let amountAsset: String
        public let priceAsset: String
        public let timeStart: Int64
        public let timeEnd: Int64
        public let interval: String
        public let matcher: String?
        
        public init(amountAsset: String, priceAsset: String, timeStart: Int64, timeEnd: Int64, interval: String, matcher: String?) {
            self.amountAsset = amountAsset
            self.priceAsset = priceAsset
            self.timeStart = timeStart
            self.timeEnd = timeEnd
            self.interval = interval
            self.matcher = matcher
        }
    }
}
