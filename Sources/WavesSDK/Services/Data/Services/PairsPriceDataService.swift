//
//  PairsPriceDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

private struct Rate: Decodable {
    
    struct Data: Decodable {
        let rate: Double
    }
    
    let data: Data
    let amountAsset: String
    let priceAsset: String
}


final class PairsPriceDataService: InternalWavesService, PairsPriceDataServiceProtocol {
  
    private let pairsPriceProvider: MoyaProvider<DataService.Target.PairsPrice>
    private let pairsPriceSearchProvider: MoyaProvider<DataService.Target.PairsPriceSearch>
    private let pairsRateProvider: MoyaProvider<DataService.Target.PairsRate>

    init(pairsPriceProvider: MoyaProvider<DataService.Target.PairsPrice>,
         pairsPriceSearchProvider: MoyaProvider<DataService.Target.PairsPriceSearch>,
         pairsRateProvider: MoyaProvider<DataService.Target.PairsRate>,
         enviroment: WavesEnvironment) {
        
        self.pairsPriceProvider = pairsPriceProvider
        self.pairsPriceSearchProvider = pairsPriceSearchProvider
        self.pairsRateProvider = pairsRateProvider
        super.init(enviroment: enviroment)
    }
    
    public func pairsPrice(query: DataService.Query.PairsPrice) -> Observable<[DataService.DTO.PairPrice?]> {
        
        return self
            .pairsPriceProvider
            .rx
            .request(.init(query: query,
                           dataUrl: enviroment.dataUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[DataService.OptionalResponse<DataService.DTO.PairPrice>]>.self)
            .map { $0.data.map {$0.data }}
            .asObservable()
    }
    
    public func pairsRate(query: DataService.Query.PairsRate) -> Observable<[DataService.DTO.PairRate]> {
        
        return pairsRateProvider
            .rx
            .request(DataService.Target.PairsRate(query: query, dataUrl: enviroment.dataUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[Rate]>.self)
            .map { $0.data.map { DataService.DTO.PairRate(amountAssetId: $0.amountAsset,
                                                          priceAssetId: $0.priceAsset,
                                                          rate: $0.data.rate) }}
            .asObservable()

        
    }
    public func searchByAsset(query: DataService.Query.PairsPriceSearch) -> Observable<[DataService.DTO.PairPriceSearch]> {
        
        return self.pairsPriceSearchProvider
                .rx
                .request(DataService.Target.PairsPriceSearch(query: query,
                                                             dataUrl: enviroment.dataUrl))
                .filterSuccessfulStatusAndRedirectCodes()
                .catch({ (error) -> Single<Response> in
                    return Single<Response>.error(NetworkError.error(by: error))
                })
                .map(DataService.Response<[DataService.DTO.PairPriceSearch]>.self)
                .map { $0.data }
                .asObservable()
    }
    
    
}
