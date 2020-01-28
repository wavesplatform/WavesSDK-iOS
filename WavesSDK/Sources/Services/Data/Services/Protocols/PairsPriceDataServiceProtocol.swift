//
//  PairsPriceDataService.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol PairsPriceDataServiceProtocol {
    /**
      Get pair info by amount and price assets
     */
    func pairsPrice(query: DataService.Query.PairsPrice) -> Observable<[DataService.DTO.PairPrice?]>
    func pairsRate(query: DataService.Query.PairsRate) -> Observable<[DataService.DTO.PairRate]>
    func searchByAsset(query: DataService.Query.PairsPriceSearch) -> Observable<[DataService.DTO.PairPriceSearch]>
}
