//
//  TransactionSignatureV1.swift
//  WavesSDKExample
//
//  Created by rprokofev on 01.07.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto


public extension TransactionSignatureV1 {
    
    enum Structure {

        public struct Sponsorship {
            
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64
            public let assetId: String
            public let minSponsoredAssetFee: Int64?
            
            
            public init(fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64, assetId: String, minSponsoredAssetFee: Int64?) {
                self.fee = fee
                self.minSponsoredAssetFee = minSponsoredAssetFee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
                self.assetId = assetId
            }
        }
        
        public struct SetScript {
    
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64
            public let script: Base64?
            
            
            public init(fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64, script: Base64?) {
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
                self.script = script
            }
        }
        
        public struct SetAssetScript {
            
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64
            public let assetId: String
            public let script: Base64?
            
            public init(fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64, assetId: String, script: Base64?) {
                self.fee = fee
                self.chainId = chainId
                self.assetId = assetId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
                self.script = script
            }
        }
        
        public struct MassTransfer {
            
            public struct Transfer {
                public let recipient: String
                public let amount: Int64

                public init(recipient: String, amount: Int64) {
                    self.recipient = recipient
                    self.amount = amount
                }
            }
            
            public let fee: Int64
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64
            public let assetId: String
            public let attachment: String
            public let transfers: [Transfer]

            public init(fee: Int64, chainId: UInt8, senderPublicKey: String, timestamp: Int64, assetId: String, attachment: String, transfers: [Transfer]) {
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
                self.assetId = assetId
                self.attachment = attachment
                self.transfers = transfers
            }
        }
        
        public struct Data {
            public struct Value {
                public enum Kind {
                    case integer(Int64)
                    case boolean(Bool)
                    case string(String)
                    case binary(Base64)
                }
                
                public let key: String
                public let value: Kind?
                
                public init(key: String, value: Kind?) {
                    self.key = key
                    self.value = value
                }
            }
            
            public let fee: Int64
            public let data: [Value]
            public let chainId: UInt8
            public let senderPublicKey: String
            public let timestamp: Int64
            
            public init(fee: Int64, data: [Value], chainId: UInt8, senderPublicKey: String, timestamp: Int64) {
                self.fee = fee
                self.data = data
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct InvokeScript {
            
            public struct Arg {
                public enum Value {
                    case bool(Bool) //boolean
                    case integer(Int64) // integer
                    case string(String) // string
                    case binary(String) // binary
                }
                
                public let value: Value

                public init(value: Value) {
                    self.value = value
                }
            }
            
            public struct Call {
                public let function: String
                public let args: [Arg]

                public init(function: String, args: [Arg]) {
                    self.function = function
                    self.args = args
                }
            }
            
            public struct Payment {
                public let amount: Int64
                public let assetId: String

                public init(amount: Int64, assetId: String) {
                    self.amount = amount
                    self.assetId = assetId
                }
            }
            
            public let senderPublicKey: WavesSDKCrypto.PublicKey
            public let fee: Int64
            public let chainId: UInt8
            public let timestamp: Int64
            public let feeAssetId: String?
            public let dApp: String
            public let call: Call?
            public let payment: [Payment]

            public init(senderPublicKey: WavesSDKCrypto.PublicKey, fee: Int64, chainId: UInt8, timestamp: Int64, feeAssetId: String?, dApp: String, call: Call?, payment: [Payment]) {
                self.senderPublicKey = senderPublicKey
                self.fee = fee
                self.chainId = chainId
                self.timestamp = timestamp
                self.feeAssetId = feeAssetId
                self.dApp = dApp
                self.call = call
                self.payment = payment
            }
        }
    }
}


public enum TransactionSignatureV1: TransactionSignatureProtocol {
    
    case data(Structure.Data)
    case invokeScript(Structure.InvokeScript)
    case massTransfer(Structure.MassTransfer)
    case setScript(Structure.SetScript)
    case setAssetScript(Structure.SetAssetScript)
    case sponsorship(Structure.Sponsorship)
    
    public var version: Int {
        return 1
    }
    
    public var type: TransactionType {
        switch self {
        case .data:
            return .data
            
        case .invokeScript:
            return .invokeScript
            
        case .massTransfer:
            return .massTransfer
            
        case .setScript:
            return .script
        
        case .setAssetScript:
            return .assetScript
            
        case .sponsorship:
            return .sponsorship
        }
    }
}

public extension TransactionSignatureV1 {
    
    var bytesStructure: WavesSDKCrypto.Bytes {
        
        switch self {

        case .data(let model):
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += model.bytesForSignature
            signature += toByteArray(model.timestamp)
            signature += toByteArray(model.fee)
            return signature
            
        case .invokeScript(let model):
            
            var dApp: [UInt8] = []
            if model.dApp.count <= WavesSDKConstants.aliasNameMaxLimitSymbols {
                dApp += toByteArray(Int8(self.version))
                dApp += toByteArray(Int8(model.chainId))
                dApp += model.dApp.arrayWithSize()
            } else {
                dApp += WavesCrypto.shared.base58decode(input: model.dApp) ?? []
            }
            
            let feeAssetId = model.feeAssetId?.normalizeToNullWavesAssetId
                        
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(Int8(model.chainId))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += dApp
            signature += model.callBytes
            signature += model.paymentBytes
            signature += toByteArray(model.fee)
            if let feeAssetId=feeAssetId as? String, !feeAssetId.isEmpty{
              signature += ([UInt8(1)] + (WavesCrypto.shared.base58decode(input: feeAssetId) ?? []))
            }else{
              signature += [UInt8(0)]
            }
            signature += toByteArray(model.timestamp)
            return signature
            
        case .massTransfer(let model):
            
            let assetId = model.assetId.normalizeWavesAssetId
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += assetId.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base58decode(input: assetId) ?? []))
            signature += model.transfersBytes(version: self.version, chainId: model.chainId)
            signature += toByteArray(model.timestamp)
            signature += toByteArray(model.fee)
            signature += model.attachment.isEmpty == true ? [0, 0] : (WavesCrypto.shared.base58decode(input: model.attachment)?.arrayWithSize() ?? [])
            return signature
            
        case .setScript(let model):

            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(Int8(model.chainId))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += (model.script?.isEmpty ?? true) ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base64decode(input: model.script ?? "") ?? []).arrayWithSize())
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            return signature
            
        case .setAssetScript(let model):
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(Int8(model.chainId))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += WavesCrypto.shared.base58decode(input: model.assetId) ?? []
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            signature += (model.script?.isEmpty ?? true) ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base64decode(input: model.script ?? "") ?? []).arrayWithSize())
            return signature
            
        case .sponsorship(let model):
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += WavesCrypto.shared.base58decode(input: model.assetId) ?? []
            signature += toByteArray(model.minSponsoredAssetFee ?? 0)
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            return signature
        }
    }
}

private extension TransactionSignatureV1.Structure.MassTransfer {
 
    func transfersBytes(version: Int, chainId: UInt8) -> [UInt8] {
        var bytes: [UInt8] = []
        
        for transfer in transfers {
            
            var recipient: [UInt8] = []
            if transfer.recipient.count <= WavesSDKConstants.aliasNameMaxLimitSymbols {
                recipient += toByteArray(Int8(version))
                recipient += toByteArray(Int8(chainId))
                recipient += transfer.recipient.arrayWithSize()
            } else {
                recipient += WavesCrypto.shared.base58decode(input: transfer.recipient) ?? []
            }
            
            bytes += recipient
            bytes += toByteArray(transfer.amount)
        }
        
        bytes = toByteArray(Int16(transfers.count)) + bytes
        return bytes
    }
}

private extension TransactionSignatureV1.Structure.InvokeScript.Call {
    
    var argsBytes: [UInt8] {
        var bytes: [UInt8] = []
        
        for arg in self.args {
            switch arg.value {
            case .binary(let value):
                
                bytes += [1] + (WavesCrypto.shared.base64decode(input: value) ?? []).arrayWithSize32()
                
            case .string(let value):
                
                bytes += [UInt8(2)] + value.arrayWithSize32()
                
            case .integer(let value):
                bytes += [UInt8(0)] + toByteArray(value)
                
            case .bool(let value):
                
                if value {
                    bytes += [6]
                } else {
                    bytes += [7]
                }
            }
        }
        
        bytes = toByteArray(Int32(args.count)) + bytes
        
        return bytes
    }

}

private extension TransactionSignatureV1.Structure.InvokeScript {
    
    var callBytes: [UInt8] {
        if let call = self.call {
            return [1, 9, 1] + call.function.arrayWithSize32() + call.argsBytes
        } else {
            return [0]
        }
    }

    var paymentBytes: [UInt8] {
        var bytes: [UInt8] = []
        
        for paymentItem in self.payment {
            let amount = toByteArray(paymentItem.amount)
            
            let assetIdTrue = paymentItem.assetId.normalizeWavesAssetId
            
            let assetId = assetIdTrue.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base58decode(input: assetIdTrue) ?? []))
            
            bytes += amount
            bytes += assetId
        }
        
        if bytes.count > 0 {
            bytes = toByteArray(Int16(self.payment.count)) + bytes.arrayWithSize()
        } else {
            bytes = toByteArray(Int16(self.payment.count))
        }
        
        return bytes
    }
}


private extension TransactionSignatureV1.Structure.Data {
    
    var bytesForSignature: [UInt8] {
        
        var signature: [UInt8] = []
        signature += toByteArray(Int16(self.data.count))
        
        for value in self.data {
            signature += value.key.arrayWithSize()
            
            //TODO: check nullable
            guard let valueKind = value.value else {
                signature += toByteArray(Int8(0))
                continue
            }
            
            switch valueKind {
            case .binary(let data):
                signature += toByteArray(Int8(2))
                signature += WavesCrypto.shared.base64decode(input: data)?.arrayWithSize() ?? []
                
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
