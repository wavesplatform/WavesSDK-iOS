//
//  TransactionDataNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    struct DataTransaction: Decodable {

        public struct Data: Decodable {

            public enum Value {
                case bool(Bool)
                case integer(Int)
                case string(String)
                case binary(String)
            }

            public let key: String
            public let type: String
            public let value: Value
        }

        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let height: Int64?
        public let version: Int

        public let proofs: [String]?
        public let data: [Data]
     }
}

extension NodeService.DTO.DataTransaction.Data {

    enum CodingKeys: String, CodingKey {
        case key
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

        if let value = try container.decodeIfPresent(String.self, forKey: .key) {
            key = value
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                    debugDescription: "Not found key"))
        }

        if let value = try container.decodeIfPresent(String.self, forKey: .type) {
            type = value
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                    debugDescription: "Not found value"))
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
