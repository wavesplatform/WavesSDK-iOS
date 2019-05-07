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

final class BalanceMatcherService: BalanceMatcherServiceProtocol {
    
    private let balanceProvider: MoyaProvider<Matcher.Service.Balance>
    
    init(balanceProvider: MoyaProvider<Matcher.Service.Balance>) {
        self.balanceProvider = balanceProvider
    }
    
    public func reservedBalances(query: Matcher.Query.ReservedBalances, enviroment: EnviromentService) -> Observable<[String: Int64]> {
        
        return self
            .balanceProvider
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
