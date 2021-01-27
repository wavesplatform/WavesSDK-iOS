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
                return NetworkError.none
            case let .parameterEncodingFailed(reason: reason):
                return NetworkError.none
            case let .parameterEncoderFailed(reason: reason):
                return NetworkError.none
            case let .requestAdaptationFailed(error: error):
                return NetworkError.error(by: error)
            case let .requestRetryFailed(retryError: retryError, originalError: originalError):
                return NetworkError.error(by: retryError)
            case let .responseValidationFailed(reason: reason):
                return NetworkError.none
            case let .responseSerializationFailed(reason: reason):
                return NetworkError.none
            case let .serverTrustEvaluationFailed(reason: reason):
                return NetworkError.none
            case .sessionDeinitialized:
                return NetworkError.none
            case let .sessionInvalidated(error: error):
                if let error = error {
                    return NetworkError.error(by: error)
                } else {
                    return NetworkError.none
                }
            case let .sessionTaskFailed(error: error):
                return NetworkError.error(by: error)
            case let .urlRequestValidationFailed(reason: reason):
                return NetworkError.none
            @unknown default:
                return .none
            }

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
