//
//  NetworkError.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 23/11/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Alamofire
import Foundation
import Moya

private enum Constants {
    static let scriptErrorCode: Int = 307
    static let assetScriptErrorCode: Int = 308
    static let notFound: Int = 404
    static let imTeaPot: Int = 418
}

@frozen public enum NetworkError: Error, Equatable {
    case none
    case message(String)
    case notFound
    case internetNotWorking
    case serverError
    case scriptError
    case canceled

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
        case let .underlying(error, _):
            return error

        case let .objectMapping(error, _):
            return error

        case let .encodableMapping(error):
            return error

        case let .parameterEncoding(error):
            return error

        default:
            return nil
        }
    }
}

private extension NetworkError {
    static func message(code: Int, message: String? = nil) -> NetworkError {
        if let message = message {
            return NetworkError.message("Oh… It's all broken! \(code) \(message)")
        } else {
            return NetworkError.message("Oh… It's all broken! \(code)")
        }
    }
}

public extension NetworkError {
    static func error(by error: Error) -> Error {
        switch error {
        case let error as NetworkError:
            return error

        case let moyaError as MoyaError:
            guard let response = moyaError.response else {
                if let error = moyaError.error {
                    return NetworkError.error(by: error)
                } else {
                    return error
                }
            }

            if let networkError = NetworkError.error(response: response) {
                return networkError
            }

            return moyaError

        case let afError as AFError:
            switch afError {
            case let .createUploadableFailed(error: error):
                return NetworkError.error(by: error)
            case let .createURLRequestFailed(error: error):
                return NetworkError.error(by: error)
            case let .downloadedFileMoveFailed(error: error, _, _):
                return NetworkError.error(by: error)
            case .explicitlyCancelled:
                return NetworkError.canceled
            case .sessionDeinitialized:
                return NetworkError.internetNotWorking
            case let .sessionInvalidated(error: error):
                if let error = error {
                    return NetworkError.error(by: error)
                } else {
                    return NetworkError.internetNotWorking
                }
            case let .sessionTaskFailed(error: error):
                return NetworkError.error(by: error)
            default:
                return error
            }

        case let urlError as NSError where urlError.domain == NSURLErrorDomain:

            switch urlError.code {
            case NSURLErrorTimedOut:
                return NetworkError.internetNotWorking

            case NSURLErrorCannotConnectToHost:
                return NetworkError.internetNotWorking

            case NSURLErrorNetworkConnectionLost:
                return NetworkError.internetNotWorking

            case NSURLErrorNotConnectedToInternet:
                return NetworkError.internetNotWorking

            case NSURLErrorCancelled:
                return NetworkError.canceled
                
            default:
                return NetworkError.internetNotWorking 
            }

        default:
            return error
        }
    }

    static func error(response: Moya.Response) -> NetworkError? {
        if response.statusCode == Constants.notFound {
            return NetworkError.notFound
        }

        if response.statusCode == Constants.imTeaPot {
            return NetworkError.internetNotWorking
        }

        if let error = error(data: response.data) {
            return error
        }

        return nil
    }

    static func error(data: Data) -> NetworkError? {
        var message: String?
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
