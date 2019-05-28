//
//  BalanceMatcherService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class BalanceMatcherService: BalanceMatcherServiceProtocol {
    
    private let balanceProvider: MoyaProvider<MatcherService.Target.Balance>
    var enviroment: Enviroment
    
    init(balanceProvider: MoyaProvider<MatcherService.Target.Balance>, enviroment: Enviroment) {
        self.balanceProvider = balanceProvider
        self.enviroment = enviroment
    }
    
    public func reservedBalances(query: MatcherService.Query.ReservedBalances) -> Observable<[String: Int64]> {
        
        return self
            .balanceProvider
            .rx
            .request(.init(kind: .getReservedBalances(query),
                           matcherUrl: enviroment.dataUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map([String: Int64].self)
            .asObservable()
    }
}
