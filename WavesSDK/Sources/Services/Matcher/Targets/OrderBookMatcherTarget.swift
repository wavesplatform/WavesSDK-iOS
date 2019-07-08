//
//  MatcherNodeService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 20.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya
import WavesSDKExtensions

extension MatcherService.Target {
    
    struct OrderBook {
        
        enum Kind {
            case getOrderBook(amountAsset: String, priceAsset: String)
            case getMarket
            case getMyOrders(MatcherService.Query.GetMyOrders)
            case cancelOrder(MatcherService.Query.CancelOrder)
            case createOrder(MatcherService.Query.CreateOrder)
            case settingsFee
        }

        var kind: Kind
        var matcherUrl: URL
    }
}

extension MatcherService.Target.OrderBook: MatcherTargetType {
    
    fileprivate enum Constants {
        static let matcher = "matcher"
        static let orderbook = "orderbook"
        static let publicKey = "publicKey"
        static let cancel = "cancel"
        static let settingsRates = "settings/rates"
    }

    private var orderBookPath: String {
        return Constants.matcher + "/" + Constants.orderbook
    }
    
    var path: String {
        switch kind {
         
        case .getOrderBook(let amountAsset, let priceAsset):
            return orderBookPath + "/" + amountAsset + "/" + priceAsset
        
        case .getMarket:
            return orderBookPath
            
        case .getMyOrders(let query):
            return orderBookPath + "/" + query.amountAsset + "/" + query.priceAsset + "/"
                + Constants.publicKey + "/" + query.publicKey

        case .cancelOrder(let query):
            return orderBookPath + "/" + query.amountAsset + "/" + query.priceAsset + "/" + Constants.cancel

        case .createOrder:
            return orderBookPath
            
        case .settingsFee:
            return Constants.matcher + "/" + Constants.settingsRates
        }
    }

    var method: Moya.Method {
        
        switch kind {
        case .cancelOrder, .createOrder:
            return .post
            
        default:
            return .get
        }
    }

    var task: Task {
        
        switch kind {
        case .cancelOrder(let query):
            return .requestParameters(parameters: query.parameters, encoding: JSONEncoding.default)

        case .createOrder(let query):
            return .requestParameters(parameters: query.parameters, encoding: JSONEncoding.default)

        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var headers = ContentType.applicationJson.headers

        switch kind {
        case .getMyOrders(let query):
            headers.merge(query.parameters) { a, _ in a }

        default:
            break
        }

        return headers
    }
}
