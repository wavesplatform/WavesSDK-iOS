//
//  CandlesDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol CandlesDataServiceProtocol {
    
    func candles(query: DataService.Query.CandleFilters) -> Observable<DataService.DTO.Chart>
}
