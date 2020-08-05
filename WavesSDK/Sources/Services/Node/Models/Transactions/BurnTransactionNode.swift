//
//  TransactionBurnNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {

    /**
      The Burn transaction irreversible deletes amount of some asset
      It's impossible to burn WAVES with the burn transaction.
     */
    struct BurnTransaction: Codable {
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
        public let chainId: UInt8?

        /**
          Id of burnable asset in Waves blockchain, different for main and test net
          */
        public let assetId: String
        /**
          Amount of asset to burn in satoshi
          */
        public let amount: Int64
        public let applicationStatus: String?
    }
}
