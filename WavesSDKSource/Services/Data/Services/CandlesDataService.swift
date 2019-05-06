//
//  CandlesDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

public protocol CandlesDataServiceProtocol {
    
    func candles(query: DataService.Query.CandleFilters, enviroment: EnviromentService) -> Observable<DataService.DTO.Chart>
}

public final class CandlesDataService: CandlesDataServiceProtocol {
    
    private let apiProvider: MoyaProvider<DataService.Service.Candles> = .nodeMoyaProvider()
    
    public func candles(query: DataService.Query.CandleFilters, enviroment: EnviromentService) -> Observable<DataService.DTO.Chart> {
        
        return self
            .apiProvider
            .rx
            .request(.init(query: query,
                           dataUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.DTO.Chart.self)
            .asObservable()
    }
}
