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
        
        init(pairs: [Pair]) {
            self.pairs = pairs
        }
    }
}

extension DataService.Service {
    
    struct PairsPrice {
        let query: DataService.Query.PairsPrice
        let dataUrl: URL
    }
}

extension DataService.Service.PairsPrice: DataTargetType {

    private enum Constants {
        static let pairs = "pairs"
    }
    
    var path: String {
        return parametersString
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
}

private extension DataService.Service.PairsPrice {
        
    var parametersString: String {
        
        var url = ""
        
        for pair in query.pairs {
            if (url as NSString).range(of: "?").location == NSNotFound {
                url.append("?")
            }
            if url.last != "?" {
                url.append("&")
            }
            url.append("\(Constants.pairs)=" + pair.amountAssetId + "/" + pair.priceAssetId)
        }

        return url
    }
}
