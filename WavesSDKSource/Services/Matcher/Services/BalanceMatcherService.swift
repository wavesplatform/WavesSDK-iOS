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
    
    func reservedBalances(query: MatcherService.Query.ReservedBalances, enviroment: EnviromentService) -> Observable<[String: Int64]>
}

final class BalanceMatcherService: BalanceMatcherServiceProtocol {
    
    private let balanceProvider: MoyaProvider<MatcherService.Target.Balance>
    
    init(balanceProvider: MoyaProvider<MatcherService.Target.Balance>) {
        self.balanceProvider = balanceProvider
    }
    
    public func reservedBalances(query: MatcherService.Query.ReservedBalances, enviroment: EnviromentService) -> Observable<[String: Int64]> {
        
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
