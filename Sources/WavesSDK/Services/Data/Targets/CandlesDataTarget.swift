//
//  CandlesApiService.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/22/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya


extension DataService.Target {

    struct Candles {
        let query: DataService.Query.CandleFilters
        let dataUrl: URL
    }
}

private enum Constants {
    static let candles: String = "candles"
}

extension DataService.Target.Candles: DataTargetType {
    
    var path: String {
        return "/\(Constants.candles)/\(query.amountAsset)/\(query.priceAsset)"
    }
            
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestParameters(parameters: query.dictionary, encoding: URLEncoding.default)
    }    
}
