//
//  BalanceMatcherService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

final class BalanceMatcherService: InternalWavesService, BalanceMatcherServiceProtocol {
    
    private let balanceProvider: MoyaProvider<MatcherService.Target.Balance>
    
    init(balanceProvider: MoyaProvider<MatcherService.Target.Balance>, enviroment: WavesEnvironment) {
        self.balanceProvider = balanceProvider
        super.init(enviroment: enviroment)
    }
    
    public func balanceReserved(query: MatcherService.Query.ReservedBalances) -> Observable<[String: Int64]> {
        
        return self
            .balanceProvider
            .rx
            .request(.init(kind: .getReservedBalances(query),
                           matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map([String: Int64].self)
            .asObservable()
    }
}
