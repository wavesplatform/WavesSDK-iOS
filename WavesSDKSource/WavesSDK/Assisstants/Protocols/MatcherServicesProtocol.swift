//
//  MatcherServicesProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 28/05/2019.
//

import Foundation

public protocol MatcherServicesProtocol {
    
    var balanceMatcherService: BalanceMatcherServiceProtocol { get }
    var orderBookMatcherService: OrderBookMatcherServiceProtocol { get }
    var publicKeyMatcherService: PublicKeyMatcherServiceProtocol { get }
}

