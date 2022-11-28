//
//  CandlesDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol CandlesDataServiceProtocol {

    /**
      Get candles by amount and price assets. Maximum amount of candles in response – 1440.
     */
    func candles(query: DataService.Query.CandleFilters) -> Observable<DataService.DTO.Chart>
}
