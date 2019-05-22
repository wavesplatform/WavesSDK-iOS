//
//  OrderBookMatcherService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class OrderBookMatcherService: OrderBookMatcherServiceProtocol {
    
    private let orderBookProvider: MoyaProvider<MatcherService.Target.OrderBook>
    
    init(orderBookProvider: MoyaProvider<MatcherService.Target.OrderBook>) {
        self.orderBookProvider = orderBookProvider
    }
    
    public func orderBook(amountAsset: String,
                          priceAsset: String,
                          enviroment: EnviromentService) -> Observable<MatcherService.DTO.OrderBook> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .getOrderBook(amountAsset: amountAsset,
                                               priceAsset: priceAsset),
                           matcherUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(MatcherService.DTO.OrderBook.self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .asObservable()
    }
    
    public func market(enviroment: EnviromentService) -> Observable<MatcherService.DTO.MarketResponse> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .getMarket,
                           matcherUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(MatcherService.DTO.MarketResponse.self)
            .asObservable()
    }
    
    public func myOrders(query: MatcherService.Query.GetMyOrders, enviroment: EnviromentService) -> Observable<[MatcherService.DTO.Order]> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .getMyOrders(query),
                           matcherUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map([MatcherService.DTO.Order].self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .asObservable()
    }
    
    public func cancelOrder(query: MatcherService.Query.CancelOrder, enviroment: EnviromentService) -> Observable<Bool> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .cancelOrder(query),
                           matcherUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map { _ in true }
            .asObservable()
    }
    
    public func createOrder(query: MatcherService.Query.CreateOrder, enviroment: EnviromentService) -> Observable<Bool> {
        
        return self
            .orderBookProvider
            .rx
            .request(.init(kind: .createOrder(query),
                           matcherUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map { _ in true }
            .asObservable()
    }
}



