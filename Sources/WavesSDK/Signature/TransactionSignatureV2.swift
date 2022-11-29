//
//  TransactionSignature.swift
//  WavesSDKUI
//
//  Created by rprokofev on 23/05/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto


public extension TransactionSignatureV2 {
    
    enum Structure {

        public struct Reissue {
            
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64
            public let quantity: Int64
            public let assetId: String
            public let isReissuable: Bool
            
            public init(assetId: String, fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64, quantity: Int64, isReissuable: Bool) {
                self.assetId = assetId
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
                self.quantity = quantity
                self.isReissuable = isReissuable
            }
        }
        
        public struct Issue {
            
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64
            public let quantity: Int64
            public let name: String
            public let description: String
            public let script: Base64?
            public let decimals: UInt8
            public let isReissuable: Bool
            
            public init(script: Base64?, fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64, quantity: Int64, isReissuable: Bool, name: String, description: String, decimals: UInt8) {
                self.script = script
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
                self.quantity = quantity
                self.isReissuable = isReissuable
                self.name = name
                self.description = description
                self.decimals = decimals
            }
        }

        
        public struct Alias {
            public let alias: String
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64

            public init(alias: String, fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64) {
                self.alias = alias
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct Lease {
            public let recipient: String
            public let amount: Int64
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64
            
            public init(recipient: String, amount: Int64, fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64) {
                self.recipient = recipient
                self.amount = amount
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct Burn {
            public let assetID: String
            public let quantity: Int64
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64

            public init(assetID: String, quantity: Int64, fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64) {
                self.assetID = assetID
                self.quantity = quantity
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct CancelLease {
            public let leaseId: String
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64

            public init(leaseId: String, fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64) {
                self.leaseId = leaseId
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
                
        public struct Transfer {
            public let senderPublicKey: WavesSDKCrypto.PublicKey
            public let recipient: String
            public let assetId: String
            public let amount: Int64
            public let fee: Int64
            public let attachment: String
            public let feeAssetID: String
            public let chainId: UInt8
            public let timestamp: Int64

            public init(senderPublicKey: String, recipient: String, assetId: String, amount: Int64, fee: Int64, attachment: String, feeAssetID: String, chainId: UInt8, timestamp: Int64) {
                self.senderPublicKey = senderPublicKey
                self.recipient = recipient
                self.assetId = assetId
                self.amount = amount
                self.fee = fee
                self.attachment = attachment
                self.feeAssetID = feeAssetID
                self.chainId = chainId
                self.timestamp = timestamp
            }
        }            
    }
}

public enum TransactionSignatureV2: TransactionSignatureProtocol {
    
    case createAlias(Structure.Alias)
    case startLease(Structure.Lease)
    case burn(Structure.Burn)
    case cancelLease(Structure.CancelLease)
    case transfer(Structure.Transfer)
    case reissue(Structure.Reissue)
    case issue(Structure.Issue)
    
    public var version: Int {
        return 2
    }
    
    public var type: TransactionType {
        switch self {
        case .burn:
            return TransactionType.burn
            
        case .createAlias:
            return TransactionType.createAlias
            
        case .cancelLease:
            return TransactionType.cancelLease
            
        case .startLease:
            return TransactionType.createLease
            
        case .transfer:
            return TransactionType.transfer
        
        case .reissue:
            return TransactionType.reissue
        
        case .issue:
            return TransactionType.issue
        }
    }
}

public extension TransactionSignatureV2 {
    
    var bytesStructure: WavesSDKCrypto.Bytes {
        
        switch self {
        case .createAlias(let model):
            
            var alias: [UInt8] = toByteArray(Int8(self.version))
            alias += toByteArray(UInt8(model.chainId))
            alias += model.alias.arrayWithSize()
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            
            signature += alias.arrayWithSize()
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            return signature
            
        case .startLease(let model):
            
            var recipient: [UInt8] = []
            if model.recipient.count <= WavesSDKConstants.aliasNameMaxLimitSymbols {
                recipient += toByteArray(Int8(self.version))
                recipient += toByteArray(UInt8(model.chainId))
                recipient += model.recipient.arrayWithSize()
            } else {
                recipient += WavesCrypto.shared.base58decode(input: model.recipient) ?? []
            }
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += [0]
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            
            signature += recipient
            signature += toByteArray(model.amount)
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            return signature
            
        case .burn(let model):
            
            let assetId: [UInt8] = WavesCrypto.shared.base58decode(input: model.assetID) ?? []
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(UInt8(model.chainId))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += assetId
            signature += toByteArray(model.quantity)
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            return signature
            
        case .cancelLease(let model):
            
            let leaseId: [UInt8] = WavesCrypto.shared.base58decode(input: model.leaseId) ?? []
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(UInt8(model.chainId))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            signature += leaseId
            return signature
         
        case .transfer(let model):
            
            var recipient: [UInt8] = []
            if model.recipient.count <= WavesSDKConstants.aliasNameMaxLimitSymbols {
                recipient += toByteArray(Int8(self.version))
                recipient += toByteArray(UInt8(model.chainId))
                recipient += model.recipient.arrayWithSize()
            } else {
                recipient += WavesCrypto.shared.base58decode(input: model.recipient) ?? []
            }
            
            let assetId = model.assetId.normalizeWavesAssetId
            let feeAssetID = model.feeAssetID.normalizeWavesAssetId
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += (WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? [])
            signature += assetId.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base58decode(input: assetId) ?? []))
            signature += feeAssetID.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base58decode(input: feeAssetID) ?? []))
            signature += toByteArray(model.timestamp)
            signature += toByteArray(model.amount)
            signature += toByteArray(model.fee)
            signature += recipient
            signature += model.attachment.isEmpty == true ? [UInt8(0), UInt8(0)] : (WavesCrypto.shared.base58decode(input: model.attachment)?.arrayWithSize() ?? [])
            
            return signature
            
        case .reissue(let model):
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(UInt8(model.chainId))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += (WavesCrypto.shared.base58decode(input: model.assetId) ?? [])
            signature += toByteArray(model.quantity)
            signature += model.isReissuable == true ? [1] : [0]
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            
            return signature
            
        case .issue(let model):
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(UInt8(self.version))
            signature += toByteArray(UInt8(model.chainId))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += model.name.arrayWithSize()
            signature += model.description.arrayWithSize()
            signature += toByteArray(model.quantity)
            signature += [model.decimals]
            signature += model.isReissuable == true ? [1] : [0]
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            signature += (model.script?.isEmpty ?? true) ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base64decode(input: model.script ?? "") ?? []).arrayWithSize())
            return signature
        }
    }
}
