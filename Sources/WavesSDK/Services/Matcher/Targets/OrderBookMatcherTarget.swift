//
//  MatcherNodeService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 20.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya


extension MatcherService.Target {
    
    struct OrderBook {
        
        enum Kind {
            
            enum CreateOrderType {
                case limit(MatcherService.Query.CreateOrder)
                case market(MatcherService.Query.CreateOrder)
            }
            
            case getOrderBook(amountAsset: String, priceAsset: String)
            case getMarket
            case getMyOrders(MatcherService.Query.GetMyOrders)
            case getAllMyOrders(MatcherService.Query.GetAllMyOrders)
            case cancelOrder(MatcherService.Query.CancelOrder)
            case cancelAllOrders(MatcherService.Query.CancelAllOrders)
            case createOrder(CreateOrderType)
            case settingsFee
            case settings
        }

        var kind: Kind
        var matcherUrl: URL
    }
}

extension MatcherService.Target.OrderBook: MatcherTargetType {
    
    fileprivate enum Constants {
        static let matcher = "matcher"
        static let settings = "settings"
        static let orderbook = "orderbook"
        static let publicKey = "publicKey"
        static let cancel = "cancel"
        static let settingsRates = "settings/rates"
        static let market = "market"
    }

    private var orderBookPath: String {
        return Constants.matcher + "/" + Constants.orderbook
    }
    
    var path: String {
        switch kind {
         
        case .settings:
            return Constants.matcher + "/" + Constants.settings
            
        case .getOrderBook(let amountAsset, let priceAsset):
            return orderBookPath + "/" + amountAsset + "/" + priceAsset
        
        case .getMarket:
            return orderBookPath
            
        case .getMyOrders(let query):
            return orderBookPath + "/" + query.amountAsset + "/" + query.priceAsset + "/"
                + Constants.publicKey + "/" + query.publicKey

        case .getAllMyOrders(let query):
            return orderBookPath + "/" + query.publicKey

        case .cancelOrder(let query):
            return orderBookPath + "/" + query.amountAsset + "/" + query.priceAsset + "/" + Constants.cancel

        case .cancelAllOrders:
            return orderBookPath + "/" + Constants.cancel

        case .createOrder(let orderType):
            switch orderType {
            case .limit:
                return orderBookPath
                
            case .market:
                return orderBookPath + "/" + Constants.market
            }
            
        case .settingsFee:
            return Constants.matcher + "/" + Constants.settingsRates
        }
    }

    var method: Moya.Method {
        
        switch kind {
        case .cancelOrder, .cancelAllOrders, .createOrder:
            return .post
            
        default:
            return .get
        }
    }

    var task: Task {
        
        switch kind {
        case .cancelOrder(let query):
            return .requestParameters(parameters: query.parameters, encoding: JSONEncoding.default)

        case .cancelAllOrders(let query):
            return .requestParameters(parameters: query.parameters, encoding: JSONEncoding.default)

        case .createOrder(let type):
            switch type {
            case .limit(let query):
                return .requestParameters(parameters: query.parameters, encoding: JSONEncoding.default)
                
            case .market(let query):
                return .requestParameters(parameters: query.parameters, encoding: JSONEncoding.default)
            }

        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var headers = ContentType.applicationJson.headers

        switch kind {
        case .getMyOrders(let query):
            headers.merge(query.parameters) { a, _ in a }

        case .getAllMyOrders(let query):
            headers.merge(query.parameters) { a, _ in a }

        default:
            break
        }

        return headers
    }
}
