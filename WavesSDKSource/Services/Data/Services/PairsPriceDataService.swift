//
//  PairsPriceDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

public protocol PairsPriceDataServiceProtocol {
    
    func pairsPrice(query: DataService.Query.PairsPrice, enviroment: EnviromentService) -> Observable<[DataService.DTO.PairPrice]>
}

public final class PairsPriceDataService: PairsPriceDataServiceProtocol {
    
    private let apiProvider: MoyaProvider<DataService.Service.PairsPrice> = .nodeMoyaProvider()
    
    public func pairsPrice(query: DataService.Query.PairsPrice, enviroment: EnviromentService) -> Observable<[DataService.DTO.PairPrice]> {
        
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
            .map(DataService.Response<[DataService.OptionalResponse<DataService.DTO.PairPrice>]>.self)
            .map { $0.data.map {$0.data ?? .empty}}
            .asObservable()
    }
}
