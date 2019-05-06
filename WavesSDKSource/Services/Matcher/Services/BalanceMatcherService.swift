//
//  BalanceMatcherService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

public protocol BalanceMatcherServiceProtocol {
    
    func reservedBalances(query: Matcher.Query.ReservedBalances, enviroment: EnviromentService) -> Observable<[String: Int64]>
}

public final class BalanceMatcherService: BalanceMatcherServiceProtocol {
    
    private let matcherBalanceProvider: MoyaProvider<Matcher.Service.Balance> = .nodeMoyaProvider()
    
    public func reservedBalances(query: Matcher.Query.ReservedBalances, enviroment: EnviromentService) -> Observable<[String: Int64]> {
        
        return self
            .matcherBalanceProvider
            .rx
            .request(.init(kind: .getReservedBalances(query),
                           matcherUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map([String: Int64].self)
            .asObservable()
    }
}
