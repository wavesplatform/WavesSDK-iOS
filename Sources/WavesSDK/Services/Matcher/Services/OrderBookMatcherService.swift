//
//  OrderBookMatcherService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class OrderBookMatcherService: InternalWavesService, OrderBookMatcherServiceProtocol {
   
    private let orderBookProvider: MoyaProvider<MatcherService.Target.OrderBook>
        
    init(orderBookProvider: MoyaProvider<MatcherService.Target.OrderBook>, enviroment: WavesEnvironment) {
        self.orderBookProvider = orderBookProvider
        super.init(enviroment: enviroment)
    }
    
    public func orderBook(amountAsset: String,
                          priceAsset: String) -> Observable<MatcherService.DTO.OrderBook> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .getOrderBook(amountAsset: amountAsset,
                                               priceAsset: priceAsset),
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(MatcherService.DTO.OrderBook.self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .asObservable()
    }
    
    public func orderbook() -> Observable<MatcherService.DTO.MarketResponse> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .getMarket,
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(MatcherService.DTO.MarketResponse.self)
            .asObservable()
    }
    
    public func myOrders(query: MatcherService.Query.GetMyOrders) -> Observable<[MatcherService.DTO.Order]> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .getMyOrders(query),
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map([MatcherService.DTO.Order].self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .asObservable()
    }
    
    public func allMyOrders(query: MatcherService.Query.GetAllMyOrders) -> Observable<[MatcherService.DTO.Order]> {
        return self
           .orderBookProvider
           .rx
           .request(.init(kind: .getAllMyOrders(query),
                          matcherUrl: enviroment.matcherUrl))
           .filterSuccessfulStatusAndRedirectCodes()
           .catch({ (error) -> Single<Response> in
               return Single.error(NetworkError.error(by: error))
           })
           .map([MatcherService.DTO.Order].self,
                atKeyPath: nil,
                using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                failsOnEmptyData: false)
           .asObservable()
    }
    
    public func cancelOrder(query: MatcherService.Query.CancelOrder) -> Observable<Bool> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .cancelOrder(query),
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map { _ in true }
            .asObservable()
    }
    
    public func cancelAllOrders(query: MatcherService.Query.CancelAllOrders) -> Observable<Bool> {
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .cancelAllOrders(query),
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map { _ in true }
            .asObservable()
    }
       
    public func createOrder(query: MatcherService.Query.CreateOrder) -> Observable<Bool> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .createOrder(.limit(query)),
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map { _ in true }
            .asObservable()
    }
    
    public func createMarketOrder(query: MatcherService.Query.CreateOrder) -> Observable<Bool> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .createOrder(.market(query)),
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map { _ in true }
            .asObservable()
    }
    
    public func settingsRatesFee() -> Observable<[MatcherService.DTO.SettingRateFee]> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .settingsFee,
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .asObservable()
            .map({ (response) -> [MatcherService.DTO.SettingRateFee] in
                
                guard let data = try? JSONSerialization.jsonObject(with: response.data, options: []),
                    let json = data as? [String: Double] else {
                    return []
                }
                
                var settingsFee: [MatcherService.DTO.SettingRateFee] = []
                
                let keys = Array(json.keys)
                for key in keys {
                    if let value = json[key] {
                        settingsFee.append(.init(assetId: key, rate: value))
                    }
                }
                
                return settingsFee
            })
    }
    
    public func settings() -> Observable<MatcherService.DTO.Setting> {
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .settings,
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .asObservable()
            .map(MatcherService.DTO.Setting.self)
    }
}



