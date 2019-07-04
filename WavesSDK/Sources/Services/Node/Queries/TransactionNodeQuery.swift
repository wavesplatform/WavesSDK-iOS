//
//  TransactionNodeQuery.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation

public enum TransactionVersion: Int {
    case version_1 = 1
    case version_2 = 2
}

public extension NodeService.Query {
    enum Transaction {
        case createAlias(Alias)
        case startLease(Lease)
        case cancelLease(LeaseCancel)
        case burn(Burn)
        case data(Data)
        case transfer(Transfer)
        case invokeScript(InvokeScript)
        case reissue(Reissue)
        case issue(Issue)
        case massTransfer(MassTransfer)
        case setScript(SetScript)
        case setAssetScript(SetAssetScript)
        case sponsorship(Sponsorship)
        
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
                
            case .reissue:
                return TransactionType.reissue.int
            
            case .issue:
                return TransactionType.issue.int
                
            case .massTransfer:
                return TransactionType.massTransfer.int
                
            case .setScript:
                return TransactionType.script.int
                
            case .setAssetScript:
                return TransactionType.assetScript.int
                
            case .sponsorship:
                return TransactionType.invokeScript.int
            }
        }
    }
}


public extension NodeService.Query.Transaction {
    
    struct Sponsorship: BaseTransactionQueryProtocol {
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let minSponsoredAssetFee: Int64?
        public let assetId: String
        
        public init(version: Int = TransactionVersion.version_1.rawValue, chainId: String, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = [], minSponsoredAssetFee: Int64?, assetId: String) {
            self.type = TransactionType.sponsorship.int
            self.assetId = assetId
            self.version = version
            self.chainId = chainId
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.minSponsoredAssetFee = minSponsoredAssetFee
        }
    }
    
    struct SetAssetScript: BaseTransactionQueryProtocol {
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let script: String?
        public let assetId: String
        
        public init(version: Int = TransactionVersion.version_1.rawValue, chainId: String, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = [], script: String?, assetId: String) {
            self.type = TransactionType.assetScript.int
            self.assetId = assetId
            self.version = version
            self.chainId = chainId
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.script = script
        }
    }
    
    struct SetScript: BaseTransactionQueryProtocol {
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let script: String?

        public init(version: Int = TransactionVersion.version_1.rawValue, chainId: String, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = [], script: String?) {
            self.type = TransactionType.script.int
            self.version = version
            self.chainId = chainId
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.script = script
        }
    }
    
    struct MassTransfer: BaseTransactionQueryProtocol {
        
        public struct Transfer {
            public let recipient: String
            public let amount: Int64

            public init(recipient: String, amount: Int64) {
                self.recipient = recipient
                self.amount = amount
            }
        }
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let assetId: String
        public let attachment: String
        public let transfers: [Transfer]

        public init(version: Int = TransactionVersion.version_1.rawValue, chainId: String, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = [], assetId: String, attachment: String, transfers: [Transfer]) {
            self.type = TransactionType.massTransfer.int
            self.version = version
            self.chainId = chainId
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.assetId = assetId
            self.attachment = attachment
            self.transfers = transfers
        }
    }
    
    struct Issue: BaseTransactionQueryProtocol {
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let name: String
        public let description: String
        public let script: String?
        public let quantity: Int64
        public let decimals: UInt8
        public let isReissuable: Bool

        public init(version: Int = TransactionVersion.version_2.rawValue,
                    chainId: String,
                    fee: Int64,
                    timestamp: Int64,
                    senderPublicKey: String,
                    proofs: [String] = [],
                    quantity: Int64,
                    isReissuable: Bool,
                    name: String,
                    description: String,
                    script: String?,
                    decimals: UInt8) {
            
            self.version = version
            self.type = TransactionType.issue.int
            self.chainId = chainId
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            
            self.name = name
            self.description = description
            self.script = script
            self.decimals = decimals            
            self.quantity = quantity
            self.isReissuable = isReissuable
        }
    }
    
    struct Reissue: BaseTransactionQueryProtocol {
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let assetId: String
        public let quantity: Int64
        public let isReissuable: Bool
        
        public init(version: Int = TransactionVersion.version_2.rawValue, chainId: String, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = [], assetId: String, quantity: Int64, isReissuable: Bool) {
            self.version = version
            self.type = TransactionType.reissue.int
            self.chainId = chainId
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.assetId = assetId
            self.quantity = quantity
            self.isReissuable = isReissuable
        }
    }
    
    struct InvokeScript: BaseTransactionQueryProtocol {
        
        public struct Arg {
            public enum Value {
                case bool(Bool)
                case integer(Int)
                case string(String)
                case binary(String)
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
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let dApp: String
        public let call: Call?
        public let payment: [Payment]
        public let feeAssetId: String

        public init(version: Int = TransactionVersion.version_1.rawValue, chainId: String, fee: Int64, timestamp: Int64,
                    senderPublicKey: String, feeAssetId: String, proofs: [String] = [], dApp: String, call: Call?, payment: [Payment]) {
            
            self.version = version
            self.feeAssetId = feeAssetId
            self.type = TransactionType.invokeScript.int
            self.chainId = chainId
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.dApp = dApp
            self.call = call
            self.payment = payment
        }
        
    }
    
    struct Burn: BaseTransactionQueryProtocol {
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let assetId: String
        public let quantity: Int64

        public init(version: Int = TransactionVersion.version_2.rawValue, chainId: String, fee: Int64, assetId: String, quantity: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = []) {
            self.version = version
            self.type = TransactionType.burn.int
            self.chainId = chainId
            self.fee = fee
            self.assetId = assetId
            self.quantity = quantity
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }
    
    struct Alias: BaseTransactionQueryProtocol {

        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let name: String
        
        public init(version: Int = TransactionVersion.version_2.rawValue, chainId: String, name: String, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = []) {
            self.chainId = chainId
            self.version = version
            self.name = name
            self.fee = fee
            self.timestamp = timestamp
            self.type = TransactionType.createAlias.int
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }
    
    struct Lease: BaseTransactionQueryProtocol {
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let recipient: String
        public let amount: Int64

        public init(version: Int = TransactionVersion.version_2.rawValue, chainId: String, fee: Int64, recipient: String, amount: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = []) {
            self.version = version
            self.chainId = chainId
            self.fee = fee
            self.recipient = recipient
            self.amount = amount
            self.timestamp = timestamp
            self.type = TransactionType.createLease.int
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }
    
    struct LeaseCancel: BaseTransactionQueryProtocol {
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let leaseId: String
        
        public init(version: Int = TransactionVersion.version_2.rawValue, chainId: String, fee: Int64, leaseId: String, timestamp: Int64, senderPublicKey: String, proofs: [String] = []) {
            self.version = version
            self.chainId = chainId
            self.fee = fee
            self.leaseId = leaseId
            self.timestamp = timestamp
            self.type = TransactionType.cancelLease.int
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }
    
    struct Data: BaseTransactionQueryProtocol {
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
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        public let data: [Value]

        public init(version: Int = TransactionVersion.version_1.rawValue, fee: Int64, timestamp: Int64, senderPublicKey: String, proofs: [String] = [], data: [Value], chainId: String) {
            self.type = TransactionType.data.int
            self.version = version
            self.fee = fee
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
            self.data = data
            self.chainId = chainId
        }
    }
    
    struct Transfer {
        
        public private(set) var type: Int
        public private(set) var version: Int
        public private(set) var chainId: String
        public private(set) var fee: Int64
        public private(set) var timestamp: Int64
        public private(set) var senderPublicKey: String
        public internal(set) var proofs: [String]
        
        
        public let recipient: String
        public let assetId: String
        public let amount: Int64
        public let attachment: String
        public let feeAssetId: String

        public init(version: Int = TransactionVersion.version_2.rawValue, recipient: String, assetId: String, amount: Int64, fee: Int64, attachment: String, feeAssetId: String, timestamp: Int64, senderPublicKey: String, proofs: [String] = [], chainId: String) {
            self.type = TransactionType.transfer.int
            self.version = version
            self.recipient = recipient
            self.assetId = assetId
            self.amount = amount
            self.fee = fee
            self.chainId = chainId
            self.attachment = attachment
            self.feeAssetId = feeAssetId
            self.timestamp = timestamp
            self.senderPublicKey = senderPublicKey
            self.proofs = proofs
        }
    }    
}
