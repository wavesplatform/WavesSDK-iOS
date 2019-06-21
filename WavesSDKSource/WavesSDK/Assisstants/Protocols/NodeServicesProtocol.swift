//
//  NodeServicesProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 28/05/2019.
//

import Foundation

public protocol NodeServicesProtocol {
    
    var addressesNodeService: AddressesNodeServiceProtocol { get }
    var assetsNodeService: AssetsNodeServiceProtocol { get }
    var blocksNodeService: BlocksNodeServiceProtocol { get }
    var leasingNodeService: LeasingNodeServiceProtocol { get }
    var transactionNodeService: TransactionNodeServiceProtocol { get }
    var utilsNodeService: UtilsNodeServiceProtocol { get }
}

