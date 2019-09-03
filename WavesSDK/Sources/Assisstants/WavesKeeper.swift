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
    
    //Method For DApp
    public func send(_ tx: NodeService.Query.Transaction) {
        
        let request = prepareRequest(tx: tx,
                                     action: .send)
        send(request)
    }
    
    //Method For DApp
    public func sign(_ tx: NodeService.Query.Transaction){
        let request = prepareRequest(tx: tx,
                                     action: .sign)
        send(request)
    }
    
    //TODO: Pavel
    //TODO: Callback For DApp
    public func decodableResponse(_ url: URL, sourceApplication: String) -> Response? {
        
//        url -> Reponse
        // parser url and return response
        return nil
    }
    
    
    //TODO: Pavel
    //TODO: Method For DApp
    private func send(_ request: Request) {
        
        // request -> URL
        
        // DApp request send to wallet
        
        UIApplication.shared.open(URL.init(string: "\(application.schemeUrl)://arg1=3&arg2=4")!, options: .init(), completionHandler: nil)
    }
    
    private func prepareRequest(tx: NodeService.Query.Transaction, action: Action) -> Request {
        
        return Request(dApp: application,
                       action: action,
                       transaction: tx)
    }
}

public extension WavesKeeper {
    
    struct Application: Codable {
        public let name: String
        public let iconUrl: String
        public let schemeUrl: String
        
        public init(name: String, iconUrl: String, schemeUrl: String) {
            self.name = name
            self.iconUrl = iconUrl
            self.schemeUrl = schemeUrl
        }
        
        var parameters: [String: String] {
            return ["appName": self.name,
                    "iconUrl": self.iconUrl,
                    "schemeUrl": self.schemeUrl]
        }
    }
    
    enum Action: Int, Codable {
        case sign
        case send
        
        var parameters: [String: String] {
            return ["kind": self == .send ? "send" : "sign"]
        }
    }
    
    struct Request: Codable {
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
        
        var parameters: [String: String] {
            
            let dAppParameters = dApp.parameters
            let actionParameters = action.parameters
            let transactionParameters = transaction.parameters
            
            
            return ["kind": ""]
        }
    }
    
    /*
    только 3 транзакции
     case data
     case transfer
     case invokeScript
 */
    enum Success {
        case sign(NodeService.Query.Transaction)
        case send(NodeService.DTO.Transaction)
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


fileprivate extension WavesKeeper.Success {
    
    var parameters: [String: String] {
        
        switch self {
        case .sign(let queryTransaction):
            
            var param: [String: String] = .init()
            param["successType"] = "sign"
            param.merge(queryTransaction.parameters) { (value1, value2) -> String in
                if value1 == value2 {
                    return value1
                } else {
                    return "conflict_\(value2)"
                }
            }
            
            return param
            
        case .send(let transaction):
            
            var param: [String: String] = .init()
            param["successType"] = "send"
            param.merge(transaction.parameters) { (value1, value2) -> String in
                if value1 == value2 {
                    return value1
                } else {
                    return "conflict_\(value2)"
                }
            }
            
            return param
        }
    }
}


fileprivate extension WavesKeeper.Response {
    
    var parameters: [String: String] {
        
        switch self {
        case .success(let success):
            
            var param: [String: String] = .init()
            param["success"] = "1"
            
            switch success {
            case .send(let model):
                model.parameters
            case .sign(let model):
                model.parameters
            }
            
            return param
            
        case .error(let error):
            
            var param: [String: String] = .init()
            param["success"] = "0"
            param.merge(error.parameters) { (value1, value2) -> String in
                if value1 == value2 {
                    return value1
                } else {
                    return "conflict_\(value2)"
                }
            }
            
            return param
        }
    }
}

fileprivate extension WavesKeeper.Error {
    
    var parameters: [String: String] {
        
        switch self {
        case .reject:
            return ["errorType": "reject"]
            
        case .message(let message, let code):
            return ["errorType": "message",
                    "errorMessage": message,
                    "errorCode": "\(code)"]
        }
    }
}

fileprivate extension NodeService.DTO.Transaction {
    
    var parameters: [String: String] {
        
        switch self {
        case .transfer(let model):
            return .init()
            
        case .invokeScript(let model):
            return .init()
            
        case .data(let model):
            return .init()
            
        default:
            return .init()
        }
    }
}

fileprivate extension NodeService.Query.Transaction {
    
    var parameters: [String: String] {
        
        switch self {
        case .transfer(let model):
            return .init()
            
        case .invokeScript(let model):
            return .init()
            
        case .data(let model):
            return .init()
            
        default:
            return .init()
        }
    }
}
