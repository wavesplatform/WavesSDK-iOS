//
//  CreateOrderMatcherQuery.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation


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
        static let amountAsset: String = "amountAsset"
        static let priceAsset: String = "priceAsset"
        static let sender: String = "sender"
        static let orderId: String = "orderId"
        static let matcherFeeAssetId: String = "matcherFeeAssetId"
    }

    /**
      Create Order Request to DEX-matcher, decentralized exchange of Waves.
      It collects orders from users who created CreateOrderRequest,
      matches and sends it to blockchain it by Exchange transactions.
     */
    struct CreateOrder {
        
        public enum OrderType: String {
            case sell
            case buy
        }
        
        private enum Version: Int {
            case V2 = 2
            case V3 = 3
        }
        
        public struct AssetPair {
            public let amountAssetId: String
            public let priceAssetId: String
            
            internal var paramenters: [String : String] {
                return [Constants.amountAsset : amountAssetId.normalizeWavesAssetId,
                        Constants.priceAsset : priceAssetId.normalizeWavesAssetId]
            }
            
            public init(amountAssetId: String,
                        priceAssetId: String) {
                self.amountAssetId = amountAssetId
                self.priceAssetId = priceAssetId
            }
        }

        /**
          Matcher Public Key, available in MatcherService.matcherPublicKey() for DEX
         */
        public let matcherPublicKey: String

        /**
          Account public key of the sender in Base58
         */
        public let senderPublicKey: String

        /**
          Exchangeable pair. We sell or buy always amount asset and we always give price asset
         */
        public let assetPair: AssetPair

        /**
          Amount of asset in satoshi
         */
        public let amount: Int64

        /**
          Price for amount
         */
        public let price: Int64

        /**
          Order type "buy" or "sell"
         */
        public let orderType: OrderType

        /**
          Amount matcher fee of Waves in satoshi
         */
        public let matcherFee: Int64

        /**
          Unix time of sending of transaction to blockchain, must be in current time +/- half of hour
         */
        public let timestamp: Int64

        /**
          Unix time of expiration of transaction to blockchain
         */
        public let expirationTimestamp: Int64

        /**
          If the array is empty, then S= 3. If the array is not empty,
          then S = 3 + 2 × N + (P1 + P2 + ... + Pn), where N is the number of proofs in the array,
          Pn is the size on N-th proof in bytes.
          The maximum number of proofs in the array is 8. The maximum size of each proof is 64 bytes
          */
        public let proofs: [String]

        public let matcherFeeAsset: String
        
        private let version: Version
        
        public init(matcherPublicKey: String, senderPublicKey: String, assetPair: AssetPair, amount: Int64, price: Int64, orderType: OrderType, matcherFee: Int64, timestamp: Int64, expirationTimestamp: Int64, proofs: [String], matcherFeeAsset: String) {
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
            self.matcherFeeAsset = matcherFeeAsset
            self.version = .V3
        }
        
        internal var parameters: [String : Any] {
            
            
            var params: [String: Any] = [Constants.senderPublicKey :  senderPublicKey,
                                         Constants.matcherPublicKey : matcherPublicKey,
                                         Constants.assetPair : assetPair.paramenters,
                                         Constants.orderType : orderType.rawValue,
                                         Constants.price : price,
                                         Constants.amount : amount,
                                         Constants.timestamp : timestamp,
                                         Constants.expiration : expirationTimestamp,
                                         Constants.matcherFee : matcherFee,
                                         Constants.proofs : proofs,
                                         Constants.version: version.rawValue]
            
            if version == .V3 {
                params[Constants.matcherFeeAssetId] = matcherFeeAsset.normalizeToNullWavesAssetId
            }
            
            return params
        }
    }

    /**
      Cancel Order Request in DEX-matcher, decentralized exchange of Waves.

      It collects orders from users who created CreateOrderRequest,
      matches and sends it to blockchain it by Exchange transactions.
     */
    struct CancelOrder {
        /**
          Order Id of order to cancel
         */
        public let orderId: String

        /**
          Order signature by account private key
         */
        public let signature: String

        /**
          Account public key of the sender in Base58
         */
        public let senderPublicKey: String

        public let amountAsset: String
        public let priceAsset: String

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
  
    struct CancelAllOrders {
         
        /**
         Order signature by account private key
         */
        public let signature: String

        /**
         Account public key of the sender in Base58
         */
        public let senderPublicKey: String
        
        /**
          Unix time of sending of transaction to blockchain, must be in current time +/- half of hour
         */
        public let timestamp: Int64


        public init(signature: String, senderPublicKey: String, timestamp: Int64) {
              self.signature = signature
              self.timestamp = timestamp
              self.senderPublicKey = senderPublicKey
          }
          
          internal var parameters: [String : Any] {
              return [Constants.sender : senderPublicKey,
                      Constants.timestamp: timestamp,
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
    
    struct GetAllMyOrders {
        public let publicKey: String
        public let signature: String
        public let timestamp: Int64

        public init(publicKey: String, signature: String, timestamp: Int64) {
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
