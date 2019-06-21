//
//  TransactionsService.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import WavesSDKExtension
import Moya

fileprivate enum Constants {
    static let transactions = "transactions"
    static let limit = "limit"
    static let address = "address"
    static let info = "info"
    static let broadcast = "broadcast"

    static let version: String = "version"
    static let alias: String = "alias"
    static let fee: String = "fee"
    static let timestamp: String = "timestamp"
    static let type: String = "type"
    static let senderPublicKey: String = "senderPublicKey"
    static let proofs: String = "proofs"
    static let chainId: String = "chainId"
    static let recipient: String = "recipient"
    static let amount: String = "amount"
    static let quantity: String = "quantity"
    static let assetId: String = "assetId"
    static let leaseId: String = "leaseId"
    static let data: String = "data"
    static let feeAssetId: String = "feeAssetId"
    static let feeAsset: String = "feeAsset"
    static let attachment: String = "attachment"
}

private extension NodeService.Query.Broadcast {
    
    public var params: [String: Any] {
        switch self {
        case .burn(let burn):
            return  [Constants.version: burn.version,
                     Constants.chainId: burn.scheme,
                     Constants.senderPublicKey: burn.senderPublicKey,
                     Constants.quantity: burn.quantity,
                     Constants.fee: burn.fee,
                     Constants.timestamp: burn.timestamp,
                     Constants.proofs: burn.proofs,
                     Constants.type: burn.type,
                     Constants.assetId: burn.assetId]
            
        case .createAlias(let alias):
            return [Constants.version: alias.version,
                    Constants.alias: alias.name,
                    Constants.fee: alias.fee,
                    Constants.timestamp: alias.timestamp,
                    Constants.type: alias.type,
                    Constants.senderPublicKey: alias.senderPublicKey,
                    Constants.proofs: alias.proofs ?? []]
            
        case .startLease(let lease):
            let scheme: UInt8 = lease.scheme.utf8.last ?? UInt8(0)
            return  [Constants.version: lease.version,
                     Constants.chainId: scheme,
                     Constants.senderPublicKey: lease.senderPublicKey,
                     Constants.recipient: lease.recipient,
                     Constants.amount: lease.amount,
                     Constants.fee: lease.fee,
                     Constants.timestamp: lease.timestamp,
                     Constants.proofs: lease.proofs,
                     Constants.type: lease.type]
            
        case .cancelLease(let lease):
            let scheme: UInt8 = lease.scheme.utf8.last ?? UInt8(0)
            return  [Constants.version: lease.version,
                     Constants.chainId: scheme,
                     Constants.senderPublicKey: lease.senderPublicKey,
                     Constants.fee: lease.fee,
                     Constants.timestamp: lease.timestamp,
                     Constants.proofs: lease.proofs,
                     Constants.type: lease.type,
                     Constants.leaseId: lease.leaseId]
            
        case .data(let data):
            
            return  [Constants.version: data.version,
                     Constants.senderPublicKey: data.senderPublicKey,
                     Constants.fee: data.fee,
                     Constants.timestamp: data.timestamp,
                     Constants.proofs: data.proofs,
                     Constants.type: data.type,
                     Constants.data: data.data.dataByParams]
            
        case .send(let model):
            
            return [Constants.type: model.type,
                    Constants.senderPublicKey : model.senderPublicKey,
                    Constants.fee: model.fee,
                    Constants.timestamp: model.timestamp,
                    Constants.proofs: model.proofs,
                    Constants.version: model.version,
                    Constants.recipient: model.recipient,
                    Constants.assetId: model.assetId,
                    Constants.feeAssetId: model.feeAssetId,
                    Constants.feeAsset: model.feeAsset,
                    Constants.amount: model.amount,
                    Constants.attachment: model.attachment]
        }
    }

}

extension NodeService.Target {

    struct Transaction {

        public enum Kind {
            /**
             Response:
             - Node.DTO.TransactionContainers.self
             */
            case list(address: String, limit: Int)
            /**
             Response:
             - ?
             */
            case info(id: String)

            case broadcast(NodeService.Query.Broadcast)
        }

        var kind: Kind
        var nodeUrl: URL
    }
}

extension NodeService.Target.Transaction: NodeTargetType {
    var modelType: Encodable.Type {
        return String.self
    }

    var path: String {
        switch kind {
        case .list(let address, let limit):
            return Constants.transactions + "/" + Constants.address + "/" + "\(address)".urlEscaped + "/" + Constants.limit + "/" + "\(limit)".urlEscaped
            
        case .info(let id):
            return Constants.transactions + "/" + Constants.info + "/" + "\(id)".urlEscaped

        case .broadcast:
            return Constants.transactions + "/" + Constants.broadcast
        }
    }

    var method: Moya.Method {
        switch kind {
        case .list, .info:
            return .get
        case .broadcast:
            return .post
        }
    }

    var task: Task {
        switch kind {
        case .list, .info:
            return .requestPlain
            
        case .broadcast(let specification):
            return .requestParameters(parameters: specification.params, encoding: JSONEncoding.default)
        }
    }
}

fileprivate extension Array where Element == NodeService.Query.Broadcast.Data.Value {

    var dataByParams: [[String: Any]] {

        var list: [[String: Any]] = .init()

        for value in self {
            list.append(value.params())
        }

        return list
    }
}

fileprivate extension NodeService.Query.Broadcast.Data.Value {

    func params() -> [String: Any] {

        var params: [String: Any] = .init()

        params["key"] = self.key

        switch self.value {
            case .integer(let number):
                params["type"] = "integer"
                params["value"] = number

            case .boolean(let flag):
                params["type"] = "boolean"
                params["value"] = flag

            case .string(let txt):
                params["type"] = "string"
                params["value"] = txt

            case .binary(let binary):
                params["type"] = "binary"
                params["value"] = binary
        }

        return params
    }
}
