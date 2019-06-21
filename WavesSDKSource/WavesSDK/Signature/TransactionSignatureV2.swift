//
//  TransactionSignature.swift
//  WavesSDKUI
//
//  Created by rprokofev on 23/05/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto
import WavesSDKExtension

enum TransactionType: Int8 {
    case issue = 3
    case transfer = 4
    case reissue = 5
    case burn = 6
    case exchange = 7
    case lease = 8
    case cancelLease = 9
    case alias = 10
    case massTransfer = 11
    case data = 12
    case script = 13
    case sponsorship = 14
    case assetScript = 15
    case invokeScript = 16
}

public extension TransactionSignatureV2 {
    
    public enum Structure {

        public struct Alias {
            public let alias: String
            public let fee: Int64
            public let scheme: String
            public let senderPublicKey: String
            public let timestamp: Int64

            public init(alias: String, fee: Int64, scheme: String, senderPublicKey: String, timestamp: Int64) {
                self.alias = alias
                self.fee = fee
                self.scheme = scheme
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct Lease {
            public let recipient: String
            public let amount: Int64
            public let fee: Int64
            public let scheme: String
            public let senderPublicKey: String
            public let timestamp: Int64
            
            public init(recipient: String, amount: Int64, fee: Int64, scheme: String, senderPublicKey: String, timestamp: Int64) {
                self.recipient = recipient
                self.amount = amount
                self.fee = fee
                self.scheme = scheme
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct Burn {
            public let assetID: String
            public let quantity: Int64
            public let fee: Int64
            public let scheme: String
            public let senderPublicKey: String
            public let timestamp: Int64

            public init(assetID: String, quantity: Int64, fee: Int64, scheme: String, senderPublicKey: String, timestamp: Int64) {
                self.assetID = assetID
                self.quantity = quantity
                self.fee = fee
                self.scheme = scheme
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct CancelLease {
            public let leaseId: String
            public let fee: Int64
            public let scheme: String
            public let senderPublicKey: String
            public let timestamp: Int64

            public init(leaseId: String, fee: Int64, scheme: String, senderPublicKey: String, timestamp: Int64) {
                self.leaseId = leaseId
                self.fee = fee
                self.scheme = scheme
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct Data {
            public struct Value {
                public enum Kind {
                    case integer(Int64)
                    case boolean(Bool)
                    case string(String)
                    case binary([UInt8])
                }
                
                public let key: String
                public let value: Kind

                public init(key: String, value: Kind) {
                    self.key = key
                    self.value = value
                }
            }
            
            public let fee: Int64
            public let data: [Value]
            public let scheme: String
            public let senderPublicKey: String
            public let timestamp: Int64
            
            public init(fee: Int64, data: [Value], scheme: String, senderPublicKey: String, timestamp: Int64) {
                self.fee = fee
                self.data = data
                self.scheme = scheme
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
            public let scheme: String
            public let timestamp: Int64

            public init(senderPublicKey: String, recipient: String, assetId: String, amount: Int64, fee: Int64, attachment: String, feeAssetID: String, scheme: String, timestamp: Int64) {
                self.senderPublicKey = senderPublicKey
                self.recipient = recipient
                self.assetId = assetId
                self.amount = amount
                self.fee = fee
                self.attachment = attachment
                self.feeAssetID = feeAssetID
                self.scheme = scheme
                self.timestamp = timestamp
            }
        }
    }
}

private extension TransactionSignatureV2.Structure.Data {
    
    var bytesForSignature: [UInt8] {
        
        var signature: [UInt8] = []
        signature += toByteArray(Int16(self.data.count))
        
        for value in self.data {
            signature += value.key.arrayWithSize()
            
            switch value.value {
            case .binary(let data):
                signature += toByteArray(Int8(2))
                signature += data.arrayWithSize()
                
            case .integer(let number):
                signature += toByteArray(Int8(0))
                signature += toByteArray(number)
                
            case .boolean(let flag):
                signature += toByteArray(Int8(1))
                signature += toByteArray(flag)
                
            case .string(let str):
                signature += toByteArray(Int8(3))
                signature += str.arrayWithSize()
            }
        }
        return signature
    }
}


public enum TransactionSignatureV2: TransactionSignatureProtocol {
    
    case createAlias(Structure.Alias)
    case startLease(Structure.Lease)
    case burn(Structure.Burn)
    case cancelLease(Structure.CancelLease)
    case data(Structure.Data)
    case transfer(Structure.Transfer)
    
    public var version: Int {
        return 2
    }
    
    public var typeByte: Int8 {
        switch self {
        case .burn:
            return TransactionType.burn.rawValue
        
        case .createAlias:
            return TransactionType.alias.rawValue
            
        case .cancelLease:
            return TransactionType.cancelLease.rawValue
            
        case .data:
            return TransactionType.data.rawValue
            
        case .startLease:
            return TransactionType.lease.rawValue
            
        case .transfer:
            return TransactionType.transfer.rawValue
            
        }
    }
}

public extension TransactionSignatureV2 {
    
    var bytesStructure: WavesSDKCrypto.Bytes {
        
        switch self {
        case .createAlias(let model):
            
            var alias: [UInt8] = toByteArray(Int8(self.version))
            alias += model.scheme.utf8
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
                recipient += model.scheme.utf8
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
            signature += model.scheme.utf8
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
            signature += model.scheme.utf8
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            signature += leaseId
            return signature
        
        case .data(let model):
            //TODO: check size
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += model.bytesForSignature
            signature += toByteArray(model.timestamp)
            signature += toByteArray(model.fee)
            return signature
            
        case .transfer(let model):
            
            var recipient: [UInt8] = []
            if model.recipient.count <= WavesSDKConstants.aliasNameMaxLimitSymbols {
                recipient += toByteArray(Int8(self.version))
                recipient += model.scheme.utf8
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
            signature += model.attachment.arrayWithSize()
            
            return signature
            
        default:
            return []
        }
        
        return []
    }
}
