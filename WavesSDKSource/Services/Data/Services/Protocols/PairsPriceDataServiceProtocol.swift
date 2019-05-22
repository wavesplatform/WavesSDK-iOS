//
//  PairsPriceDataService.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol PairsPriceDataServiceProtocol {
    
    func pairsPrice(query: DataService.Query.PairsPrice, enviroment: EnviromentService) -> Observable<[DataService.DTO.PairPrice]>
}
