//
//  BalanceMatcherService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 23.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya


public extension MatcherService.Query {
    
    fileprivate enum Constants {
        static let senderPublicKey = "senderPublicKey"
        static let signature = "signature"
        static let timestamp = "timestamp"
    }

    
    struct ReservedBalances {
        public var senderPublicKey: String
        public var signature: String
        public var timestamp: Int64

        public init(senderPublicKey: String, signature: String, timestamp: Int64) {
            self.senderPublicKey = senderPublicKey
            self.signature = signature
            self.timestamp = timestamp
        }
        
        internal var parameters: [String: String] {
            return [Constants.senderPublicKey : senderPublicKey,
                    Constants.timestamp: "\(timestamp)",
                    Constants.signature: signature]
        }
    }
}

extension MatcherService.Target {
    struct Balance {
        enum Kind {
            /**
             Response:
             - [AssetId: Balance] as [String: Int64]
             */
            case getReservedBalances(MatcherService.Query.ReservedBalances)
        }

        var kind: Kind
        var matcherUrl: URL
    }
}

extension MatcherService.Target.Balance: MatcherTargetType {
    
    fileprivate enum Constants {
        static let matcher = "matcher"
        static let balance = "balance"
        static let reserved = "reserved"
        static let timestamp = "timestamp"
    }

    var path: String {
        switch kind {
        case .getReservedBalances(let query):
            return Constants.matcher
                + "/"
                + Constants.balance
                + "/"
                + Constants.reserved
                + "/"
                + query.senderPublicKey.urlEscaped
        }
    }

    var method: Moya.Method {
        switch kind {
        case .getReservedBalances:
            return .get
        }
    }

    var task: Task {
        switch kind {
        case .getReservedBalances:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var headers = ContentType.applicationJson.headers

        switch kind {
        case .getReservedBalances(let query):
            headers.merge(query.parameters) { a, _ in a }
        }

        return headers
    }
}
