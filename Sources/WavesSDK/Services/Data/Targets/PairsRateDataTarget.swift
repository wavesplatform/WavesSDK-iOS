//
//  MatcherDataTarget.swift
//  WavesSDK
//
//  Created by Pavel Gubin on 22.01.2020.
//  Copyright © 2020 Waves. All rights reserved.
//

import Foundation
import Moya

private enum TargetConstants {
    static let timestamp = "timestamp"
    static let rates = "rates"
    static let pairs = "pairs"
    static let matcher = "matchers"
}

public extension DataService.Query {
    
    struct PairsRate {
        
        public struct Pair {
            public let amountAssetId: String
            public let priceAssetId: String
            
            public init(amountAssetId: String, priceAssetId: String) {
                self.amountAssetId = amountAssetId
                self.priceAssetId = priceAssetId
            }
        }
        
        public let pairs: [Pair]
        public let matcher: String
        public let timestamp: Int64?
        
        public init(pairs: [Pair], matcher: String, timestamp: Int64?) {
            self.pairs = pairs
            self.matcher = matcher
            self.timestamp = timestamp
        }
    }
}

extension DataService.Target {

    struct PairsRate {
        let query: DataService.Query.PairsRate
        let dataUrl: URL
    }
}

extension DataService.Target.PairsRate: DataTargetType {

    var path: String {
        return "\(TargetConstants.matcher)/\(String(describing: self.query.matcher))/\(TargetConstants.rates)"
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {

        let paramenets: [String: Any] = {
            
            if let timestamp = query.timestamp {
                return [TargetConstants.pairs: query.pairs.map { $0.amountAssetId + "/" + $0.priceAssetId },
                        TargetConstants.timestamp: timestamp]
            } else {
                return [TargetConstants.pairs: query.pairs.map { $0.amountAssetId + "/" + $0.priceAssetId }]
            }
           
        }()

        return .requestParameters(parameters: paramenets,
                                  encoding: JSONEncoding.default)
    }
}
