//
//  OrderBookMatcherService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

public protocol OrderBookMatcherServiceProtocol {
    
    func orderBook(amountAsset: String, priceAsset: String, enviroment: EnviromentService) -> Observable<Matcher.DTO.OrderBook>
    
    func market(amountAsset: String, priceAsset: String, enviroment: EnviromentService) -> Observable<Matcher.DTO.MarketResponse>
    
    func myOrders(query: Matcher.Query.GetMyOrders, enviroment: EnviromentService) -> Observable<[Matcher.DTO.Order]>

    func cancelOrder(query: Matcher.Query.CancelOrder, enviroment: EnviromentService) -> Observable<Bool>

    func createOrder(query: Matcher.Query.CreateOrder, enviroment: EnviromentService) -> Observable<Bool>
}

final class OrderBookMatcherService: OrderBookMatcherServiceProtocol {
    
    private let orderBookProvider: MoyaProvider<Matcher.Service.OrderBook>
    
    init(orderBookProvider: MoyaProvider<Matcher.Service.OrderBook>) {
        self.orderBookProvider = orderBookProvider
    }
    
    public func orderBook(amountAsset: String,
                          priceAsset: String,
                          enviroment: EnviromentService) -> Observable<Matcher.DTO.OrderBook> {
        
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
            .map(Matcher.DTO.OrderBook.self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .asObservable()
    }
    
    public func market(amountAsset: String, priceAsset: String, enviroment: EnviromentService) -> Observable<Matcher.DTO.MarketResponse> {
        
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
            .map(Matcher.DTO.MarketResponse.self)
            .asObservable()
    }
    
    public func myOrders(query: Matcher.Query.GetMyOrders, enviroment: EnviromentService) -> Observable<[Matcher.DTO.Order]> {
        
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
            .map([Matcher.DTO.Order].self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .asObservable()
    }
    
    public func cancelOrder(query: Matcher.Query.CancelOrder, enviroment: EnviromentService) -> Observable<Bool> {
        
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
    
    public func createOrder(query: Matcher.Query.CreateOrder, enviroment: EnviromentService) -> Observable<Bool> {
        
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



