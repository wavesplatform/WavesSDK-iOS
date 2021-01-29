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

        case let afError as AFError:
            switch afError {
            case let .createUploadableFailed(error: error):
                return NetworkError.error(by: error)
            case let .createURLRequestFailed(error: error):
                return NetworkError.error(by: error)
            case let .downloadedFileMoveFailed(error: error, source: source, destination: destination):
                return NetworkError.error(by: error)
            case .explicitlyCancelled:
                return NetworkError.canceled
            case let .invalidURL(url: url):
                return NetworkError.notFound
            case let .multipartEncodingFailed(reason: reason):
                return NetworkError.serverError
            case let .parameterEncodingFailed(reason: reason):
                return NetworkError.serverError
            case let .parameterEncoderFailed(reason: reason):
                return NetworkError.serverError
            case let .requestAdaptationFailed(error: error):
                return NetworkError.error(by: error)
            case let .requestRetryFailed(retryError: retryError, originalError: originalError):
                return NetworkError.error(by: retryError)
            case let .responseValidationFailed(reason: reason):
                return NetworkError.serverError
            case let .responseSerializationFailed(reason: reason):
                return NetworkError.serverError
            case let .serverTrustEvaluationFailed(reason: reason):
                return NetworkError.serverError
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
                return NetworkError.none
            @unknown default:
                return NetworkError.none
            }

        case let urlError as NSError where urlError.domain == NSURLErrorDomain:

            switch urlError.code {
            case NSURLErrorBadURL:
                return NetworkError.none

            case NSURLErrorTimedOut:
                return NetworkError.internetNotWorking

            case NSURLErrorUnsupportedURL:
                return NetworkError.none

            case NSURLErrorCannotFindHost:
                return NetworkError.none

            case NSURLErrorCannotConnectToHost:
                return NetworkError.internetNotWorking

            case NSURLErrorNetworkConnectionLost:
                return NetworkError.internetNotWorking

            case NSURLErrorDNSLookupFailed:
                return NetworkError.none

            case NSURLErrorHTTPTooManyRedirects:
                return NetworkError.none

            case NSURLErrorResourceUnavailable:
                return NetworkError.none

            case NSURLErrorNotConnectedToInternet:
                return NetworkError.internetNotWorking

            case NSURLErrorBadServerResponse:
                return NetworkError.none

            case NSURLErrorCancelled:
                return NetworkError.canceled
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

        if response.statusCode == Constants.imTeaPot {
            return NetworkError.internetNotWorking
        }

        if let error = error(data: response.data) {
            return error
        }

        return NetworkError.none
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
