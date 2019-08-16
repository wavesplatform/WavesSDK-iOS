//
//  PairsPriceDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class PairsPriceDataService: InternalWavesService, PairsPriceDataServiceProtocol {
  
    private let pairsPriceProvider: MoyaProvider<DataService.Target.PairsPrice>
    private let pairsPriceSearchProvider: MoyaProvider<DataService.Target.PairsPriceSearch>
    
    init(pairsPriceProvider: MoyaProvider<DataService.Target.PairsPrice>,
         pairsPriceSearchProvider: MoyaProvider<DataService.Target.PairsPriceSearch>,
         enviroment: Enviroment) {
        
        self.pairsPriceProvider = pairsPriceProvider
        self.pairsPriceSearchProvider = pairsPriceSearchProvider
        super.init(enviroment: enviroment)
    }
    
    public func pairsPrice(query: DataService.Query.PairsPrice) -> Observable<[DataService.DTO.PairPrice?]> {
        
        return self
            .pairsPriceProvider
            .rx
            .request(.init(query: query,
                           dataUrl: enviroment.dataUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[DataService.OptionalResponse<DataService.DTO.PairPrice>]>.self)
            .map { $0.data.map {$0.data }}
            .asObservable()
    }
    
    public func searchByAsset(query: DataService.Query.PairsPriceSearch) -> Observable<[DataService.DTO.PairPriceSearch]> {
        
        return self.pairsPriceSearchProvider
                .rx
                .request(DataService.Target.PairsPriceSearch(kind: query.kind,
                                                             dataUrl: enviroment.dataUrl),
                         callbackQueue: DispatchQueue.global(qos: .userInteractive))
                .filterSuccessfulStatusAndRedirectCodes()
                .catchError({ (error) -> Single<Response> in
                    return Single<Response>.error(NetworkError.error(by: error))
                })
                .map(DataService.Response<[DataService.DTO.PairPriceSearch]>.self)
                .map { $0.data }
                .asObservable()
    }
    
    
}
