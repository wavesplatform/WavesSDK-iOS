//
//  ServicesFactoryProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 07/05/2019.
//

import Foundation
import Moya

public protocol ServicesFactoryProtocol {
    
    var aliasDataService: AliasDataServiceProtocol { get }
    var assetsDataService: AssetsDataServiceProtocol { get }
    var candlesDataService: CandlesDataServiceProtocol { get }
    var pairsPriceDataService: PairsPriceDataServiceProtocol { get }
    var transactionsDataService: TransactionsDataServiceProtocol { get }
    
    var balanceMatcherService: BalanceMatcherServiceProtocol { get }
    var orderBookMatcherService: OrderBookMatcherServiceProtocol { get }
    var publicKeyMatcherService: PublicKeyMatcherServiceProtocol { get }
    
    var addressesNodeService: AddressesNodeServiceProtocol { get }
    var assetsNodeService: AssetsNodeServiceProtocol { get }
    var blocksNodeService: BlocksNodeServiceProtocol { get }
    var leasingNodeService: LeasingNodeServiceProtocol { get }
    var transactionNodeService: TransactionNodeServiceProtocol { get }
    var utilsNodeService: UtilsNodeServiceProtocol { get }
}

public final class ServicesFactory: ServicesFactoryProtocol {
    
    private let dataServicePlugins: [PluginType]
    private let nodeServicePlugins: [PluginType]
    private let matcherrServicePlugins: [PluginType]
    
    init(dataServicePlugins: [PluginType],
        nodeServicePlugins: [PluginType],
        matcherrServicePlugins: [PluginType]) {
        
        self.dataServicePlugins = dataServicePlugins
        self.nodeServicePlugins = nodeServicePlugins
        self.matcherrServicePlugins = matcherrServicePlugins
    }
    
    public private(set) static var shared: ServicesFactory!
    
    public class func initialization(dataServicePlugins: [PluginType],
                                     nodeServicePlugins: [PluginType],
                                     matcherrServicePlugins: [PluginType]) {
        ServicesFactory.shared = ServicesFactory(dataServicePlugins: dataServicePlugins,
                                                 nodeServicePlugins: nodeServicePlugins,
                                                 matcherrServicePlugins: matcherrServicePlugins)
    }
    
    public var aliasDataService: AliasDataServiceProtocol {
        return AliasDataService(aliasProvider: dataMoyaProvider())
    }
    
    public var assetsDataService: AssetsDataServiceProtocol {
        return AssetsDataService(assetsProvider: dataMoyaProvider())
    }
    
    public var candlesDataService: CandlesDataServiceProtocol {
        return CandlesDataService(candlesProvider: dataMoyaProvider())
    }
    
    public var pairsPriceDataService: PairsPriceDataServiceProtocol {
        return PairsPriceDataService(pairsPriceProvider: dataMoyaProvider())
    }
    
    public var transactionsDataService: TransactionsDataServiceProtocol {
        return TransactionsDataService(transactionsProvider: dataMoyaProvider())
    }
    
    public var balanceMatcherService: BalanceMatcherServiceProtocol {
        return BalanceMatcherService(balanceProvider: matcherMoyaProvider())
    }
    
    public var orderBookMatcherService: OrderBookMatcherServiceProtocol {
        return OrderBookMatcherService(orderBookProvider: matcherMoyaProvider())
    }
    
    public var publicKeyMatcherService: PublicKeyMatcherServiceProtocol {
        return PublicKeyMatcherService(publicKeyProvider: matcherMoyaProvider())
    }
    
    public var addressesNodeService: AddressesNodeServiceProtocol {
        return AddressesNodeService(addressesProvider: nodeMoyaProvider())
    }
    
    public var assetsNodeService: AssetsNodeServiceProtocol {
        return AssetsNodeService(assetsProvider: nodeMoyaProvider())
    }
    
    public var blocksNodeService: BlocksNodeServiceProtocol {
        return BlocksNodeService(blocksProvider: nodeMoyaProvider())
    }
    
    public var leasingNodeService: LeasingNodeServiceProtocol {
        return LeasingNodeService(leasingProvider: nodeMoyaProvider())
    }
    
    public var transactionNodeService: TransactionNodeServiceProtocol {
        return TransactionNodeService(transactionsProvider: nodeMoyaProvider())
    }
    
    public var utilsNodeService: UtilsNodeServiceProtocol {
        return UtilsNodeService(utilsProvider: nodeMoyaProvider())
    }
}

fileprivate extension ServicesFactory {
    
    private func dataMoyaProvider<Target: TargetType>() -> MoyaProvider<Target> {
        return MoyaProvider<Target>(callbackQueue: nil,
                                    plugins: dataServicePlugins)
    }
    
    private func matcherMoyaProvider<Target: TargetType>() -> MoyaProvider<Target> {
        return MoyaProvider<Target>(callbackQueue: nil,
                                    plugins: dataServicePlugins)
    }
    
    private func nodeMoyaProvider<Target: TargetType>() -> MoyaProvider<Target> {
        return MoyaProvider<Target>(callbackQueue: nil,
                                    plugins: nodeServicePlugins)
    }
}
