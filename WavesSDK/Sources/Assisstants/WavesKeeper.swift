//
//  WavesKeeper.swift
//  WavesSDK
//
//  Created by rprokofev on 27.08.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto

private enum Constants {

}

public enum URLTypes {

    static let request = "request"
    static let response = "response"

    static let sign = "sign"
    static let send = "send"
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
    
    public func decodableResponse(_ url: URL, sourceApplication: String) -> Response? {
        return url.response()
    }
    
    private func send(_ request: Request) {

        guard let url = request.url() else { return }
                
        UIApplication.shared.open(url, options: .init(), completionHandler: nil)
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
    }
    
    enum Action: String, Codable {
        case sign
        case send
    }
    
    struct Request: Codable {
        public let dApp: Application
        public let action: Action
        public let transaction: NodeService.Query.Transaction
        //TODO: ID
        
        public init(dApp: Application,
                    action: Action,
                    transaction: NodeService.Query.Transaction) {
            self.dApp = dApp
            self.action = action
            self.transaction = transaction
        }
    }
    
    /*
    только 3 транзакции
     case data
     case transfer
     case invokeScript
 */
    enum Success: Codable {
        case sign(NodeService.Query.Transaction)
        case send(NodeService.DTO.Transaction)
    }
    
    enum Error: Codable {
        
        public struct Message: Codable {
            public let message: String
            public let code: Int
            
            public init(message: String, code: Int) {
                self.message = message
                self.code = code
            }
        }
      
        case reject
        case message(Message)
    }
    
    enum Response: Codable {
        case error(Error)
        case success(Success)
    }
}

private extension URL {
    
    func response() -> WavesKeeper.Response? {
        
        guard let component = URLComponents.init(url: self, resolvingAgainstBaseURL: true) else { return nil }
        guard component.path == "keeper/response" else { return nil }
        guard let item = (component.queryItems?.first { $0.name == "data" }) else { return nil }
        guard let value = item.value else { return nil }
        
        let response: WavesKeeper.Response? = value.decodableBase64ToObject()
        
        return response
    }
}


public extension WavesKeeper.Request {
    
    func url() -> URL? {
        
        guard let base64 = self.encodableToBase64 else { return nil }
        
        var component = URLComponents(string: "")
        component?.scheme = WavesSDKConstants.UrlScheme.wallet
        component?.path = "keeper/request"
        component?.queryItems = [URLQueryItem(name: "data", value: base64)]
        
        return try? component?.asURL()
    }
}
