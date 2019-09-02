//
//  WavesKeeper.swift
//  WavesSDK
//
//  Created by rprokofev on 27.08.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto


func a() {
    
    let tx = NodeService.Query.Transaction.Transfer.init(recipient: "",
                                                        assetId: "",
                                                        amount: 0,
                                                        fee: 0,
                                                        attachment: "",
                                                        feeAssetId: "",
                                                        chainId: "")
    WavesKeeper.init(application: .init(name: "", iconUrl: "", scheme: "<#T##String#>"))
    
}

public class WavesKeeper {
    
    typealias TransactionV = NodeService.Query.Transaction
    
    static private(set) public var shared: WavesKeeper!
    private(set) public var application: Application
    
    public init(application: Application) {
        self.application = application
    }
    
    public class func isInitialized() -> Bool {
        return WavesKeeper.shared != nil
    }
    
    public class func initialization(application: Application) {
        WavesKeeper.shared = .init(application: application)
    }
    
    public func send(_ tx: NodeService.Query.Transaction) -> Bool {
        
        let request = prepareRequest(tx: tx,
                                     action: .send)
        send(request)
        return true
    }
    
    public func sign(_ tx: NodeService.Query.Transaction) -> Bool {
        let request = prepareRequest(tx: tx,
                                     action: .sign)
        send(request)
        return true
    }
    
    private func prepareRequest(tx: NodeService.Query.Transaction, action: Action) -> Request {
        
        return Request(dApp: application,
                       action: action,
                       transaction: tx)
    }
    
    private func send(_ request: Request) {
        UIApplication.shared.open(URL.init(string: "\(application.scheme)://arg1=3&arg2=4")!, options: .init(), completionHandler: nil)
    }
    
    func returnResponse(_ response: Response) {        
        UIApplication.shared.open(URL.init(string: "\(application.scheme)://arg1=3&arg2=4")!, options: .init(), completionHandler: nil)
    }
    
    public func decodableRequest(_ url: URL, sourceApplication: String) -> Request? {
        
        // parser url and return response
        return nil
    }
    
    public func decodableResponse(_ url: URL, sourceApplication: String) -> Response? {
        
        // parser url and return response
        return nil
    }
    
}

public extension WavesKeeper {
    
    struct Application {
        public let name: String
        public let iconUrl: String
        public let scheme: String
        
        public init(name: String, iconUrl: String, scheme: String) {
            self.name = name
            self.iconUrl = iconUrl
            self.scheme = scheme
        }
    }
    
    enum Action {
        case sign
        case send
    }
    
    struct Request {
        public let dApp: Application
        public let action: Action
        public let transaction: NodeService.Query.Transaction
        
        public init(dApp: Application,
                    action: Action,
                    transaction: NodeService.Query.Transaction) {
            self.dApp = dApp
            self.action = action
            self.transaction = transaction
        }
    }
    
    enum Success {
        case transactionQuery(NodeService.Query.Transaction)
        case transaction(NodeService.DTO.Transaction)
    }
    
    enum Error {
        case reject
        case message(String, Int)
    }
    
    enum Response {
        case error(Error)
        case success(Success)
    }
}

//public extension WavesKeeper.Transaction {
//
//    struct Transfer {
//        public let recipient: String
//        public let assetId: String
//        public let amount: Int64
//        public let fee: Int64
//        public let attachment: String
//        public let feeAssetID: String
//        public let chainId: String
//        public let version: Int = TransactionVersion.version_2.rawValue
//
//        public init(recipient: String,
//                    assetId: String,
//                    amount: Int64,
//                    fee: Int64,
//                    attachment: String,
//                    feeAssetID: String,
//                    chainId: String) {
//            self.recipient = recipient
//            self.assetId = assetId
//            self.amount = amount
//            self.fee = fee
//            self.attachment = attachment
//            self.feeAssetID = feeAssetID
//            self.chainId = chainId
//        }
//    }
//
//    struct Data {
//        public struct Value {
//            public enum Kind {
//                case integer(Int64)
//                case boolean(Bool)
//                case string(String)
//                case binary(Base64)
//            }
//
//            public let key: String
//            public let value: Kind
//
//            public init(key: String, value: Kind) {
//                self.key = key
//                self.value = value
//            }
//        }
//
//        public let fee: Int64
//        public let data: [Value]
//        public let chainId: String
//        public let version: Int = TransactionVersion.version_1.rawValue
//
//        public init(fee: Int64, data: [Value], chainId: String) {
//            self.fee = fee
//            self.data = data
//            self.chainId = chainId
//        }
//    }
//
//    struct InvokeScript {
//
//        public struct Arg {
//            public enum Value {
//                case bool(Bool) //boolean
//                case integer(Int) // integer
//                case string(String) // string
//                case binary(String) // binary
//            }
//
//            public let value: Value
//
//            public init(value: Value) {
//                self.value = value
//            }
//        }
//
//        public struct Call {
//            public let function: String
//            public let args: [Arg]
//
//            public init(function: String, args: [Arg]) {
//                self.function = function
//                self.args = args
//            }
//        }
//
//        public struct Payment {
//            public let amount: Int64
//            public let assetId: String
//
//            public init(amount: Int64, assetId: String) {
//                self.amount = amount
//                self.assetId = assetId
//            }
//        }
//
//        public let fee: Int64
//        public let chainId: String
//        public let feeAssetId: String
//        public let dApp: String
//        public let call: Call?
//        public let payment: [Payment]
//        public let version: Int = TransactionVersion.version_1.rawValue
//
//        public init(fee: Int64,
//                    chainId: String,
//                    feeAssetId: String,
//                    dApp: String,
//                    call: Call?,
//                    payment: [Payment]) {
//            self.fee = fee
//            self.chainId = chainId
//            self.feeAssetId = feeAssetId
//            self.dApp = dApp
//            self.call = call
//            self.payment = payment
//        }
//    }
//}
