//
//  TransactionNodeQuery.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation

public enum TransferVersion: Int {
    case version_1 = 1
    case version_2 = 2
}

public extension NodeService.Query {
    enum Broadcast {
        case createAlias(Alias)
        case startLease(Lease)
        case cancelLease(LeaseCancel)
        case burn(Burn)
        case data(Data)
        case transfer(Transfer)
        case invokeScript(InvokeScript)
        
        var type: Int {
            switch self {
            case .createAlias:
                return TransactionType.createAlias.int
                
            case .startLease:
                return TransactionType.createLease.int
                
            case .cancelLease:
                return TransactionType.cancelLease.int
                
            case .burn:
                return TransactionType.burn.int
                
            case .data:
                return TransactionType.data.int
                
            case .transfer:
                return TransactionType.transfer.int
                
            case .invokeScript:
                return TransactionType.invokeScript.int
            }
        }
    }
}

public extension NodeService.Query.Broadcast {
    
    struct InvokeScript {
        
        public struct Arg {
            public enum Value {
                case bool(Bool) //boolean
                case integer(Int) // integer
                case string(String) // string
                case binary(String) // binary
            }
            
            public let value: Value

            public init(value: Value) {
                self.value = value
            }
        }
        
        public struct Call {
            public let function: String
            public let args: [Arg]

            public init(function: String, args: [Arg]) {
                self.function = function
                self.args = args
            }
        }
        
        public struct Payment {
            public let amount: Int64
            public let assetId: String

            public init(amount: Int64, assetId: String) {
                self.amount = amount
                self.assetId = assetId
            }
        }
        
        public let version: Int
        public let type: Int
        public let scheme: String
        public let fee: Int64
        public let timestamp: Int64
        public let senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let feeAssetId: String
        public let dApp: String
        public let call: Call?
        public let payment: [Payment]

        public init(version: Int, type: Int, scheme: String, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String], feeAssetId: String, dApp: String, call: Call?, payment: [Payment]) {
            self.version = version
            self.type = type
            self.scheme = scheme
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.feeAssetId = feeAssetId
            self.dApp = dApp
            self.call = call
            self.payment = payment
        }
        
    }
    
    struct Burn {
        public let version: Int
        public let type: Int
        public let scheme: String
        public let fee: Int64
        public let assetId: String
        public let quantity: Int64
        public let timestamp: Int64
        public let senderPublicKey: String
        public internal(set) var proofs: [String]

        public init(version: Int = TransferVersion.version_2.rawValue, scheme: String, fee: Int64, assetId: String, quantity: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String]) {
            self.version = version
            self.type = TransactionType.burn.int
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
        public internal(set) var proofs: [String]?

        public init(version: Int = TransferVersion.version_2.rawValue, name: String, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String]?) {
            self.version = version
            self.name = name
            self.fee = fee
            self.timestamp = timestamp
            self.type = TransactionType.createAlias.int
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
        public internal(set) var proofs: [String]

        public init(version: Int = TransferVersion.version_2.rawValue, scheme: String, fee: Int64, recipient: String, amount: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String]) {
            self.version = version
            self.scheme = scheme
            self.fee = fee
            self.recipient = recipient
            self.amount = amount
            self.timestamp = timestamp
            self.type = TransactionType.createLease.int
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
        public internal(set) var proofs: [String]

        public init(version: Int = TransferVersion.version_2.rawValue, scheme: String, fee: Int64, leaseId: String, timestamp: Int64, senderPublicKey: String, proofs: [String]) {
            self.version = version
            self.scheme = scheme
            self.fee = fee
            self.leaseId = leaseId
            self.timestamp = timestamp
            self.type = TransactionType.cancelLease.int
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
        public internal(set) var proofs: [String]
        public let data: [Value]

        public init(version: Int = TransferVersion.version_1.rawValue, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = [], data: [Value]) {
            self.type = TransactionType.data.int
            self.version = version
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.data = data
        }
    }
    
    struct Transfer {
        public let type: Int
        public let version: Int
        public let recipient: String
        public let assetId: String
        public let amount: Int64
        public let fee: Int64
        public let attachment: String
        public let feeAssetId: String
        public let timestamp: Int64
        public let senderPublicKey: String
        public var proofs: [String]

        public init(version: Int = TransferVersion.version_2.rawValue, recipient: String, assetId: String, amount: Int64, fee: Int64, attachment: String, feeAssetId: String, timestamp: Int64, senderPublicKey: String, proofs: [String] = []) {
            self.type = TransactionType.transfer.int
            self.version = version
            self.recipient = recipient
            self.assetId = assetId
            self.amount = amount
            self.fee = fee
            self.attachment = attachment
            self.feeAssetId = feeAssetId
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }    
}
