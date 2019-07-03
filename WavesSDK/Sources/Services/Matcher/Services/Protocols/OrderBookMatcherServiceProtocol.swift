//
//  OrderBookMatcherServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol OrderBookMatcherServiceProtocol {
    
    func orderBook(amountAsset: String, priceAsset: String) -> Observable<MatcherService.DTO.OrderBook>
        
    func orderbook() -> Observable<MatcherService.DTO.MarketResponse>
    
    func myOrders(query: MatcherService.Query.GetMyOrders) -> Observable<[MatcherService.DTO.Order]>
    
    func cancelOrder(query: MatcherService.Query.CancelOrder) -> Observable<Bool>
    
    func createOrder(query: MatcherService.Query.CreateOrder) -> Observable<Bool>
}

