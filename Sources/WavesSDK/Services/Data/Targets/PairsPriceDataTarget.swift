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
    static let matcher = "matcher"
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
        public let matcher: String?
        
        public init(pairs: [Pair], matcher: String?) {
            self.matcher = matcher
            self.pairs = pairs
        }
    }
    
    struct PairsPriceSearch {
        
        public enum Kind {
            case byAsset(String)
            case byAssets(firstName: String, secondName: String)
        }
        
        public let kind: Kind
        public let matcher: String?
        
        public init(kind: Kind, matcher: String?) {
            self.kind = kind
            self.matcher = matcher
        }
    }
}

extension DataService.Target {
    
    struct PairsPrice {
        let query: DataService.Query.PairsPrice
        let dataUrl: URL
    }
    
    struct PairsPriceSearch {
        let query: DataService.Query.PairsPriceSearch
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
        
        let dictionary: [String: Any] = {
                    
            if let matcher = query.matcher {
                return [TargetConstants.pairs: query.pairs.map { $0.amountAssetId + "/" + $0.priceAssetId },
                        TargetConstants.matcher: matcher]
            } else {
                return [TargetConstants.pairs: query.pairs.map { $0.amountAssetId + "/" + $0.priceAssetId }]
            }
        }()
        
        return .requestParameters(parameters: dictionary,
                                  encoding: URLEncoding.queryString)
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
        
        
        switch query.kind {
        case .byAsset(let name):

            let dictionary: [String: Any] = {

                 if let matcher = query.matcher {
                     return [Constants.searchByAsset: name,
                             TargetConstants.matcher: matcher]
                 } else {
                     return [Constants.searchByAsset: name]
                 }
             }()
            
            return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
            
        case .byAssets(let firstName, let secondName):
            
            let dictionary: [String: Any] = {

                 if let matcher = query.matcher {
                     return [Constants.searchByAssets: firstName + "," + secondName,
                             TargetConstants.matcher: matcher]
                 } else {
                     return [Constants.searchByAssets: firstName + "," + secondName]
                 }
             }()
            
            return .requestParameters(parameters: dictionary,
                                      encoding: URLEncoding.queryString)
        }
    }
}

