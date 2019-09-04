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
    static let keeperSchemeKey = "keeper"
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
        
//
//        let req = WavesKeeper.Request(dApp: application,
//                                      action: .send,
//                                      transaction: .transfer(.init(recipient: "recipient_test",
//                                                                   assetId: "assetID_test",
//                                                                   amount: 1,
//                                                                   fee: 2,
//                                                                   attachment: "attachment_test",
//                                                                   feeAssetId: "feeAssetId_test",
//                                                                   chainId: "chaidId_test")))
//
//        let query = req.urlQueryString
//
//        let url = URL(string: "waves://\(query)")
//        print(url?.request)
//
//
//        let error = WavesKeeper.Error.reject
//        let error2 = WavesKeeper.Error.message(.init(message: "dsad", code: 10))
//
//        let dataError = try! JSONEncoder().encode(error)
//        let base64StringError = dataError.base64EncodedString()
//
//        if let data = Data(base64Encoded: base64StringError) {
//            let error = try? JSONDecoder().decode(WavesKeeper.Error.self, from: data)
//            print("error", error)
//
//        }
        
        let success = WavesKeeper.Success.send(.alias(NodeService.DTO.AliasTransaction(type: 0,
                                                                                       id: "",
                                                                                       sender: "",
                                                                                       senderPublicKey: "",
                                                                                       fee: 0,
                                                                                       timestamp: Date(),
                                                                                       version: 0,
                                                                                       height: 0,
                                                                                       signature: "",
                                                                                       proofs: nil,
                                                                                       alias: "")))
        
        do {
            let result = try JSONEncoder().encode(success)
            
        }
        catch {
            print(error)
        }
        
        if let data = try? JSONEncoder().encode(success) {
            
            print("encoded", success)
            let base64EncodedString = data.base64EncodedString()
            
            
            if let newData = Data(base64Encoded: base64EncodedString) {
               let result = try? JSONDecoder().decode(WavesKeeper.Success.self, from: newData)
                print(result)
            }
        }
        
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
        
//        if url.queryParams[URLTypes.transactionAction] == WavesKeeper.Action.send.rawValue {
//
//            print(url.request)
//        }
//        url -> Reponse
        // parser url and return response
        return nil
    }
    
    
    //TODO: Pavel
    //TODO: Method For DApp
    private func send(_ request: Request) {
        
        UIApplication.shared.open(URL(string: "\(application.schemeUrl)://\(request.urlQueryString)")!, options: .init(), completionHandler: nil)
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
    
    enum Action: String, Codable {
        case sign
        case send
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
    
    enum Response {
        case error(Error)
        case success(Success)
    }
}

public extension WavesKeeper.Request {
    
    var urlQueryString: String {
        
        if let data = try? JSONEncoder().encode(self) {
            var string: String = Constants.keeperSchemeKey + "?"
            string += URLTypes.request + "=" + data.base64EncodedString()
            return string
        }
        return ""
    }
}

public extension URL {
    
    var request: WavesKeeper.Request? {
        
        let string = absoluteString
        
        let range = (string as NSString).range(of: Constants.keeperSchemeKey + "?")
        if range.location != NSNotFound {
            let paramsString = (string as NSString).substring(from: range.location + range.length)
            
            let reqRange = (paramsString as NSString).range(of: URLTypes.request + "=")
            if reqRange.location != NSNotFound {
                let base64String = (paramsString as NSString).substring(from: reqRange.location + reqRange.length)
                if let data = Data(base64Encoded: base64String) {
                    return try? JSONDecoder().decode(WavesKeeper.Request.self, from: data)
                }
            }
        }
        
        return nil
    }
    
    var response: WavesKeeper.Response? {
        
        let string = absoluteString
        
        let range = (string as NSString).range(of: Constants.keeperSchemeKey + "?")
        if range.location != NSNotFound {
            let paramsString = (string as NSString).substring(from: range.location + range.length)
            
            let reqRange = (paramsString as NSString).range(of: URLTypes.request + "=")
            if reqRange.location != NSNotFound {
                let base64String = (paramsString as NSString).substring(from: reqRange.location + reqRange.length)
                if let data = Data(base64Encoded: base64String) {
//                    return try? JSONDecoder().decode(WavesKeeper.Response.self, from: data)
                }
            }
        }
        
        return nil
    }
    
}
