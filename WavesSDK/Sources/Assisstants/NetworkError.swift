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
    static let assetScriptErrorCode: Int = 308 //TODO: remove?
    static let notFound: Int = 404
}

public enum NetworkError: Error, Equatable {
    
    case none    
    case message(String)
    case notFound
    case internetNotWorking
    case serverError
    case scriptError
    
    public var isInternetNotWorking: Bool {
        switch self {
        case .internetNotWorking:
            return true
            
        default:
            return false
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
                    return .error(by: error)
                } else {
                    return .notFound
                }
            }
            
            return .error(response: response)
            
        case let urlError as NSError where urlError.domain == NSURLErrorDomain:
            
            switch urlError.code {
            case NSURLErrorBadURL: return .serverError
            case NSURLErrorTimedOut: return .internetNotWorking
            case NSURLErrorUnsupportedURL: return .serverError
            case NSURLErrorCannotFindHost: return .serverError
            case NSURLErrorCannotConnectToHost: return .serverError
            case NSURLErrorNetworkConnectionLost: return .serverError
            case NSURLErrorDNSLookupFailed: return .serverError
            case NSURLErrorHTTPTooManyRedirects: return .serverError
            case NSURLErrorResourceUnavailable: return .serverError
            case NSURLErrorNotConnectedToInternet: return .internetNotWorking
            case NSURLErrorBadServerResponse: return .serverError
            case NSURLErrorCancelled: return .none
            default: return .none
            }
            
        default: return .none
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
        
        var message: String? = nil
        let anyObject = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let anyObject = anyObject as? [String: Any] {
            
            if anyObject["error"] as? Int == Constants.scriptErrorCode {
                return NetworkError.scriptError
            }
            
            message = anyObject["message"] as? String
            
            if message == nil {
                message = anyObject["error"] as? String
            }
        }
        
        if let message = message {
            return NetworkError.message(message)
        }
        
        return nil
    }
    
}
