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
    public func send(_ tx: NodeService.Query.Transaction) -> Bool {
        
        let request = prepareRequest(tx: tx,
                                     action: .send)
        send(request)
        return true
    }
    
    //Method For DApp
    public func sign(_ tx: NodeService.Query.Transaction) -> Bool {
        let request = prepareRequest(tx: tx,
                                     action: .sign)
        send(request)
        return true
    }
    
    //Method For Wallet
    public func returnResponse(_ response: Response) {        
        UIApplication.shared.open(URL.init(string: "\(application.scheme)://arg1=3&arg2=4")!, options: .init(), completionHandler: nil)
    }
    
    //Method For Wallet
    public func decodableRequest(_ url: URL, sourceApplication: String) -> Request? {
        
        // parser url and return response
        return nil
    }
    
    //Method For DApp
    public func decodableResponse(_ url: URL, sourceApplication: String) -> Response? {
        
        // parser url and return response
        return nil
    }
        
    private func prepareRequest(tx: NodeService.Query.Transaction, action: Action) -> Request {
        
        return Request(dApp: application,
                       action: action,
                       transaction: tx)
    }
    
    private func send(_ request: Request) {
        UIApplication.shared.open(URL.init(string: "\(application.scheme)://arg1=3&arg2=4")!, options: .init(), completionHandler: nil)
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
