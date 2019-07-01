//
//  BalanceMatcherServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import RxSwift
import Moya

public protocol BalanceMatcherServiceProtocol {
    
    //TODO: balanceReserved()
    func reservedBalances(query: MatcherService.Query.ReservedBalances) -> Observable<[String: Int64]>
}


