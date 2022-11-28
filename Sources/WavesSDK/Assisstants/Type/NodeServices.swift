//
//  NodeServices.swift
//  Alamofire
//
//  Created by rprokofev on 03/06/2019.
//

import Foundation
import Moya

internal final class NodeServices: InternalWavesService, NodeServicesProtocol {
    
    private(set) var addressesNodeService: AddressesNodeServiceProtocol
    
    private(set) var assetsNodeService: AssetsNodeServiceProtocol
    
    private(set) var blocksNodeService: BlocksNodeServiceProtocol
    
    private(set) var leasingNodeService: LeasingNodeServiceProtocol
    
    private(set) var transactionNodeService: TransactionNodeServiceProtocol
    
    private(set) var utilsNodeService: UtilsNodeServiceProtocol
    
    override var enviroment: WavesEnvironment {
        
        didSet {
            
            [addressesNodeService,
             assetsNodeService,
             blocksNodeService,
             leasingNodeService,
             transactionNodeService,
             utilsNodeService]
                .map { $0 as? InternalWavesService }
                .compactMap { $0 }
                .forEach { $0.enviroment = enviroment }
        }
    }
    
    init(plugins: [PluginType],
         enviroment: WavesEnvironment) {
        
        addressesNodeService = AddressesNodeService(addressesProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        assetsNodeService = AssetsNodeService(assetsProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        blocksNodeService = BlocksNodeService(blocksProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        leasingNodeService = LeasingNodeService(leasingProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        transactionNodeService = TransactionNodeService(transactionsProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        utilsNodeService = UtilsNodeService(utilsProvider: NodeServices.moyaProvider(plugins: plugins), enviroment: enviroment)
        
        super.init(enviroment: enviroment)
    }
}
