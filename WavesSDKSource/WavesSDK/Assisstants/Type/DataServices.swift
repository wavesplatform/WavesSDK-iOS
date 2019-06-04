//
//  DataServices.swift
//  Alamofire
//
//  Created by rprokofev on 03/06/2019.
//

import Foundation

internal final class DataServices: InternalWavesService, DataServicesProtocol {
    
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
