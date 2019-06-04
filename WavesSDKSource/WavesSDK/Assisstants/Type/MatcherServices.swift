//
//  MatcherServices.swift
//  Alamofire
//
//  Created by rprokofev on 03/06/2019.
//

import Foundation

internal final class MatcherServices: InternalWavesService, MatcherServicesProtocol {
    
    private(set) var balanceMatcherService: BalanceMatcherServiceProtocol
    
    private(set) var orderBookMatcherService: OrderBookMatcherServiceProtocol
    
    private(set) var publicKeyMatcherService: PublicKeyMatcherServiceProtocol
    
    init(plugins: [PluginType],
         enviroment: Enviroment) {
        
        
        balanceMatcherService = BalanceMatcherService(balanceProvider: MatcherServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        orderBookMatcherService = OrderBookMatcherService(orderBookProvider: MatcherServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        publicKeyMatcherService = PublicKeyMatcherService(publicKeyProvider: MatcherServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        
        super.init(enviroment: enviroment)
    }
}
