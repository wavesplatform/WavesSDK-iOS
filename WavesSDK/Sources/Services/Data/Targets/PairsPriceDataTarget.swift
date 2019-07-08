//
//  DexPairsApiService.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/25/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya

public extension DataService.Query {
    
    struct PairsPrice {
        
        public struct Pair {
            public let amountAssetId: String
            public let priceAssetId: String
            
            public init(amountAssetId: String, priceAssetId: String) {
                self.amountAssetId = amountAssetId
                self.priceAssetId = priceAssetId
            }
        }
        
        public let pairs: [Pair]
        
        public init(pairs: [Pair]) {
            self.pairs = pairs
        }
    }
}

extension DataService.Target {
    
    struct PairsPrice {
        let query: DataService.Query.PairsPrice
        let dataUrl: URL
    }
}

extension DataService.Target.PairsPrice: DataTargetType {

    private enum Constants {
        static let pairs = "pairs"
    }
    
    var path: String {
        return Constants.pairs
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestParameters(parameters: [Constants.pairs: query.pairs.map { $0.amountAssetId + "/" + $0.priceAssetId } ],
                                  encoding: URLEncoding.default)
    }
}
