//
//  TransactionNodeQuery.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation

public extension Node.Query {
    enum Broadcast {
        case createAlias(Alias)
        case startLease(Lease)
        case cancelLease(LeaseCancel)
        case burn(Burn)
        case data(Data)
        case send(Send)
    }
}

public extension Node.Query.Broadcast {
    
    struct Burn {
        public let version: Int
        public let type: Int
        public let scheme: String
        public let fee: Int64
        public let assetId: String
        public let quantity: Int64
        public let timestamp: Int64
        public let senderPublicKey: String
        public let proofs: [String]

        public init(version: Int, type: Int, scheme: String, fee: Int64, assetId: String, quantity: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String]) {
            self.version = version
            self.type = type
            self.scheme = scheme
            self.fee = fee
            self.assetId = assetId
            self.quantity = quantity
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }
    
    struct Alias {
        public let version: Int
        public let name: String
        public let fee: Int64
        public let timestamp: Int64
        public let type: Int
        public let senderPublicKey: String
        public let proofs: [String]?

        public init(version: Int, name: String, fee: Int64, timestamp: Int64, type: Int, senderPublicKey: String, proofs: [String]?) {
            self.version = version
            self.name = name
            self.fee = fee
            self.timestamp = timestamp
            self.type = type
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }
    
    struct Lease {
        public let version: Int
        public let scheme: String
        public let fee: Int64
        public let recipient: String
        public let amount: Int64
        public let timestamp: Int64
        public let type: Int
        public let senderPublicKey: String
        public let proofs: [String]

        public init(version: Int, scheme: String, fee: Int64, recipient: String, amount: Int64, timestamp: Int64, type: Int, senderPublicKey: String, proofs: [String]) {
            self.version = version
            self.scheme = scheme
            self.fee = fee
            self.recipient = recipient
            self.amount = amount
            self.timestamp = timestamp
            self.type = type
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }
    
    struct LeaseCancel {
        public let version: Int
        public let scheme: String
        public let fee: Int64
        public let leaseId: String
        public let timestamp: Int64
        public let type: Int
        public let senderPublicKey: String
        public let proofs: [String]

        public init(version: Int, scheme: String, fee: Int64, leaseId: String, timestamp: Int64, type: Int, senderPublicKey: String, proofs: [String]) {
            self.version = version
            self.scheme = scheme
            self.fee = fee
            self.leaseId = leaseId
            self.timestamp = timestamp
            self.type = type
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }
    
    struct Data {
        public struct Value {
            public enum Kind {
                case integer(Int64)
                case boolean(Bool)
                case string(String)
                case binary(String)
            }
            
            public let key: String
            public let value: Kind

            public init(key: String, value: Kind) {
                self.key = key
                self.value = value
            }
        }
        
        public let type: Int
        public let version: Int
        public let fee: Int64
        public let timestamp: Int64
        public let senderPublicKey: String
        public let proofs: [String]
        public let data: [Value]

        public init(type: Int, version: Int, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String], data: [Value]) {
            self.type = type
            self.version = version
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.data = data
        }
    }
    
    struct Send {
        public let type: Int
        public let version: Int
        public let recipient: String
        public let assetId: String
        public let amount: Int64
        public let fee: Int64
        public let attachment: String
        public let feeAssetId: String
        public let feeAsset: String
        public let timestamp: Int64
        public let senderPublicKey: String
        public let proofs: [String]

        public init(type: Int, version: Int, recipient: String, assetId: String, amount: Int64, fee: Int64, attachment: String, feeAssetId: String, feeAsset: String, timestamp: Int64, senderPublicKey: String, proofs: [String]) {
            self.type = type
            self.version = version
            self.recipient = recipient
            self.assetId = assetId
            self.amount = amount
            self.fee = fee
            self.attachment = attachment
            self.feeAssetId = feeAssetId
            self.feeAsset = feeAsset
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }    
}
