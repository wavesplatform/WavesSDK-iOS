//
//  TransactionSignatureV1.swift
//  WavesSDKExample
//
//  Created by rprokofev on 01.07.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto
import WavesSDKExtensions

public extension TransactionSignatureV1 {
    
    public enum Structure {

        public struct Data {
            public struct Value {
                public enum Kind {
                    case integer(Int64)
                    case boolean(Bool)
                    case string(String)
                    case binary(String)
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
        
        public struct InvokeScript {
            
            public struct Arg {
                public enum Value {
                    case bool(Bool) //boolean
                    case integer(Int) // integer
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
            public let scheme: String
            public let timestamp: Int64
            public let feeAssetId: String
            public let dApp: String
            public let call: Call?
            public let payment: [Payment]

            public init(senderPublicKey: WavesSDKCrypto.PublicKey, fee: Int64, scheme: String, timestamp: Int64, feeAssetId: String, dApp: String, call: Call?, payment: [Payment]) {
                self.senderPublicKey = senderPublicKey
                self.fee = fee
                self.scheme = scheme
                self.timestamp = timestamp
                self.feeAssetId = feeAssetId
                self.dApp = dApp
                self.call = call
                self.payment = payment
            }
        }
    }
}

private extension TransactionSignatureV1.Structure.Data {
    
    var bytesForSignature: [UInt8] {
        
        var signature: [UInt8] = []
        signature += toByteArray(Int16(self.data.count))
        
        for value in self.data {
            signature += value.key.arrayWithSize()
            
            switch value.value {
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



public enum TransactionSignatureV1: TransactionSignatureProtocol {
    
    case data(Structure.Data)
    
    case invokeScript(Structure.InvokeScript)
    
    public var version: Int {
        return 1
    }
    
    public var type: TransactionType {
        switch self {
        case .data:
            return .data
            
        case .invokeScript:
            return .invokeScript
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
                dApp += model.scheme.utf8
                dApp += model.dApp.arrayWithSize()
            } else {
                dApp += WavesCrypto.shared.base58decode(input: model.dApp) ?? []
            }
                        
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += model.scheme.utf8
            signature += WavesCrypto.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += dApp
            signature += model.callBytes
            signature += model.paymentBytes
            signature += toByteArray(model.fee)
            signature += model.feeAssetId.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base58decode(input: model.feeAssetId) ?? []))
            signature += toByteArray(model.timestamp)
            return signature
            
        }
    }
}

extension TransactionSignatureV1.Structure.InvokeScript.Call {
    
    var argsBytes: [UInt8] {
        var bytes: [UInt8] = []
        
        for arg in self.args {
            switch arg.value {
            case .binary(let value):
                
                bytes += [1] + (WavesCrypto.shared.base64decode(input: value) ?? []).arrayWithSize32()
                
            case .string(let value):
                
                bytes += [2] + value.arrayWithSize32()
                
            case .integer(let value):
                bytes += [0] + toByteArray(value)
                
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

extension TransactionSignatureV1.Structure.InvokeScript {
    
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
            
            let assetId = paymentItem.assetId.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (WavesCrypto.shared.base58decode(input: paymentItem.assetId) ?? []))
            
            bytes += amount
            bytes += assetId
        }
        
        bytes = toByteArray(Int16(self.payment.count)) + bytes.arrayWithSize()
        
        return bytes
    }
}
