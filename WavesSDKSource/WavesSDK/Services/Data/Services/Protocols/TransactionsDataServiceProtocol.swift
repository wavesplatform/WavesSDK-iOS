//
//  TransactionsDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol TransactionsDataServiceProtocol {

    /**
      Get a list of exchange transactions by applying filters
     */
    func exchangeFilters(query: DataService.Query.ExchangeFilters) -> Observable<[DataService.DTO.ExchangeTransaction]>
}
