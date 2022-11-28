//
//  TransactionsService.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

import Moya

fileprivate enum Constants {
  static let transactions = "transactions"
  static let limit = "limit"
  static let address = "address"
  static let info = "info"
  static let broadcast = "broadcast"
  static let calculateFee = "calculateFee"

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

//TODO: - need take parameter name from Constants

public extension NodeService.Query.Transaction {

  var params: [String: Any] {
    switch self {
      case .burn(let burn):
        return  [Constants.version: burn.version,
                 Constants.chainId: burn.chainId,
                 Constants.senderPublicKey: burn.senderPublicKey,
                 Constants.quantity: burn.quantity,
                 Constants.fee: burn.fee,
                 Constants.timestamp: burn.timestamp,
                 Constants.proofs: burn.proofs,
                 Constants.type: burn.type,
                 Constants.assetId: burn.assetId.normalizeWavesAssetId]

      case .createAlias(let alias):
        return [Constants.version: alias.version,
                Constants.alias: alias.name,
                Constants.fee: alias.fee,
                Constants.timestamp: alias.timestamp,
                Constants.type: alias.type,
                Constants.senderPublicKey: alias.senderPublicKey,
                Constants.proofs: alias.proofs]

      case .startLease(let lease):
        let chainId: UInt8 = lease.chainId
        return  [Constants.version: lease.version,
                 Constants.chainId: chainId,
                 Constants.senderPublicKey: lease.senderPublicKey,
                 Constants.recipient: lease.recipient,
                 Constants.amount: lease.amount,
                 Constants.fee: lease.fee,
                 Constants.timestamp: lease.timestamp,
                 Constants.proofs: lease.proofs,
                 Constants.type: lease.type]

      case .cancelLease(let lease):
        let scheme: UInt8 = lease.chainId
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

      case .transfer(let model):

        return [Constants.type: model.type,
                Constants.senderPublicKey : model.senderPublicKey,
                Constants.fee: model.fee,
                Constants.timestamp: model.timestamp,
                Constants.proofs: model.proofs,
                Constants.version: model.version,
                Constants.recipient: model.recipient,
                Constants.assetId: model.assetId.normalizeWavesAssetId,
                Constants.feeAssetId: model.feeAssetId.normalizeWavesAssetId,
                Constants.amount: model.amount,
                Constants.attachment: model.attachment]
      case .invokeScript(let model):

        var params = [Constants.version: model.version,
                      Constants.senderPublicKey: model.senderPublicKey,
                      Constants.fee: model.fee,
                      Constants.timestamp: model.timestamp,
                      Constants.proofs: model.proofs,
                      Constants.type: model.type] as [String : Any]

        params["feeAssetId"] = model.feeAssetId?.normalizeToNullWavesAssetId
        params["dApp"] = model.dApp

        if let call = model.call {
          params["call"] = call.params()
        }

        params["payment"] = model.payment.map { $0.params() }

        return params
        
      case .reissue(let model):

        var params = [Constants.version: model.version,
                      Constants.senderPublicKey: model.senderPublicKey,
                      Constants.fee: model.fee,
                      Constants.timestamp: model.timestamp,
                      Constants.proofs: model.proofs,
                      Constants.type: model.type] as [String : Any]

        params["assetId"] = model.assetId.normalizeWavesAssetId
        params["quantity"] = model.quantity
        params["reissuable"] = model.isReissuable

        return params

      case .issue(let model):

        var params = [Constants.version: model.version,
                      Constants.senderPublicKey: model.senderPublicKey,
                      Constants.fee: model.fee,
                      Constants.timestamp: model.timestamp,
                      Constants.proofs: model.proofs,
                      Constants.type: model.type] as [String : Any]

        params["name"] = model.name
        params["description"] = model.description
        params["quantity"] = model.quantity
        params["decimals"] = model.decimals
        params["reissuable"] = model.isReissuable
        params["script"] = model.script

        return params
        
      case .massTransfer(let model):

        var params = [Constants.type: model.type,
                      Constants.senderPublicKey : model.senderPublicKey,
                      Constants.fee: model.fee,
                      Constants.timestamp: model.timestamp,
                      Constants.proofs: model.proofs,
                      Constants.version: model.version] as [String : Any]

        params[Constants.attachment] = model.attachment

        params["assetId"] = model.assetId.normalizeWavesAssetId
        params["transfers"] = model.transfers.map {
          return ["recipient": $0.recipient, "amount": $0.amount]
        }

        return params

      case .setScript(let model):

        var params = [Constants.type: model.type,
                      Constants.senderPublicKey : model.senderPublicKey,
                      Constants.fee: model.fee,
                      Constants.timestamp: model.timestamp,
                      Constants.proofs: model.proofs,
                      Constants.version: model.version] as [String : Any]

        params["script"] = model.script

        return params

      case .setAssetScript(let model):

        var params = [Constants.type: model.type,
                      Constants.senderPublicKey : model.senderPublicKey,
                      Constants.fee: model.fee,
                      Constants.timestamp: model.timestamp,
                      Constants.proofs: model.proofs,
                      Constants.version: model.version] as [String : Any]
        
        params["script"] = model.script
        params["assetId"] = model.assetId.normalizeWavesAssetId
        
        return params

      case .sponsorship(let model):

        var params = [Constants.type: model.type,
                      Constants.senderPublicKey : model.senderPublicKey,
                      Constants.fee: model.fee,
                      Constants.timestamp: model.timestamp,
                      Constants.proofs: model.proofs,
                      Constants.version: model.version] as [String : Any]

        params["minSponsoredAssetFee"] = model.minSponsoredAssetFee
        params["assetId"] = model.assetId.normalizeWavesAssetId

        return params
    }
  }

}

extension NodeService.Target {

  struct Transaction {

    public enum Kind {

      case list(address: String, limit: Int)

      case info(id: String)

      case broadcast(NodeService.Query.Transaction)

      case calculateFee(NodeService.Query.Transaction)
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

      case .calculateFee:
        return Constants.transactions + "/" + Constants.calculateFee

    }
  }

  var method: Moya.Method {
    switch kind {
      case .list, .info:
        return .get
      case .broadcast, .calculateFee:
        return .post
    }
  }

  var task: Task {
    switch kind {
      case .list, .info:
        return .requestPlain

      case .broadcast(let specification):
        return .requestParameters(parameters: specification.params, encoding: JSONEncoding.default)
        
      case .calculateFee(let specification):
        return .requestParameters(parameters: specification.params, encoding: JSONEncoding.default)
    }
  }
}

fileprivate extension Array where Element == NodeService.Query.Transaction.Data.Value {

  var dataByParams: [[String: Any]] {

    var list: [[String: Any]] = .init()

    for value in self {
      list.append(value.params())
    }

    return list
  }
}

fileprivate extension NodeService.Query.Transaction.Data.Value {

  func params() -> [String: Any] {

    var params: [String: Any] = .init()

    params["key"] = self.key

    guard let value = self.value else { return params }

    switch value {
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

fileprivate extension NodeService.Query.Transaction.InvokeScript.Call {

  func params() -> [String: Any] {

    var params: [String: Any] = .init()

    params["function"] = self.function
    params["args"] = self.args.map { $0.params() }

    return params
  }
}

fileprivate extension NodeService.Query.Transaction.InvokeScript.Arg {

  func params() -> [String: Any] {

    var params: [String: Any] = .init()

    switch self.value {
      case .binary(let value):
        params["type"] = "binary"
        params["value"] = value

      case .bool(let value):
        params["type"] = "boolean"
        params["value"] = value

      case .integer(let value):
        params["type"] = "integer"
        params["value"] = value

      case .string(let value):
        params["type"] = "string"
        params["value"] = value
    }

    return params
  }
}

fileprivate extension NodeService.Query.Transaction.InvokeScript.Payment {

  func params() -> [String: Any] {

    var params: [String: Any] = .init()

    params["amount"] = self.amount
    params["assetId"] = self.assetId.isEmpty == true ? NSNull() : self.assetId.normalizeToNullWavesAssetId

    return params
  }
}
