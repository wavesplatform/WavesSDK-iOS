//
//  NetworkError.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 23/11/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya

private enum Constants {
    static let scriptErrorCode: Int = 307
    static let assetScriptErrorCode: Int = 308
    static let notFound: Int = 404
    static let negativeBalance: Int = 112
}

@frozen public enum NetworkError: Error, Equatable {
    
    case none    
    case message(String)
    case notFound
    case internetNotWorking
    case serverError
    case negativeBalance
    case scriptError
    case assetScriptErrorCode
    
    public var isInternetNotWorking: Bool {
        switch self {
        case .internetNotWorking:
            return true
            
        default:
            return false
        }
    }
    
    public var errorType: String {
        switch self {
        case .negativeBalance:
            return "negativeBalance"
        case .scriptError:
            return "scriptError"
        case .assetScriptErrorCode:
            return "assetScriptErrorCode"
        case .notFound:
            return "notFound"
        default:
            return "undefinedError"
        }
    }

    public var isServerError: Bool {
        switch self {
        case .serverError:
            return true
            
        default:
            return false
        }
    }
}

extension MoyaError {
    
    var error: Error? {
        switch self {
        case .underlying(let error, _):
            return error
            
        case .objectMapping(let error, _):
            return error
            
        case .encodableMapping(let error):
            return error
            
        case .parameterEncoding(let error):
            return error
            
        default:
            return nil
        }
    }
}

public extension NetworkError {
    
    static func error(by error: Error) -> NetworkError {
        
        switch error {
        case let error as NetworkError:
            return error
            
        case let moyaError as MoyaError:
            guard let response = moyaError.response else {
                
                if let error = moyaError.error {
                    return NetworkError.error(by: error)
                } else {
                    return NetworkError.notFound
                }
            }
            
            return NetworkError.error(response: response)
            
        case let urlError as NSError where urlError.domain == NSURLErrorDomain:
            
            switch urlError.code {
            case NSURLErrorBadURL:
                return NetworkError.serverError
                
            case NSURLErrorTimedOut:
                return NetworkError.internetNotWorking
                
            case NSURLErrorUnsupportedURL:
                return NetworkError.serverError
                
            case NSURLErrorCannotFindHost:
                return NetworkError.serverError
                
            case NSURLErrorCannotConnectToHost:
                return NetworkError.serverError
                
            case NSURLErrorNetworkConnectionLost:
                return NetworkError.serverError
                
            case NSURLErrorDNSLookupFailed:
                return NetworkError.serverError
                
            case NSURLErrorHTTPTooManyRedirects:
                return NetworkError.serverError
                
            case NSURLErrorResourceUnavailable:
                return NetworkError.serverError
                
            case NSURLErrorNotConnectedToInternet:
                return NetworkError.internetNotWorking
                
            case NSURLErrorBadServerResponse:
                return NetworkError.serverError
                
            default:
                return NetworkError.none
            }
            
        default:
            return NetworkError.none
        }
    }
    
    static func error(response: Moya.Response) -> NetworkError {
        
        if response.statusCode == Constants.notFound {
            return NetworkError.notFound
        }
        
        if let error = error(data: response.data) {
            return error
        }
        
        return NetworkError.none
    }
    
    
    static func error(data: Data) -> NetworkError? {
        
        let anyObject = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let anyObject = anyObject as? [String: Any] {
            
            if let errorCode = anyObject["error"] as? Int {
                switch errorCode {
                case Constants.scriptErrorCode:
                    return NetworkError.scriptError
                case Constants.negativeBalance:
                    return NetworkError.negativeBalance
                case Constants.assetScriptErrorCode:
                    return NetworkError.assetScriptErrorCode
                case Constants.notFound:
                    return NetworkError.notFound
                default:
                    break
                }
            }
            
            if let m = anyObject["message"] as? String {
                return NetworkError.message(m)
            }
        }
        
        return nil
    }
    
}
