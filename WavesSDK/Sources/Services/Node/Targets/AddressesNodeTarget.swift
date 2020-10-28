//
//  NodeAddressesService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 09.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import WavesSDKExtensions
import Moya

extension NodeService.Target {

    struct Addresses {
        enum Kind {
            /**
             Response:
             - Node.Model.AdddressBalance.self
             */
            case getAddressBalance(id: String)

            /**
             Response:
             - DomainLayer.DTO.AddressScriptInfo
             */
            case scriptInfo(id: String)
            
            case getData(address: String, key: String)
        }

        var kind: Kind
        var nodeUrl: URL
    }
}

extension NodeService.Target.Addresses: NodeTargetType {
    fileprivate enum Constants {
        static let addresses = "addresses"
        static let balance = "balance"
        static let scriptInfo = "scriptInfo"
    }

    var path: String {
        switch kind {
        case .getAddressBalance(let id):
            return Constants.addresses + "/" + Constants.balance + "/" + "\(id)".urlEscaped

        case .scriptInfo(let id):
            return Constants.addresses + "/" + Constants.scriptInfo + "/" + "\(id)".urlEscaped
            
        case let .getData(address, key):
            return Constants.addresses + "/" + "data" + "/" + address.urlEscaped + "/" + "\(key)".urlEscaped
        }
    }

    var method: Moya.Method {
        switch kind {
        case .getAddressBalance, .scriptInfo, .getData:
            return .get
        }
    }

    var task: Task {
        switch kind {
        case .getAddressBalance, .scriptInfo, .getData:
            return .requestParameters(parameters: ["r": "\(Date().timeIntervalSince1970)"],
                                      encoding: URLEncoding.default)
        }
    }
}

// MARK: CachePolicyTarget

extension NodeService.Target.Addresses: CachePolicyTarget {
    
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
}
