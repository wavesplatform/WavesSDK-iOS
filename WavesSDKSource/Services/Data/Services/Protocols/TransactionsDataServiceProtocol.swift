//
//  TransactionsDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol TransactionsDataServiceProtocol {
    
    func exchangeFilters(query: DataService.Query.ExchangeFilters, enviroment: EnviromentService) -> Observable<[DataService.DTO.ExchangeTransaction]>
}
