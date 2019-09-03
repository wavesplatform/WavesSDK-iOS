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

private enum URLTypes {
    
    enum TxType {
        static let transfer = "tx_type_transfer"
        static let data = "tx_type_data"
        static let invokeSctipt = "tx_type_invokeScript"
    }
    
    static let kind = "kind"
    static let callback = "callback"
    static let appName = "appName"
    static let iconUrl = "iconUrl"
    
    static let txType = "tx_type"
    
    static let type = "type"
    static let verison = "version"
    static let chainId = "chainId"
    static let fee = "fee"
    static let recipient = "recipient"
    static let assetId = "assetId"
    static let amount = "amount"
    static let attachment = "attachment"
    static let feeAssetId = "feeAssetId"
    
    static let dApp = "dApp"
    static let call = "call"
    static let callFunction = "callFunction"
    static let callArguments = "callArguments"
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
        
        
        WavesKeeper.shared.send(WavesKeeper.Request(dApp: application,
                                                    action: .send,
                                                    transaction: .transfer(.init(recipient: "recipient_test",
                                                                                 assetId: "assetID_test",
                                                                                 amount: 1,
                                                                                 fee: 2,
                                                                                 attachment: "attachment_test",
                                                                                 feeAssetId: "feeAssetId_test",
                                                                                 chainId: "chaidId_test"))))

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
        
        if url.queryParams[URLTypes.kind] == WavesKeeper.Action.send.rawValue {
            
            print(url.request)
        }
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

private extension String {
    
    func queryParam(key: String, value: String) -> String {
        if last == "&" || last == "?" {
            return key + "=" + value
        }
        else if (self as NSString).range(of: "?").location == NSNotFound {
            return "?" + key + "=" + value
        }
        return "&" + key + "=" + value
    }
}


public extension WavesKeeper.Request {
    
   
    var urlQueryString: String {
        
        var string: String = Constants.keeperSchemeKey
        string += string.queryParam(key: URLTypes.callback, value: dApp.schemeUrl)
        string += string.queryParam(key: URLTypes.appName, value: dApp.name)
        string += string.queryParam(key: URLTypes.iconUrl, value: dApp.iconUrl)

        string += string.queryParam(key: URLTypes.kind, value: action.rawValue)

        switch transaction {
        case .transfer(let model):
            string += string.queryParam(key: URLTypes.txType, value: URLTypes.TxType.transfer)
            
            string += string.queryParam(key: URLTypes.type, value: String(model.type))
            string += string.queryParam(key: URLTypes.verison, value: String(model.version))
            string += string.queryParam(key: URLTypes.chainId, value: model.chainId)
            string += string.queryParam(key: URLTypes.fee, value: String(model.fee))
            string += string.queryParam(key: URLTypes.recipient, value: model.recipient)
            string += string.queryParam(key: URLTypes.assetId, value: model.assetId)
            string += string.queryParam(key: URLTypes.amount, value: String(model.amount))
            string += string.queryParam(key: URLTypes.attachment, value: model.attachment)
            string += string.queryParam(key: URLTypes.feeAssetId, value: model.feeAssetId)
            
        case .invokeScript(let model):
            string += string.queryParam(key: URLTypes.txType, value: URLTypes.TxType.invokeSctipt)
            
            string += string.queryParam(key: URLTypes.chainId, value: model.chainId)
            string += string.queryParam(key: URLTypes.fee, value: String(model.fee))
            string += string.queryParam(key: URLTypes.feeAssetId, value: model.feeAssetId)
            string += string.queryParam(key: URLTypes.dApp, value: model.dApp)

            var callArguments: [NodeService.Query.Transaction.InvokeScript.Arg] = []
            
            var payments: [NodeService.Query.Transaction.InvokeScript.Payment] = []
//            var call: NodeService.Query.Transaction.InvokeScript.Call = .init(function: "<#T##String#>", args: [NodeService.Query.Transaction.InvokeScript.Arg])
            
//            NodeService.Query.Transaction.invokeScript(.init(chainId: "",
//                                                             fee: 0,
//                                                             feeAssetId: "",
//                                                             dApp: "",
//                                                             call: call,
//                                                             payment: payments))
            
//            public private(set) var type: Int
//            public private(set) var version: Int
//            public private(set) var chainId: String
//            public private(set) var fee: Int64
//            public private(set) var timestamp: Int64
//            public private(set) var senderPublicKey: String
//            public internal(set) var proofs: [String]
//
//            public let dApp: String
//            public let call: Call?
//            public let payment: [Payment]
//            public let feeAssetId: String
            
        
        case .data(let model):
            print("")
        default:
            break
        }
        
        if let url = URL(string: string) {
            if let req = url.request {
               print(req)
            }
        }
        return string
    }
}

public extension URL {
    
    var request: WavesKeeper.Request? {
        
        let params = queryParams
        
        let appName = params[URLTypes.appName] ?? ""
        let iconUrl = params[URLTypes.iconUrl] ?? ""
        let schemeUrl = params[URLTypes.callback] ?? ""
        let action: WavesKeeper.Action = params[URLTypes.kind] == WavesKeeper.Action.send.rawValue ? .send : .sign

        let dApp = WavesKeeper.Application(name: appName,
                                           iconUrl: iconUrl,
                                           schemeUrl: schemeUrl)

        let txType = params[URLTypes.txType]
        if txType == URLTypes.TxType.transfer {
            
            var amount: Int64 = 0
            var fee: Int64 = 0
            
            if let amountString = params[URLTypes.amount] {
                amount = Int64(amountString) ?? 0
            }
            
            if let feeString = params[URLTypes.amount] {
                fee = Int64(feeString) ?? 0
            }
            
            let tx: NodeService.Query.Transaction = .transfer(.init(recipient: params[URLTypes.recipient] ?? "",
                                                                    assetId: params[URLTypes.assetId] ?? "",
                                                                    amount: amount,
                                                                    fee: fee,
                                                                    attachment: params[URLTypes.attachment] ?? "",
                                                                    feeAssetId: params[URLTypes.feeAssetId] ?? "",
                                                                    chainId: params[URLTypes.chainId] ?? ""))
            
            return WavesKeeper.Request(dApp: dApp, action: action, transaction: tx)

        }
        else if txType == URLTypes.TxType.transfer {
            
        }
        else if txType == URLTypes.TxType.transfer {
            
        }

        return nil
    }
    
    var queryParams: [String: String] {
        
        var params: [String: String] = [:]
        let string = absoluteString
        
        let range = (string as NSString).range(of: Constants.keeperSchemeKey + "?")
        if range.location != NSNotFound {
            let paramsString = (string as NSString).substring(from: range.location + range.length)
            let arrayComponents = paramsString.components(separatedBy: "&")
            
            for stringParam in arrayComponents {
                let components = stringParam.components(separatedBy: "=")
                let key = components.first ?? ""
                let value = components.last ?? ""
                params[key] = value
            }
        }
        
        return params
    }
}
