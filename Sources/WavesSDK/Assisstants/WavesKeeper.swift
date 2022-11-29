//
//  WavesKeeper.swift
//  WavesSDK
//
//  Created by rprokofev on 27.08.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesSDKCrypto
import RxSwift

extension WavesKeeper {
    private class RequestOperation {
        let request: WavesKeeper.Request
        let response: ReplaySubject<WavesKeeper.Response>

        public init(request: WavesKeeper.Request, response: ReplaySubject<WavesKeeper.Response>) {
            self.request = request
            self.response = response
        }
    }
}

public class WavesKeeper {
    
    typealias TransactionV = NodeService.Query.Transaction
    
    static private(set) public var shared: WavesKeeper!
    
    private(set) public var application: Application
    
    private lazy var operations: [String: RequestOperation] = .init()
    
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
    public func send(_ tx: NodeService.Query.Transaction) -> Observable<Response> {
        
        let request = prepareRequest(tx: tx,
                                     action: .send)
        return send(request)
    }
    
    //Method For DApp
    public func sign(_ tx: NodeService.Query.Transaction) -> Observable<Response> {
        let request = prepareRequest(tx: tx,
                                     action: .sign)
        return send(request)
    }
    
    public func decodableResponse(_ url: URL, sourceApplication: String) -> Response? {
        return url.response()
    }
    
    public func applicationOpenURL(_ url: URL, _ sourceApplication: String) -> Bool {
        
        guard let response = url.response() else { return false }
        
        guard let operation = operations[response.requestId] else { return false }
        operation.response.onNext(response)
        operation.response.onCompleted()
        removeOperation(response.requestId)
        
        return true
    }
}

private extension WavesKeeper {
    
    private func removeOperation(_ id: String) {
        self.operations.removeValue(forKey: id)
    }
    
    private func send(_ request: Request) -> Observable<Response> {
        
        guard let url = request.url() else {
            return Observable.just(.init(requestId: request.id,
                                         kind: .error(.invalidRequest)))
        }
        
        let replaySubject: ReplaySubject<Response> = ReplaySubject.create(bufferSize: 1)
        
        let operation = RequestOperation(request: request,
                                         response: replaySubject)
        
        self.operations[request.id] = operation

      print("🔹 Open URL:\(url)")
        /*
        UIApplication.shared.open(url, options: .init(), completionHandler: { [weak self] result in
            if result == false {
                
                guard let operation = self?.operations[request.id] else { return }
                operation.response.onNext(.init(requestId: request.id,
                                                kind: .error(.wavesKeeperDontInstall(WavesSDKConstants.appstoreURL))))
                operation.response.onCompleted()
                self?.removeOperation(request.id)
            }
        })
         */
        
        return replaySubject.asObserver()
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
        public let id: String
        
        public init(dApp: Application,
                    action: Action,
                    transaction: NodeService.Query.Transaction) {
            self.dApp = dApp
            self.action = action
            self.transaction = transaction
            self.id = NSUUID().uuidString
        }
    }
    
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
        case wavesKeeperDontInstall(_ appstore: URL)
        case invalidRequest
        case transactionDontSupport
    }
    
    struct Response: Codable {
        public enum Kind: Codable {
            case error(Error)
            case success(Success)
        }
        
        public let requestId: String
        public let kind: Kind

        public init(requestId: String, kind: Kind) {
            self.requestId = requestId
            self.kind = kind
        }
    }
}

private extension URL {
    
    func response() -> WavesKeeper.Response? {
        
        guard let component = URLComponents.init(url: self, resolvingAgainstBaseURL: true) else { return nil }
        guard component.path == "keeper/v1/response" else { return nil }
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
        component?.path = "keeper/v1/request"
        component?.queryItems = [URLQueryItem(name: "data", value: base64)]
        
        return try? component?.asURL()
    }
}
