//
//  DataServices.swift
//  Alamofire
//
//  Created by rprokofev on 03/06/2019.
//

import Foundation
import Moya

internal final class DataServices: InternalWavesService, DataServicesProtocol {
    
    public var aliasDataService: AliasDataServiceProtocol
    
    public var assetsDataService: AssetsDataServiceProtocol
    
    public var candlesDataService: CandlesDataServiceProtocol
    
    public var pairsPriceDataService: PairsPriceDataServiceProtocol
    
    public var transactionsDataService: TransactionsDataServiceProtocol
    
    override var enviroment: WavesEnvironment {
        didSet {
            [aliasDataService,
             assetsDataService,
             candlesDataService,
             pairsPriceDataService,
             transactionsDataService]
                .map { $0 as? InternalWavesService }
                .compactMap { $0 }
                .forEach { $0.enviroment = enviroment }
        }
    }
    
    init(plugins: [PluginType],
         enviroment: WavesEnvironment) {
        
        aliasDataService = AliasDataService(aliasProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        assetsDataService = AssetsDataService(assetsProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        candlesDataService = CandlesDataService(candlesProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        pairsPriceDataService = PairsPriceDataService(pairsPriceProvider: DataServices.moyaProvider(plugins: plugins),
                                                      pairsPriceSearchProvider: DataServices.moyaProvider(plugins: plugins),
                                                      pairsRateProvider: DataServices.moyaProvider(plugins: plugins),
                                                      enviroment: enviroment)
        transactionsDataService = TransactionsDataService(transactionsProvider: DataServices.moyaProvider(plugins: plugins),
                                                          enviroment: enviroment)
        
        super.init(enviroment: enviroment)
    }
}
