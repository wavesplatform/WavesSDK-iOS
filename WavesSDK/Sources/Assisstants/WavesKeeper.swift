//
//  WavesKeeper.swift
//  WavesSDK
//
//  Created by rprokofev on 27.08.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto

public class WavesKeeper {
    
    public struct Application {
        public let name: String
        public let iconUrl: String
        public let scheme: String
        
        public init(name: String, iconUrl: String, scheme: String) {
            self.name = name
            self.iconUrl = iconUrl
            self.scheme = scheme
        }
    }
    
    public enum Transaction {
        case send(Transfer)
        case invokeScript(InvokeScript)
        case data(Data)
    }
    
    public enum Action {
        case sign
        case send
    }
    
    public struct Data {
        public let dApp: Application
        public let action: Action
        public let transaction: Transaction
        
        public init(dApp: Application, action: Action, transaction: Transaction) {
            self.dApp = dApp
            self.action = action
            self.transaction = transaction
        }
    }
    
    public enum Callback {
        case reject
        case approve
        case error
    }
    
    public init() {}
    
    func sendToWallet(data: Data) -> Bool {
        return false
    }
    
    func send(dApp: Application, callback: Callback) -> Bool {
        return false
    }
    
    func decodableCallback(_ url: URL, sourceApplication: String) -> Callback? {
        return nil
    }
    
    public func decodableData(_ url: URL, sourceApplication: String) -> Data? {
        
        return Data.init(dApp: .init(name: "Test",
                                     iconUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdF37xBUCZDiNuteNQRfQBTadMGcv25qpDRir40U5ILLYXp7uL", scheme: ""),
                         action: .send,
                         transaction: .send(.init(recipient: "3P5r1EXZwxJ21f3T3zvjx61RtY52QV4fb18",
                                                  assetId: "WAVES",
                                                  amount: 1000,
                                                  fee: 10000,
                                                  attachment: "",
                                                  feeAssetID: "WAVES",
                                                  chainId: "W")))
    }
}

public extension WavesKeeper.Transaction {
    
    struct Transfer {
        public let recipient: String
        public let assetId: String
        public let amount: Int64
        public let fee: Int64
        public let attachment: String
        public let feeAssetID: String
        public let chainId: String
        public let version: Int = TransactionVersion.version_2.rawValue
        
        public init(recipient: String,
                    assetId: String,
                    amount: Int64,
                    fee: Int64,
                    attachment: String,
                    feeAssetID: String,
                    chainId: String) {
            self.recipient = recipient
            self.assetId = assetId
            self.amount = amount
            self.fee = fee
            self.attachment = attachment
            self.feeAssetID = feeAssetID
            self.chainId = chainId
        }
    }

    struct Data {
        public struct Value {
            public enum Kind {
                case integer(Int64)
                case boolean(Bool)
                case string(String)
                case binary(Base64)
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
        public let chainId: String
        public let version: Int = TransactionVersion.version_1.rawValue
        
        public init(fee: Int64, data: [Value], chainId: String) {
            self.fee = fee
            self.data = data
            self.chainId = chainId
        }
    }
    
    struct InvokeScript {
        
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
        
        public let fee: Int64
        public let chainId: String
        public let feeAssetId: String
        public let dApp: String
        public let call: Call?
        public let payment: [Payment]
        public let version: Int = TransactionVersion.version_1.rawValue
        
        public init(fee: Int64,
                    chainId: String,
                    feeAssetId: String,
                    dApp: String,
                    call: Call?,
                    payment: [Payment]) {
            self.fee = fee
            self.chainId = chainId
            self.feeAssetId = feeAssetId
            self.dApp = dApp
            self.call = call
            self.payment = payment
        }
    }
}
