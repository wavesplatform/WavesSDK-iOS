//
//  CreateOrderMatcherQuery.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import WavesSDKExtension

public extension MatcherService.Query {
    
    fileprivate enum Constants {
        static let senderPublicKey: String = "senderPublicKey"
        static let matcherPublicKey: String = "matcherPublicKey"
        static let assetPair: String = "assetPair"
        static let orderType: String = "orderType"
        static let price: String = "price"
        static let amount: String = "amount"
        static let expiration: String = "expiration"
        static let matcherFee: String = "matcherFee"
        static let version: String = "version"
        static let proofs: String = "proofs"
        static let signature: String = "signature"
        static let timestamp: String = "timestamp"
        static let versionCreateOrder: Int = 2
        static let amountAsset: String = "amountAsset"
        static let priceAsset: String = "priceAsset"
        static let sender: String = "sender"
        static let orderId: String = "orderId"        
    }
    
    struct CreateOrder {
        
        public enum OrderType: String {
            case sell
            case buy
        }
        
        public struct AssetPair {
            public let amountAssetId: String
            public let priceAssetId: String
            
            internal var paramenters: [String : String] {
                return [Constants.amountAsset : amountAssetId,
                        Constants.priceAsset : priceAssetId]
            }
            
            public init(amountAssetId: String,
                        priceAssetId: String) {
                self.amountAssetId = amountAssetId
                self.priceAssetId = priceAssetId
            }
        }
    
        public let matcherPublicKey: String
        public let senderPublicKey: String
        public let assetPair: AssetPair
        public let amount: Int64
        public let price: Int64
        public let orderType: OrderType
        public let matcherFee: Int64
        public let timestamp: Int64
        public let expirationTimestamp: Int64
        public let proofs: [String]

        public init(matcherPublicKey: String, senderPublicKey: String, assetPair: AssetPair, amount: Int64, price: Int64, orderType: OrderType, matcherFee: Int64, timestamp: Int64, expirationTimestamp: Int64, proofs: [String]) {
            self.matcherPublicKey = matcherPublicKey
            self.senderPublicKey = senderPublicKey
            self.assetPair = assetPair
            self.amount = amount
            self.price = price
            self.orderType = orderType
            self.matcherFee = matcherFee
            self.timestamp = timestamp
            self.expirationTimestamp = expirationTimestamp
            self.proofs = proofs
        }
        
        internal var parameters: [String : Any] {
    
            return [Constants.senderPublicKey :  senderPublicKey,
                    Constants.matcherPublicKey : matcherPublicKey,
                    Constants.assetPair : assetPair.paramenters,
                    Constants.orderType : orderType.rawValue,
                    Constants.price : price,
                    Constants.amount : amount,
                    Constants.timestamp : timestamp,
                    Constants.expiration : expirationTimestamp,
                    Constants.matcherFee : matcherFee,
                    Constants.proofs : proofs,
                    Constants.version: Constants.versionCreateOrder]
        }
    }
    
    struct CancelOrder {
        public let orderId: String
        public let amountAsset: String
        public let priceAsset: String
        public let signature: String
        public let senderPublicKey: String

        public init(orderId: String, amountAsset: String, priceAsset: String, signature: String, senderPublicKey: String) {
            self.orderId = orderId
            self.amountAsset = amountAsset
            self.priceAsset = priceAsset
            self.signature = signature
            self.senderPublicKey = senderPublicKey
        }
        
        internal var parameters: [String : String] {
            return [Constants.sender : senderPublicKey,
                    Constants.orderId : orderId,
                    Constants.signature : signature]
        }
    }
    
    struct GetMyOrders {
        public let amountAsset: String
        public let priceAsset: String
        public let publicKey: String
        public let signature: String
        public let timestamp: Int64

        public init(amountAsset: String, priceAsset: String, publicKey: String, signature: String, timestamp: Int64) {
            self.amountAsset = amountAsset
            self.priceAsset = priceAsset
            self.publicKey = publicKey
            self.signature = signature
            self.timestamp = timestamp
        }
        
        public var parameters: [String: String] {
            return [Constants.senderPublicKey : publicKey,
                    Constants.timestamp: "\(timestamp)",
                    Constants.signature: signature]
        }
    }
}
