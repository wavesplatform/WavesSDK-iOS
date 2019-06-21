//
//  CandlesDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class CandlesDataService: CandlesDataServiceProtocol {
    
    private let candlesProvider: MoyaProvider<DataService.Target.Candles>
    
    var enviroment: Enviroment
    
    init(candlesProvider: MoyaProvider<DataService.Target.Candles>, enviroment: Enviroment) {
        self.candlesProvider = candlesProvider
        self.enviroment = enviroment
    }
    
    public func candles(query: DataService.Query.CandleFilters) -> Observable<DataService.DTO.Chart> {
        
        return self
            .candlesProvider
            .rx
            .request(.init(query: query,
                           dataUrl: enviroment.dataUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.DTO.Chart.self)
            .asObservable()
    }
}
