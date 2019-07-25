//
//  CandleApi.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/23/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension DataService.DTO {
    struct Chart: Decodable {
        
        public struct Candle: Decodable {
            public let time: Date
            public let volume: Double?
            public let close: Double?
            public let high: Double?
            public let low: Double?
            public let open: Double?
        }
        
        public let candles: [Candle]
        
        public init(candles: [Candle]) {
            self.candles = candles
        }
    }
}
