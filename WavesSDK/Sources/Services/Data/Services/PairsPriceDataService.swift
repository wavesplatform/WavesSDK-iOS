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
        
    init(pairsPriceProvider: MoyaProvider<DataService.Target.PairsPrice>, enviroment: Enviroment) {
        self.pairsPriceProvider = pairsPriceProvider
        super.init(enviroment: enviroment)
    }
    
    public func pairsPrice(query: DataService.Query.PairsPrice) -> Observable<[DataService.DTO.PairPrice]> {
        
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
            .map { $0.data.map {$0.data ?? .empty}}
            .asObservable()
    }
}
