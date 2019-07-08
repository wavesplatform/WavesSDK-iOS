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
    struct DataTransaction: Decodable {

        /**
          Data of Data transaction
         */
        public struct Data: Decodable {

            public enum Value {
                case bool(Bool)
                case integer(Int)
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
            public let type: String
            
            /**
              Data transaction value can be one of four types:
              [Long] for integer(0),
              [Boolean] for boolean(1),
              [String] for binary(2) You can use "base64:binaryString" and just "binaryString".
              and [String] string(3).
              Can't be empty string
            */
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
