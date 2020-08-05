//
//  TransactionAliasNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    /**
     The Alias transaction creates short readable alias for address
     */
    struct AliasTransaction: Codable {
        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let version: Int
        public let height: Int64?

        public let signature: String?
        public let proofs: [String]?

        /**
         Alias, short name for address in Waves blockchain.
         Alias bytes must be in [4;30]
         Alphabet: -.0123456789@_abcdefghijklmnopqrstuvwxyz
         */
        public let alias: String

        public let applicationStatus: String?
    }
}
