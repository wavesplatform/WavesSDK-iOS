//
//  DexPairsApiService.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/25/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya

private enum TargetConstants {
    static let pairs = "pairs"
}

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
    
    struct PairsPriceSearch {
        
        public enum Kind {
            case byAsset(String)
            case byAssets(firstName: String, secondName: String)
        }
        
        public let kind: Kind
        
        public init(kind: Kind) {
            self.kind = kind
        }
    }
}

extension DataService.Target {
    
    struct PairsPrice {
        let query: DataService.Query.PairsPrice
        let dataUrl: URL
    }
    
    struct PairsPriceSearch {
        let kind: DataService.Query.PairsPriceSearch.Kind
        let dataUrl: URL
    }
}

extension DataService.Target.PairsPrice: DataTargetType {

    var path: String {
        return TargetConstants.pairs
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestParameters(parameters: [TargetConstants.pairs: query.pairs.map { $0.amountAssetId + "/" + $0.priceAssetId } ],
                                  encoding: URLEncoding.default)
    }
}

extension DataService.Target.PairsPriceSearch: DataTargetType {
    
    private enum Constants {
        static let searchByAsset = "search_by_asset"
        static let searchByAssets = "search_by_assets"

    }
    
    var path: String {
        return TargetConstants.pairs
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch kind {
        case .byAsset(let name):
            return .requestParameters(parameters: [Constants.searchByAsset: name], encoding: URLEncoding.default)
            
        case .byAssets(let firstName, let secondName):
            return .requestParameters(parameters: [Constants.searchByAssets: firstName + "," + secondName],
                                      encoding: URLEncoding.default)
        }
    }
}
