//
//  ServicesFactoryProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 07/05/2019.
//

import Foundation
import Moya

public protocol ServicesProtocol {
    var enviroment: Enviroment { get set }
}

public protocol NodeServicesProtocol: ServicesProtocol {
    
    var addressesNodeService: AddressesNodeServiceProtocol { get }
    var assetsNodeService: AssetsNodeServiceProtocol { get }
    var blocksNodeService: BlocksNodeServiceProtocol { get }
    var leasingNodeService: LeasingNodeServiceProtocol { get }
    var transactionNodeService: TransactionNodeServiceProtocol { get }
    var utilsNodeService: UtilsNodeServiceProtocol { get }
}

public protocol MatcherServicesProtocol: ServicesProtocol {
    
    var balanceMatcherService: BalanceMatcherServiceProtocol { get }
    var orderBookMatcherService: OrderBookMatcherServiceProtocol { get }
    var publicKeyMatcherService: PublicKeyMatcherServiceProtocol { get }
}

public protocol DataServicesProtocol: ServicesProtocol {
    
    var aliasDataService: AliasDataServiceProtocol { get }
    var assetsDataService: AssetsDataServiceProtocol { get }
    var candlesDataService: CandlesDataServiceProtocol { get }
    var pairsPriceDataService: PairsPriceDataServiceProtocol { get }
    var transactionsDataService: TransactionsDataServiceProtocol { get }
}

public protocol WavesServicesProtocol {
    
    var enviroment: Enviroment { get set }
        
    var nodeServices: NodeServicesProtocol { get }
    var dataServices: DataServicesProtocol { get }
    var matcherServices: MatcherServicesProtocol { get }
}

final class WavesServices: WavesServicesProtocol {
    
    var nodeServices: NodeServicesProtocol
    var dataServices: DataServicesProtocol
    var matcherServices: MatcherServicesProtocol
    
    var enviroment: Enviroment {
        didSet {
            self.nodeServices.enviroment = enviroment
            self.matcherServices.enviroment = enviroment
            self.dataServices.enviroment = enviroment
        }
    }
    
    init(enviroment: Enviroment,
         dataServicePlugins: [PluginType],
         nodeServicePlugins: [PluginType],
         matcherServicePlugins: [PluginType]) {
        
        self.enviroment = enviroment
        
        self.nodeServices = NodeServices(plugins: nodeServicePlugins,
                                         enviroment: enviroment)
        
        self.dataServices = DataServices(plugins: dataServicePlugins,
                                               enviroment: enviroment)
        
        self.matcherServices = MatcherServices(plugins: matcherServicePlugins,
                                               enviroment: enviroment)
    }
}

extension ServicesProtocol {
    
    static func moyaProvider<Target: TargetType>(plugins: [PluginType]) -> MoyaProvider<Target> {
        return MoyaProvider<Target>(callbackQueue: nil,
                                    plugins: plugins)
    }
}

private final class NodeServices: ServicesProtocol, NodeServicesProtocol {
    
    var enviroment: Enviroment
    
    private(set) var addressesNodeService: AddressesNodeServiceProtocol
    
    private(set) var assetsNodeService: AssetsNodeServiceProtocol
    
    private(set) var blocksNodeService: BlocksNodeServiceProtocol
    
    private(set) var leasingNodeService: LeasingNodeServiceProtocol
    
    private(set) var transactionNodeService: TransactionNodeServiceProtocol
    
    private(set) var utilsNodeService: UtilsNodeServiceProtocol
    
    init(plugins: [PluginType],
         enviroment: Enviroment) {
        
        self.enviroment = enviroment
        
        addressesNodeService = AddressesNodeService(addressesProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        assetsNodeService = AssetsNodeService(assetsProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        blocksNodeService = BlocksNodeService(blocksProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        leasingNodeService = LeasingNodeService(leasingProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        transactionNodeService = TransactionNodeService(transactionsProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        utilsNodeService = UtilsNodeService(utilsProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
    }
}

private final class MatcherServices: ServicesProtocol, MatcherServicesProtocol {
    
    var enviroment: Enviroment
    
    private(set) var balanceMatcherService: BalanceMatcherServiceProtocol
    
    private(set) var orderBookMatcherService: OrderBookMatcherServiceProtocol
    
    private(set) var publicKeyMatcherService: PublicKeyMatcherServiceProtocol
    
    init(plugins: [PluginType],
         enviroment: Enviroment) {
        
        self.enviroment = enviroment
            
        balanceMatcherService = BalanceMatcherService(balanceProvider: MatcherServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        orderBookMatcherService = OrderBookMatcherService(orderBookProvider: MatcherServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        publicKeyMatcherService = PublicKeyMatcherService(publicKeyProvider: MatcherServices.moyaProvider(plugins: plugins), enviroment: enviroment)
    }
}

private final class DataServices: ServicesProtocol, DataServicesProtocol {
    
    var enviroment: Enviroment
    
    public var aliasDataService: AliasDataServiceProtocol
    
    public var assetsDataService: AssetsDataServiceProtocol
    
    public var candlesDataService: CandlesDataServiceProtocol
    
    public var pairsPriceDataService: PairsPriceDataServiceProtocol
    
    public var transactionsDataService: TransactionsDataServiceProtocol
    
    init(plugins: [PluginType],
         enviroment: Enviroment) {
        
        self.enviroment = enviroment
        
        aliasDataService = AliasDataService(aliasProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        assetsDataService = AssetsDataService(assetsProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        candlesDataService = CandlesDataService(candlesProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        pairsPriceDataService = PairsPriceDataService(pairsPriceProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        transactionsDataService = TransactionsDataService(transactionsProvider: DataServices.moyaProvider(plugins: plugins), enviroment: enviroment)
    }
}
