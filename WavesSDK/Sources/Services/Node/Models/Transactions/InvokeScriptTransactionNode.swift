//
//  InvokeScriptTransactionNode.swift
//  Alamofire
//
//  Created by rprokofev on 07/05/2019.
//

import Foundation

extension NodeService.DTO {

    /**
      Invoke script transaction is a transaction that invokes functions of the dApp script.
      dApp contains compiled functions  developed with [Waves Ride IDE]({https://ide.wavesplatform.com/)
      You can invoke one of them by name with some arguments.
     */
    public struct InvokeScriptTransaction: Decodable {

        /**
          Call the function from dApp (address or alias) with typed arguments
         */
        public struct Call: Decodable {

            /**
              Arguments for the function call
             */
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

            /**
              Function unique name
              */
            public let function: String

            /**
              List of arguments
              */
            public let args: [Args]
        }

        /**
          Payment for function of dApp. Now it works with only one payment.
         */
        public struct Payment: Decodable {
            /**
              Amount in satoshi
             */
            public let amount: Int64
            /**
              Asset Id in Waves blockchain
             */
            public let assetId: String?
        }
        
        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64

        public let timestamp: Date
        public let proofs: [String]?
        public let version: Int

        public let height: Int64?

        /**
          Asset id instead Waves for transaction commission withdrawal
         */
        public let feeAssetId: String?

        /**
          dApp – address or alias of contract with function on RIDE language
         */
        public let dApp: String

        /**
          Function name in dApp with array of arguments
         */
        public let call: Call?

        /**
          Payments for function of dApp. Now it works with only one payment.
         */
        public let payment: [Payment]
    }
}

extension NodeService.DTO.InvokeScriptTransaction.Call.Args {
    
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

