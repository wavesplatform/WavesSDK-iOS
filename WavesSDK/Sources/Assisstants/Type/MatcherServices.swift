//
//  MatcherServices.swift
//  Alamofire
//
//  Created by rprokofev on 03/06/2019.
//

import Foundation
import Moya

internal final class MatcherServices: InternalWavesService, MatcherServicesProtocol {
    
    private(set) var balanceMatcherService: BalanceMatcherServiceProtocol
    
    private(set) var orderBookMatcherService: OrderBookMatcherServiceProtocol
    
    private(set) var publicKeyMatcherService: PublicKeyMatcherServiceProtocol
    
    override var enviroment: WavesEnvironment {
        
        didSet {
            
            [balanceMatcherService,
             orderBookMatcherService,
             publicKeyMatcherService]
                .map { $0 as? InternalWavesService }
                .compactMap { $0 }
                .forEach { $0.enviroment = enviroment }
        }
    }
    
    init(plugins: [PluginType],
         enviroment: WavesEnvironment) {
        
        
        balanceMatcherService = BalanceMatcherService(balanceProvider: MatcherServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        orderBookMatcherService = OrderBookMatcherService(orderBookProvider: MatcherServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        publicKeyMatcherService = PublicKeyMatcherService(publicKeyProvider: MatcherServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        
        super.init(enviroment: enviroment)
    }
}
