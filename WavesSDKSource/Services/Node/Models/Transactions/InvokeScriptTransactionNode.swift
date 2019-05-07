//
//  InvokeScriptTransactionNode.swift
//  Alamofire
//
//  Created by rprokofev on 07/05/2019.
//

import Foundation

extension Node.DTO {
    
    public struct InvokeScriptTransaction: Decodable {
        
        public struct Call: Decodable {
            
            public struct Args: Decodable {
                public enum Value {
                    case bool(Bool)
                    case integer(Int)
                    case string(String)
                    case binary(String)
                }
                
                public let type: String
                public let value: Value
            }
            
            public let function: String
            public let args: [Args]
        }
        
        public struct Payment: Decodable {
            public let amount: Int64
            public let assetId: String?
        }
        
        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let feeAssetId: String?
        public let timestamp: Date
        public let proofs: [String]?
        public let version: Int
        public let dappAddress: String
        public let call: Call
        public let payment: [Payment]
        public let height: Int64
    }
}

extension Node.DTO.InvokeScriptTransaction.Call.Args {
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    enum ValueKey: String {
        case boolean
        case integer
        case string
        case binary
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try container.decodeIfPresent(String.self, forKey: .type) {
            type = value
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                    debugDescription: "Not found type"))
        }
        
        if let type = ValueKey(rawValue: self.type) {
            switch type {
            case .boolean:
                value = .bool(try container.decode(Bool.self, forKey: .value))
            case .integer:
                value = .integer(try container.decode(Int.self, forKey: .value))
            case .string:
                value = .string(try container.decode(String.self, forKey: .value))
            case .binary:
                value = .binary(try container.decode(String.self, forKey: .value))
            }
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                    debugDescription: "Not found value"))
        }
    }
}

