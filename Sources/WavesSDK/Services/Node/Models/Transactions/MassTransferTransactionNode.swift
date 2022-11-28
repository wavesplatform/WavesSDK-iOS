//
//  TransactionMassTransferNode.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 07/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

extension NodeService.DTO {
    /**
     The Mass-Transfer transaction sends a lot of transactions of asset for recipients set

     Transfer transaction is used to combine several ordinary transfer transactions
     that share single sender and asset ID (it has a list of recipients,
     and an amount to be transferred to each recipient).
     The maximum number of recipients in a single transaction is 100.

     The transfers to self are allowed, as well as zero valued transfers.
     In the recipients list, a recipient can occur several times, this is not considered an error.

     Fee depends of mass transactions count
     0.001 + 0.0005 × N, N is the number of transfers inside of a transaction
     */
    public struct MassTransferTransaction: Codable {
        /**
         * The item of the Mass-transfer transaction
         */
        public struct Transfer: Codable {
            /**
             Address or alias of Waves blockchain
             */
            public let recipient: String

            /**
             Amount of asset in satoshi
             */
            public let amount: Int64
        }

        public let type: Int
        public let id: String
        public let sender: String
        public let senderPublicKey: String
        public let fee: Int64
        public let timestamp: Date
        public let version: Int
        public let height: Int64?
        public let proofs: [String]?

        /**
         Id of transferable asset in Waves blockchain, different for main and test net
         */
        public let assetId: String?

        /**
         Additional info in Base58 converted string
         [0,140] bytes of string encoded in Base58
         */
        public let attachment: String

        /**
         Not necessary
         */
        public let transferCount: Int

        /**
         Not necessary
         */
        public let totalAmount: Int64

        /**
         Collection of recipients with amount each
         */
        public let transfers: [Transfer]

        public let applicationStatus: String?
    }
}
