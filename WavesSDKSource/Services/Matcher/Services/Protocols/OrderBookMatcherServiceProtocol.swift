//
//  OrderBookMatcherServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol OrderBookMatcherServiceProtocol {
    
    func orderBook(amountAsset: String, priceAsset: String, enviroment: EnviromentService) -> Observable<MatcherService.DTO.OrderBook>
    
    func market(enviroment: EnviromentService) -> Observable<MatcherService.DTO.MarketResponse>
    
    func myOrders(query: MatcherService.Query.GetMyOrders, enviroment: EnviromentService) -> Observable<[MatcherService.DTO.Order]>
    
    func cancelOrder(query: MatcherService.Query.CancelOrder, enviroment: EnviromentService) -> Observable<Bool>
    
    func createOrder(query: MatcherService.Query.CreateOrder, enviroment: EnviromentService) -> Observable<Bool>
}
