//
//  BalanceMatcherServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import RxSwift
import Moya

public protocol BalanceMatcherServiceProtocol {
    
    func balanceReserved(query: MatcherService.Query.ReservedBalances) -> Observable<[String: Int64]>
}


