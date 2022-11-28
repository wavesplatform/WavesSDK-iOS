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
    static func error(by error: Error) -> NetworkError {        
        switch error {
        case let error as NetworkError:
            return error

        case let moyaError as MoyaError:
            guard let response = moyaError.response else {
                if let error = moyaError.error {
                    return NetworkError.error(by: error)
                } else {
                    return NetworkError.message(code: 9000)
                }
            }

            return NetworkError.error(response: response)

        case let afError as AFError:
            switch afError {
            case let .createUploadableFailed(error: error):
                return NetworkError.error(by: error)
            case let .createURLRequestFailed(error: error):
                return NetworkError.error(by: error)
            case let .downloadedFileMoveFailed(error: error, source: source, destination: destination):
                (_, _) = (source, destination)
                return NetworkError.error(by: error)
            case .explicitlyCancelled:
                return NetworkError.canceled
            case let .invalidURL(url: url):
                _ = url
                return NetworkError.message(code: 9001)
            case let .multipartEncodingFailed(reason: reason):
                _ = reason
                return NetworkError.message(code: 9002)
            case let .parameterEncodingFailed(reason: reason):
                _ = reason
                return NetworkError.message(code: 9003)
            case let .parameterEncoderFailed(reason: reason):
                _ = reason
                return NetworkError.message(code: 9004)
            case let .requestAdaptationFailed(error: error):
                _ = error
                return NetworkError.message(code: 9005)
            case let .requestRetryFailed(retryError: retryError, originalError: originalError):
                _ = retryError
                _ = originalError
                return NetworkError.message(code: 9006)
            case let .responseValidationFailed(reason: reason):
                _ = reason
                return NetworkError.message(code: 9007)
            case let .responseSerializationFailed(reason: reason):
                _ = reason
                return NetworkError.message(code: 9008)
            case let .serverTrustEvaluationFailed(reason: reason):
                _ = reason
                return NetworkError.message(code: 9009)
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
            case let .urlRequestValidationFailed(reason: reason):
                _ = reason
                return NetworkError.message(code: 9010)
            }

        case let urlError as NSError where urlError.domain == NSURLErrorDomain:

            switch urlError.code {
            case NSURLErrorBadURL:
                return NetworkError.message(code: 9012)

            case NSURLErrorTimedOut:
                return NetworkError.internetNotWorking

            case NSURLErrorUnsupportedURL:
                return NetworkError.message(code: 9013)

            case NSURLErrorCannotFindHost:
                return NetworkError.message(code: 9014)

            case NSURLErrorCannotConnectToHost:
                return NetworkError.internetNotWorking

            case NSURLErrorNetworkConnectionLost:
                return NetworkError.internetNotWorking

            case NSURLErrorDNSLookupFailed:
                return NetworkError.message(code: 9015)

            case NSURLErrorHTTPTooManyRedirects:
                return NetworkError.message(code: 9016)

            case NSURLErrorResourceUnavailable:
                return NetworkError.message(code: 9017)

            case NSURLErrorNotConnectedToInternet:
                return NetworkError.internetNotWorking

            case NSURLErrorBadServerResponse:
                return NetworkError.message(code: 9018)

            case NSURLErrorCancelled:
                return NetworkError.canceled
                
            default:
                return NetworkError.internetNotWorking 
            }

        default:
            return NetworkError.message(code: 9020)
        }
    }

    static func error(response: Moya.Response) -> NetworkError {
        if response.statusCode == Constants.notFound {
            return NetworkError.notFound
        }

        if response.statusCode == Constants.imTeaPot {
            return NetworkError.internetNotWorking
        }

        if let error = error(data: response.data) {
            return error
        }

        return NetworkError.message(code: 9021, message: "MoyaResponse \(response.statusCode)")
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
