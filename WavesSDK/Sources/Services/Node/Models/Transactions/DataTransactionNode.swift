//
//  TransactionDataNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    /**
     The Data transaction stores data in account data storage of the blockchain.

     The storage contains data recorded using a data transaction or an invoke script transaction.
     The maximum length of the data array is 100 elements.
     The maximum size of the data array is 140 kilobytes.
     Each element of the data array is an object that has 3 fields: key, type, value.
     The array of data cannot contain two elements with the same key field.

     Fee depends of data transaction length (0.001 per 1kb)
     */
    struct DataTransaction: Codable {
        /**
         Data of Data transaction
         */
        public struct Data: Codable {
            @frozen public enum Value {
                case bool(Bool)
                case integer(Int64)
                case string(String)
                case binary(String)
            }

            /**
             Key of data of Data transaction
             */
            public let key: String

            /**
             Type of data of the Data transaction type can be only "string", "boolean", "integer", "binary"
             */
            public let type: String?

            /**
             Data transaction value can be one of four types:
             [Long] for integer(0),
             [Boolean] for boolean(1),
             [String] for binary(2) You can use "base64:binaryString" and just "binaryString".
             and [String] string(3).
             Can't be empty string
             */
            public let value: Value?

            public init(key: String, type: String?, value: Value?) {
                self.key = key
                self.type = type
                self.value = value
            }
        }

        public let type: Int
        public let id: String
        public let chainId: UInt8?
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let height: Int64?
        public let version: Int

        public let proofs: [String]?

        public let applicationStatus: String?

        /**
         Data as JSON-string as byte array
         The value of the key field is a UTF-8 encoded string
         of length from 1 to 100 characters inclusive.
         It can be of four types - integer(0), boolean(1), binary array(2) and string(3).
         The size of value field can be from 0 to 65025 bytes.
         Example:
         "data": [
              {"key": "int", "type": "integer", "value": 24},
              {"key": "bool", "type": "boolean", "value": true},
              {"key": "blob", "type": "binary", "value": "base64:BzWHaQU="}
              {"key": "My poem", "type": "string", "value": "Oh waves!"}
         ],
         */
        public let data: [Data]

        public init(
            type: Int,
            id: String,
            chainId: UInt8?,
            sender: String,
            senderPublicKey: String,
            fee: Int64,
            timestamp: Date,
            height: Int64?,
            version: Int,
            proofs: [String]?,
            data: [Data],
            applicationStatus: String?) {
            self.type = type
            self.id = id
            self.chainId = chainId
            self.sender = sender
            self.senderPublicKey = senderPublicKey
            self.fee = fee
            self.timestamp = timestamp
            self.height = height
            self.version = version
            self.proofs = proofs
            self.data = data
            self.applicationStatus = applicationStatus
        }
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
            type = nil
        }

        if let type = self.type, let valueKey = ValueKey(rawValue: type) {
            switch valueKey {
            case .boolean:
                value = .bool(try container.decode(Bool.self, forKey: .value))
            case .integer:
                value = .integer(try container.decode(Int64.self, forKey: .value))
            case .string:
                value = .string(try container.decode(String.self, forKey: .value))
            case .binary:
                value = .binary(try container.decode(String.self, forKey: .value))
            }
        } else {
            value = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        do {
            try container.encode(key, forKey: .key)

            guard let value = self.value else {
                try container.encodeNil(forKey: .value)
                return
            }

            switch value {
            case let .bool(value):
                try container.encode(value, forKey: .value)
                try container.encode(ValueKey.boolean.rawValue, forKey: .type)

            case let .integer(value):
                try container.encode(value, forKey: .value)
                try container.encode(ValueKey.integer.rawValue, forKey: .type)

            case let .string(value):
                try container.encode(value, forKey: .value)
                try container.encode(ValueKey.string.rawValue, forKey: .type)

            case let .binary(value):
                try container.encode(value, forKey: .value)
                try container.encode(ValueKey.binary.rawValue, forKey: .type)
            }

        } catch _ {
            throw NSError(domain: "Decoder Invalid Data Value", code: 0, userInfo: nil)
        }
    }
}
