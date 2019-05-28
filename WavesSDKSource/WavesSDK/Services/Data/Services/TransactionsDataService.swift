//
//  TransactionsDataService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class TransactionsDataService: TransactionsDataServiceProtocol {
    
    private let transactionsProvider: MoyaProvider<DataService.Target.Transactions>
    
    var enviroment: Enviroment
    
    init(transactionsProvider: MoyaProvider<DataService.Target.Transactions>, enviroment: Enviroment) {
        self.transactionsProvider = transactionsProvider
        self.enviroment = enviroment
    }
    
    public func exchangeFilters(query: DataService.Query.ExchangeFilters) -> Observable<[DataService.DTO.ExchangeTransaction]> {
        
        return self
            .transactionsProvider
            .rx
            .request(.init(kind: .getExchangeWithFilters(query),
                           dataUrl: enviroment.dataUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .map(DataService.Response<[DataService.Response<DataService.DTO.ExchangeTransaction>]>.self,
                 atKeyPath: nil,
                 using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff),
                 failsOnEmptyData: false)
            .map { $0.data.map { $0.data } }
            .asObservable()
    }
}

