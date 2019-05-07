//
//  NodeTargetType.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Result
import Moya

public enum Node {}

public extension Node {
    enum DTO {}
    enum Query {}
    internal enum Service {}
}

protocol NodeTargetType: TargetType {
    var nodeUrl: URL { get }
}

extension NodeTargetType {
    
    var baseURL: URL { return nodeUrl }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ContentType.applicationJson.headers
    }
}

extension MoyaProvider {
    
    final class func nodeMoyaProvider<Target: TargetType>() -> MoyaProvider<Target> {
        return MoyaProvider<Target>(callbackQueue: nil,
                            plugins: [])
        //TODO: Library
//        SentryNetworkLoggerPlugin(), NodePlugin()
    }
}

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
