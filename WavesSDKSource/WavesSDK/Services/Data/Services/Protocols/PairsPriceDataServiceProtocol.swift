//
//  PairsPriceDataService.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol PairsPriceDataServiceProtocol {
    
    func pairsPrice(query: DataService.Query.PairsPrice) -> Observable<[DataService.DTO.PairPrice]>
}
