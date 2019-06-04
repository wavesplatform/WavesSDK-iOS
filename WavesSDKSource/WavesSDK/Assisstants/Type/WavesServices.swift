//
//  ServicesFactoryProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 07/05/2019.
//

import Foundation

internal final class WavesServices: InternalWavesService, WavesServicesProtocol {
    
    private(set) var nodeServices: NodeServicesProtocol
    private(set) var dataServices: DataServicesProtocol
    private(set) var matcherServices: MatcherServicesProtocol
    
    override var enviroment: Enviroment {
        
        didSet {
//            self.nodeServices.enviroment = enviroment
//            self.matcherServices.enviroment = enviroment
//            self.dataServices.enviroment = enviroment
        }
    }
    
    init(enviroment: Enviroment,
         dataServicePlugins: [PluginType],
         nodeServicePlugins: [PluginType],
         matcherServicePlugins: [PluginType]) {
        
        self.nodeServices = NodeServices(plugins: nodeServicePlugins,
                                         enviroment: enviroment)
        
        self.dataServices = DataServices(plugins: dataServicePlugins,
                                               enviroment: enviroment)
        
        self.matcherServices = MatcherServices(plugins: matcherServicePlugins,
                                               enviroment: enviroment)
        
        super.init(enviroment: enviroment)
    }
}


private final class DataServices: InternalWavesService, DataServicesProtocol {
    
    public var aliasDataService: AliasDataServiceProtocol
    
    public var assetsDataService: AssetsDataServiceProtocol
    
    public var candlesDataService: CandlesDataServiceProtocol
    
    public var pairsPriceDataService: PairsPriceDataServiceProtocol
    
    public var transactionsDataService: TransactionsDataServiceProtocol
    
    init(plugins: [PluginType],
         enviroment: Enviroment) {
        
        aliasDataService = AliasDataService(aliasProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        assetsDataService = AssetsDataService(assetsProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        candlesDataService = CandlesDataService(candlesProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        pairsPriceDataService = PairsPriceDataService(pairsPriceProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        transactionsDataService = TransactionsDataService(transactionsProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        
        super.init(enviroment: enviroment)
    }
}
