//
//  OrderBookMatcherServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol OrderBookMatcherServiceProtocol {

    /**
    Get orderbook for a given Asset Pair
      */
    func orderBook(amountAsset: String, priceAsset: String) -> Observable<MatcherService.DTO.OrderBook>

    /**
      Get the all open trading markets along with trading pairs meta data
     */
    func orderbook() -> Observable<MatcherService.DTO.MarketResponse>
    

    /**
      Get OrderResponse History for a given Asset Pair and Public Key
     */
    func myOrders(query: MatcherService.Query.GetMyOrders) -> Observable<[MatcherService.DTO.Order]>

    
    /**
      Get OrderResponse History for a all assets and Public Key
     */
    
    func allMyOrders(query: MatcherService.Query.GetAllMyOrders) -> Observable<[MatcherService.DTO.Order]>

    /**
      Cancel previously submitted order if it's not already filled completely
     */
    func cancelOrder(query: MatcherService.Query.CancelOrder) -> Observable<Bool>

    
    /**
        Cancel previously submitted orders if it's not already filled completely
    */
    func cancelAllOrders(query: MatcherService.Query.CancelAllOrders) -> Observable<Bool>
    
    /**
      Place a new limit order (buy or sell)
     */
    func createOrder(query: MatcherService.Query.CreateOrder) -> Observable<Bool>

    /**
      Place a new market order (buy or sell)
     */
    func createMarketOrder(query: MatcherService.Query.CreateOrder) -> Observable<Bool>

    
    /**
     Rate get  for calculate fee
     */
    func settingsRatesFee() -> Observable<[MatcherService.DTO.SettingRateFee]>
    
    //TODO: need documents
    func settings() -> Observable<MatcherService.DTO.Setting>
}

