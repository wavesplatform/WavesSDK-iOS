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
    func transactionsExchange(query: DataService.Query.ExchangeFilters) -> Observable<[DataService.DTO.ExchangeTransaction]>
}
